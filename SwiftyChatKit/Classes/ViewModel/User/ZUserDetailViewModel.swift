
import UIKit
import Foundation
import SwiftBasicKit

protocol ZUserDetailViewModelDelegate: class {
    func func_requestdetailsuccess(model: ZModelUserInfo)
    func func_requestranksuccess(models: [ZModelUserInfo]?)
}
class ZUserDetailViewModel: ZBaseViewModel {
    
    weak var delegate: ZUserDetailViewModelDelegate?
    
    final func func_requestuserdetail(userid: String) {
        let key = "userdetail" + userid + ZSettingKit.shared.userId
        if let dic = ZLocalCacheManager.func_getlocaldata(key: key), let model = ZModelUserInfo.deserialize(from: dic) {
            self.delegate?.func_requestdetailsuccess(model: model)
        }
        var param = [String: Any]()
        param["user_id"] = userid
        ZNetworkKit.created.startRequest(target: .get(ZAction.apiuserdetail.api, param), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success, let dic = result.body as? [String: Any], let model = ZModelUserInfo.deserialize(from: dic) {
                ZLocalCacheManager.func_setlocaldata(dic: dic, key: key)
                self.delegate?.func_requestdetailsuccess(model: model)
            }
        })
    }
    final func func_requestfollowanchor(userid: String, callback: ((_ success: Bool, _ message: String) -> Void)?) {
        var param = [String: Any]()
        param["user_id"] = userid
        ZNetworkKit.created.startRequest(target: .post(ZAction.apiuserfollow.api, param), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success {
                ZProgressHUD.showMessage(vc: self.vc, text: ZString.successFollow.text)
            } else {
                ZProgressHUD.showMessage(vc: self.vc, text: result.message)
            }
            callback?(result.success, result.message)
        })
    }
    final func func_requestpullblackanchor(userid: String, callback: ((_ success: Bool, _ message: String) -> Void)?) {
        var param = [String: Any]()
        param["user_id"] = userid
        ZNetworkKit.created.startRequest(target: .post(ZAction.apiuserblock.api, param), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success {
                ZProgressHUD.showMessage(vc: self.vc, text: ZString.successBlack.text)
            } else {
                ZProgressHUD.showMessage(vc: self.vc, text: result.message)
            }
            callback?(result.success, result.message)
        })
    }
    final func func_requestcancelpullblackanchor(userid: String, callback: ((_ success: Bool, _ message: String) -> Void)?) {
        var param = [String: Any]()
        param["user_id"] = userid
        ZNetworkKit.created.startRequest(target: .post(ZAction.apiuserunblock.api, param), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if !result.success {
                ZProgressHUD.showMessage(vc: self.vc, text: result.message)
            }
            callback?(result.success, result.message)
        })
    }
    final func func_requestrankarray(userid: String) {
        if let dic = ZLocalCacheManager.func_getlocaldata(key: "userdetailrankarray" + userid), let models = [ZModelUserInfo].deserialize(from: dic["rank"] as? [Any]) {
            self.delegate?.func_requestranksuccess(models: models.compactMap({ (model) -> ZModelUserInfo? in return model }))
        }
        var param = [String: Any]()
        param["type"] = kEnumRankType.Lover.rawValue
        param["range"] = kEnumRankTime.Week.rawValue
        param["anchor_id"] = userid
        param["per_page"] = 3
        param["page"] = 1
        ZNetworkKit.created.startRequest(target: .get(ZAction.apirank.api, param), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success, let dic = result.body as? [String: Any], let models = [ZModelUserInfo].deserialize(from: dic["rank"] as? [Any]) {
                ZLocalCacheManager.func_setlocaldata(dic: dic, key: "userdetailrankarray" + userid)
                self.delegate?.func_requestranksuccess(models: models.compactMap({ (model) -> ZModelUserInfo? in return model }))
            }
        })
    }
}
