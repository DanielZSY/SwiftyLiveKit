
import UIKit
import SwiftBasicKit

protocol ZReportViewModelDelegate: class {
    func func_submitsuccess()
}
class ZReportViewModel: ZBaseViewModel {

    weak var delegate: ZReportViewModelDelegate?
    
    func func_requestreport(content: String, userid: String) {
        var param = [String: Any]()
        param["user_id"] = userid
        param["content"] = content
        ZProgressHUD.show(vc: self.vc)
        ZNetworkKit.created.startRequest(target: .post(ZAction.apiuserreport.api, param), responseBlock: { [weak self] result in
            ZProgressHUD.dismiss()
            guard let `self` = self else { return }
            if result.success {
                self.delegate?.func_submitsuccess()
            } else {
                ZProgressHUD.showMessage(vc: self.vc, text: result.message)
            }
        })
    }
}
