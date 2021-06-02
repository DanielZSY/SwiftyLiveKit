
import UIKit
import SwiftBasicKit

protocol ZUserFeedbackViewModelDelegate: class {
    func func_submitsuccess()
}
class ZUserFeedbackViewModel: ZBaseViewModel {

    weak var delegate: ZUserFeedbackViewModelDelegate?
    
    func func_requestfeedback(content: String) {
        var param = [String: Any]()
        param["content"] = content
        ZProgressHUD.show(vc: self.vc)
        ZNetworkKit.created.startRequest(target: .post(ZAction.apifeedback.api, param), responseBlock: { [weak self] result in
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
