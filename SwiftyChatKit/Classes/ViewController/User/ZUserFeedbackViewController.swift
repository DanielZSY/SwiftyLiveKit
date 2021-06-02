
import UIKit
import SwiftBasicKit

class ZUserFeedbackViewController: ZZBaseViewController {
    
    private lazy var z_viewtext: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(15.scale, kTopNavHeight + 10, 345.scale, 250.scale))
        z_temp.backgroundColor = "#1E1925".color
        z_temp.border(color: .clear, radius: 10, width: 0)
        return z_temp
    }()
    private lazy var z_textview: ZTextView = {
        let z_temp = ZTextView.init(frame: CGRect.init(20.scale, 20.scale, z_viewtext.width - 40.scale, z_viewtext.height - 40.scale))
        z_temp.backgroundColor = "#1E1925".color
        z_temp.placeholderColor = "#515158".color
        z_temp.placeholder = ZString.lbFeedbackPlaceholder.text
        z_temp.keyboardAppearance = .dark
        z_temp.maxLength = kMaxFeedback
        return z_temp
    }()
    private lazy var z_btnsubmit: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(15.scale, z_viewtext.y + z_viewtext.height + 30, 345.scale, 50.scale))
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.backgroundColor = "#7037E9".color
        z_temp.titleLabel?.boldSize = 15
        z_temp.setTitle(ZString.btnSubmit.text, for: .normal)
        z_temp.setTitleColor("#FFFFFF".color, for: .normal)
        z_temp.border(color: .clear, radius: 25.scale, width: 0)
        return z_temp
    }()
    private let z_viewmodel: ZUserFeedbackViewModel = ZUserFeedbackViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        z_viewmodel.vc = self
        self.title = ZString.lbFeedback.text
        
        self.view.addSubview(z_viewtext)
        self.view.addSubview(z_btnsubmit)
        self.z_viewtext.addSubview(z_textview)
        
        z_btnsubmit.addTarget(self, action: "func_btnsubmitclick", for: .touchUpInside)
        
        z_viewmodel.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.z_textview.becomeFirstResponder()
    }
    deinit {
        z_viewmodel.delegate = nil
    }
    @objc private func func_btnsubmitclick() {
        self.view.endEditing(true)
        let content = z_textview.text
        guard content.count >= kMinFeedback, content.count <= kMaxFeedback else {
            ZProgressHUD.showMessage(vc: self, text: ZString.lbFeedbackPlaceholder.text)
            return
        }
        self.z_viewmodel.func_requestfeedback(content: content)
    }
}
extension ZUserFeedbackViewController: ZUserFeedbackViewModelDelegate {
    func func_submitsuccess() {
        self.z_textview.text = ""
        ZAlertView.showAlertView(vc: self, message: ZString.alertFeedbackSuccessPrompt.text, completeBlock: {
            ZRouterKit.pop(fromVC: self)
        })
    }
}
