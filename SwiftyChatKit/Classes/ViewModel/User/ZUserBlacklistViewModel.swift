
import UIKit
import SwiftBasicKit

protocol ZUserBlacklistViewModelDelegate: class {
    func func_unblicksuccess(row: Int, tag: Int)
    func func_requestheadersuccess(models: [ZModelUserInfo]?)
    func func_requestfootersuccess(models: [ZModelUserInfo]?)
}
class ZUserBlacklistViewModel: ZBaseViewModel {
    
    let dickey = "blacks"
    let localkey = "userblacks"
    
    weak var delegate: ZUserBlacklistViewModelDelegate?
    
    final func func_requestlocal() {
        if let dic = ZLocalCacheManager.func_getlocaldata(key: localkey), let models = [ZModelUserInfo].deserialize(from: dic[self.dickey] as? [Any]) {
            self.delegate?.func_requestheadersuccess(models: models.compactMap({ (model) -> ZModelUserInfo? in return model }))
        }
    }
    final func func_requestheader() {
        var param = [String: Any]()
        param["per_page"] = kPageCount
        param["page"] = 1
        ZNetworkKit.created.startRequest(target: .get(ZAction.apiuserblacklist.api, param), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success, let dic = result.body as? [String: Any], let models = [ZModelUserInfo].deserialize(from: dic[self.dickey] as? [Any]) {
                ZLocalCacheManager.func_setlocaldata(dic: dic, key: self.localkey)
                self.page = 1
                self.delegate?.func_requestheadersuccess(models: models.compactMap({ (model) -> ZModelUserInfo? in return model }))
            } else {
                self.delegate?.func_requestheadersuccess(models: nil)
            }
        })
    }
    final func func_requestfooter() {
        var param = [String: Any]()
        param["per_page"] = kPageCount
        param["page"] = self.page + 1
        ZNetworkKit.created.startRequest(target: .get(ZAction.apiuserblacklist.api, param), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success, let dic = result.body as? [String: Any], let models = [ZModelUserInfo].deserialize(from: dic[self.dickey] as? [Any]) {
                self.page += 1
                self.delegate?.func_requestfootersuccess(models: models.compactMap({ (model) -> ZModelUserInfo? in return model }))
            } else {
                self.delegate?.func_requestfootersuccess(models: nil)
            }
        })
    }
    final func func_unblockuser(userid: String, row: Int, tag: Int) {
        var param = [String: Any]()
        param["user_id"] = userid
        ZProgressHUD.show(vc: self.vc)
        ZNetworkKit.created.startRequest(target: .post(ZAction.apiuserunblock.api, param), responseBlock: { [weak self] result in
            ZProgressHUD.dismiss()
            guard let `self` = self else { return }
            if result.success {
                self.delegate?.func_unblicksuccess(row: row, tag: tag)
            } else {
                ZProgressHUD.showMessage(vc: self.vc, text: result.message)
            }
        })
    }
}
