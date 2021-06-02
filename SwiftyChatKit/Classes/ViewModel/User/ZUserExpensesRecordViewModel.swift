
import UIKit
import SwiftBasicKit

protocol ZUserExpensesRecordViewModelDelegate: class {
    func func_requestsuccessheader(models: [ZModelExpensesRecord]?)
    func func_requestsuccessfooter(models: [ZModelExpensesRecord]?)
}
class ZUserExpensesRecordViewModel: ZBaseViewModel {
    
    let dickey = "expends"
    let localkey = "userexpends"
    
    weak var delegate: ZUserExpensesRecordViewModelDelegate?
    
    final func func_requestexpensesrecordlocal() {
        if let dic = ZLocalCacheManager.func_getlocaldata(key: localkey), let models = [ZModelExpensesRecord].deserialize(from: dic[dickey] as? [Any]) {
            self.delegate?.func_requestsuccessheader(models: models.compactMap({ (model) -> ZModelExpensesRecord? in return model }))
        }
    }
    final func func_requestexpensesrecordheader() {
        var param = [String: Any]()
        param["per_page"] = kPageCount
        param["page"] = 1
        ZNetworkKit.created.startRequest(target: .get(ZAction.apiuserexpends.api, param), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success, let dic = result.body as? [String: Any], let models = [ZModelExpensesRecord].deserialize(from: dic[self.dickey] as? [Any]) {
                ZLocalCacheManager.func_setlocaldata(dic: dic, key: self.localkey)
                self.page = 1
                self.delegate?.func_requestsuccessheader(models: models.compactMap({ (model) -> ZModelExpensesRecord? in return model }))
            } else {
                self.delegate?.func_requestsuccessheader(models: nil)
            }
        })
    }
    final func func_requestexpensesrecordfooter() {
        var param = [String: Any]()
        param["per_page"] = kPageCount
        param["page"] = self.page + 1
        ZNetworkKit.created.startRequest(target: .get(ZAction.apiuserexpends.api, param), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success, let dic = result.body as? [String: Any], let models = [ZModelExpensesRecord].deserialize(from: dic[self.dickey] as? [Any]) {
                self.page += 1
                self.delegate?.func_requestsuccessfooter(models: models.compactMap({ (model) -> ZModelExpensesRecord? in return model }))
            } else {
                self.delegate?.func_requestsuccessfooter(models: nil)
            }
        })
    }
}
