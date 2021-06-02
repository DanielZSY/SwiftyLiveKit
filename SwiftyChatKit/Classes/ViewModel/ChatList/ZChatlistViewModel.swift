
import UIKit
import SwiftBasicKit

protocol ZChatlistViewModelDelegate: class {
    func func_requestcallssuccess(models: [ZModelCallRecord]?)
    func func_requestmessagesheadersuccess(models: [ZModelMessageRecord]?)
    func func_requestmessagesfootersuccess(models: [ZModelMessageRecord]?)
}
class ZChatlistViewModel: ZBaseViewModel {
    
    let dickey = "calls"
    let localkey = "userchatcalls"
    
    weak var delegate: ZChatlistViewModelDelegate?
    
    final func func_requestcalllocal() {
        var models: [ZModelCallRecord]?
        self.func_requestlocaldata(models: &models, key: localkey, dickey: dickey)
        self.delegate?.func_requestcallssuccess(models: models)
    }
    final func func_requestcallarray() {
        var param = [String: Any]()
        param["per_page"] = 10
        param["page"] = 1
        ZNetworkKit.created.startRequest(target: .get(ZAction.apicalllist.api, param), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success, let dic = result.body as? [String: Any], let models = [ZModelCallRecord].deserialize(from: dic[self.dickey] as? [Any]) {
                ZLocalCacheManager.func_setlocaldata(dic: dic, key: self.localkey)
                self.delegate?.func_requestcallssuccess(models: models.compactMap({ (model) -> ZModelCallRecord? in return model }))
            } else {
                self.delegate?.func_requestcallssuccess(models: nil)
            }
        })
    }
    final func func_requestcustomerservice() {
        ZNetworkKit.created.startRequest(target: .get(ZAction.apisupport.api, nil), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success, let dic = result.body as? [String: Any], let model = ZModelUserBase.deserialize(from: dic) {
                model.role = .customerService
                var user: ZModelMessageRecord?
                ZSQLiteKit.getModel(model: &user, filter: "userid = ? AND login_userid = ?", values: [model.userid, ZSettingKit.shared.userId])
                if user == nil { user = ZModelMessageRecord.init() }
                user?.message_user = model
                ZSQLiteKit.setModel(model: user!)
            }
        })
    }
    final func func_requestmessagearrayheader() {
        self.page = 1
        var models: [ZModelMessageRecord]?
        ZSQLiteKit.getArrayMessageRecord(models: &models, page: self.page)
        self.delegate?.func_requestmessagesheadersuccess(models: models)
    }
    final func func_requestmessagearrayfooter() {
        self.page += 1
        var models: [ZModelMessageRecord]?
        ZSQLiteKit.getArrayMessageRecord(models: &models, page: self.page)
        self.delegate?.func_requestmessagesfootersuccess(models: models)
    }
}
