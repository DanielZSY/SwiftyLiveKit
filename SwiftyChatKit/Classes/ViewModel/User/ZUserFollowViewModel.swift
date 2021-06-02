
import UIKit
import SwiftBasicKit

protocol ZUserFollowViewModelDelegate: class {
    func func_unfollowsuccess(row: Int, tag: Int)
    func func_requestfollowingheadersuccess(models: [ZModelUserInfo]?)
    func func_requestfollowersheadersuccess(models: [ZModelUserInfo]?)
    func func_requestfollowingfootersuccess(models: [ZModelUserInfo]?)
    func func_requestfollowersfootersuccess(models: [ZModelUserInfo]?)
}
class ZUserFollowViewModel: ZBaseViewModel {
    
    let followingsdickey = "followings"
    let followingslocalkey = "userfollowings"
    let followersdickey = "followers"
    let followerslocalkey = "userfollowers"
    
    weak var delegate: ZUserFollowViewModelDelegate?
    
    private var z_pagefollowing: Int = 1
    private var z_pagefollowers: Int = 1
    
    final func func_requestfollowinglocal() {
        if let dic = ZLocalCacheManager.func_getlocaldata(key: followingslocalkey), let models = [ZModelUserInfo].deserialize(from: dic[followingsdickey] as? [Any]) {
            self.delegate?.func_requestfollowingheadersuccess(models: models.compactMap({ (model) -> ZModelUserInfo? in return model }))
        }
    }
    final func func_requestfollowerslocal() {
        if let dic = ZLocalCacheManager.func_getlocaldata(key: followerslocalkey), let models = [ZModelUserInfo].deserialize(from: dic[self.followersdickey] as? [Any]) {
            self.delegate?.func_requestfollowersheadersuccess(models: models.compactMap({ (model) -> ZModelUserInfo? in return model }))
        }
    }
    final func func_requestfollowingheader() {
        var param = [String: Any]()
        param["per_page"] = kPageCount
        param["page"] = 1
        ZNetworkKit.created.startRequest(target: .get(ZAction.apiuserfollowings.api, param), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success, let dic = result.body as? [String: Any], let models = [ZModelUserInfo].deserialize(from: dic[self.followingsdickey] as? [Any]) {
                ZLocalCacheManager.func_setlocaldata(dic: dic, key: self.followingslocalkey)
                self.z_pagefollowing = 1
                self.delegate?.func_requestfollowingheadersuccess(models: models.compactMap({ (model) -> ZModelUserInfo? in return model }))
            } else {
                self.delegate?.func_requestfollowingheadersuccess(models: nil)
            }
        })
    }
    final func func_requestfollowersheader() {
        var param = [String: Any]()
        param["per_page"] = kPageCount
        param["page"] = 1
        ZNetworkKit.created.startRequest(target: .get(ZAction.apiuserfollowers.api, param), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success, let dic = result.body as? [String: Any], let models = [ZModelUserInfo].deserialize(from: dic[self.followersdickey] as? [Any]) {
                ZLocalCacheManager.func_setlocaldata(dic: dic, key: self.followerslocalkey)
                self.z_pagefollowers = 1
                self.delegate?.func_requestfollowersheadersuccess(models: models.compactMap({ (model) -> ZModelUserInfo? in return model }))
            } else {
                self.delegate?.func_requestfollowersheadersuccess(models: nil)
            }
        })
    }
    final func func_requestfollowingfooter() {
        var param = [String: Any]()
        param["per_page"] = kPageCount
        param["page"] = self.z_pagefollowing + 1
        ZNetworkKit.created.startRequest(target: .get(ZAction.apiuserfollowings.api, param), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success, let dic = result.body as? [String: Any], let models = [ZModelUserInfo].deserialize(from: dic[self.followingsdickey] as? [Any]) {
                self.z_pagefollowing += 1
                self.delegate?.func_requestfollowingfootersuccess(models: models.compactMap({ (model) -> ZModelUserInfo? in return model }))
            } else {
                self.delegate?.func_requestfollowingfootersuccess(models: nil)
            }
        })
    }
    final func func_requestfollowersfooter() {
        var param = [String: Any]()
        param["per_page"] = kPageCount
        param["page"] = self.z_pagefollowers + 1
        ZNetworkKit.created.startRequest(target: .get(ZAction.apiuserfollowers.api, param), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success, let dic = result.body as? [String: Any], let models = [ZModelUserInfo].deserialize(from: dic[self.followersdickey] as? [Any]) {
                self.z_pagefollowers += 1
                self.delegate?.func_requestfollowersfootersuccess(models: models.compactMap({ (model) -> ZModelUserInfo? in return model }))
            } else {
                self.delegate?.func_requestfollowersfootersuccess(models: nil)
            }
        })
    }
    final func func_unfollowuser(userid: String, row: Int, tag: Int) {
        var param = [String: Any]()
        param["user_id"] = userid
        ZProgressHUD.show(vc: self.vc)
        ZNetworkKit.created.startRequest(target: .post(ZAction.apiuserunfollow.api, param), responseBlock: { [weak self] result in
            ZProgressHUD.dismiss()
            guard let `self` = self else { return }
            if result.success {
                self.delegate?.func_unfollowsuccess(row: row, tag: tag)
            } else {
                ZProgressHUD.showMessage(vc: self.vc, text: result.message)
            }
        })
    }
}
