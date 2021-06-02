
import UIKit
import SwiftBasicKit

class ZReportViewController: ZZBaseViewController {
    
    var z_model: ZModelUserInfo? {
        didSet {
            self.title = ZString.lbReport.text + ": " + (self.z_model?.nickname ?? "")
        }
    }
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
        z_temp.maxLength = kMaxReport
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
    private let z_viewmodel: ZReportViewModel = ZReportViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        z_viewmodel.vc = self
        self.view.addSubview(self.z_viewtext)
        self.view.addSubview(self.z_btnsubmit)
        self.z_viewtext.addSubview(self.z_textview)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: "func_viewtap:"))
        self.z_btnsubmit.addTarget(self, action: "func_click_submit", for: .touchUpInside)
        
        self.z_viewmodel.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.z_textview.becomeFirstResponder()
    }
    deinit {
        self.z_viewmodel.delegate = nil
    }
    @objc private func func_viewtap(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended: self.view.endEditing(true)
        default: break
        }
    }
    @objc private func func_click_submit() {
        self.view.endEditing(true)
        let content = self.z_textview.text
        guard content.length >= kMinReport, content.length <= kMaxReport else {
            ZProgressHUD.showMessage(vc: self, text: ZString.lbFeedbackPlaceholder.text)
            return
        }
        self.z_viewmodel.func_requestreport(content: content, userid: self.z_model?.userid ?? "")
    }
}
extension ZReportViewController: ZReportViewModelDelegate {
    func func_submitsuccess() {
        self.z_textview.text = ""
        ZAlertView.showAlertView(vc: self, message: ZString.alertReportSuccessPrompt.text, completeBlock: {
            ZRouterKit.pop(fromVC: self)
        })
    }
}
