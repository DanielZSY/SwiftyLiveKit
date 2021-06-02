
import UIKit
import SwiftBasicKit

class ZLoginViewController: ZZBaseViewController {

    private lazy var z_lbtitle: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(28.scale, kStatusHeight + 67, 200.scale, 35))
        z_temp.text = ZString.btnSignIn.text
        z_temp.textColor = ZColor.shared.LabelTitleColor
        z_temp.boldSize = 30
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_textemail: ZTextField = {
        let z_temp = ZTextField.init(frame: CGRect.init(28.scale, kStatusHeight + 130, 320.scale, 50.scale))
        z_temp.placeholder = ZString.lbEMail.text
        z_temp.maxLength = kMaxEmail
        z_temp.isShowBorder = true
        z_temp.keyboardType = .emailAddress
        z_temp.backgroundColor = .clear
        return z_temp
    }()
    private lazy var z_textpassword: ZTextField = {
        let z_temp = ZTextField.init(frame: CGRect.init(28.scale, z_textemail.y + z_textemail.height + 20.scale, 320.scale, 50.scale))
        z_temp.placeholder = ZString.lbPassword.text
        z_temp.maxLength = kMaxPassword
        z_temp.isShowBorder = true
        z_temp.backgroundColor = .clear
        z_temp.isSecureTextEntry = true
        return z_temp
    }()
    private lazy var z_btnsignin: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(28.scale, z_textpassword.y + z_textpassword.height + 92.scale, 320.scale, 50.scale))
        z_temp.isEnabled = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setTitle(ZString.btnSignIn.text, for: .normal)
        z_temp.setTitle(ZString.btnSignIn.text, for: .disabled)
        z_temp.setTitleColor("#FFFFFF".color, for: .normal)
        z_temp.setTitleColor("#FFFFFF".color, for: .disabled)
        z_temp.setBackgroundImage(UIImage.init(color: "#7037E9".color), for: .normal)
        z_temp.setBackgroundImage(UIImage.init(color: "#1E1925".color), for: .disabled)
        z_temp.titleLabel?.boldSize = 15
        z_temp.border(color: .clear, radius: 50.scale/2, width: 0)
        return z_temp
    }()
    private let z_viewmodel: ZLoginViewModel = ZLoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        z_viewmodel.vc = self
        self.view.addSubview(z_lbtitle)
        self.view.addSubview(z_textemail)
        self.view.addSubview(z_textpassword)
        self.view.addSubview(z_btnsignin)
        
        func_setupevent()
    }
    private func func_setupevent() {
        z_textemail.onTextEndEdit = { text in
            self.z_viewmodel.z_email = text
            let password = self.z_textpassword.text ?? ""
            self.z_btnsignin.isEnabled = (text.isEmail() && password.isPassword())
        }
        z_textemail.onTextChanged = { text in
            self.z_viewmodel.z_email = text
            let password = self.z_textpassword.text ?? ""
            self.z_btnsignin.isEnabled = (text.isEmail() && password.isPassword())
        }
        z_textpassword.onTextEndEdit = { text in
            self.z_viewmodel.z_password = text
            let email = self.z_textemail.text ?? ""
            self.z_btnsignin.isEnabled = (email.isEmail() && text.isPassword())
        }
        z_textpassword.onTextChanged = { text in
            self.z_viewmodel.z_password = text
            let email = self.z_textemail.text ?? ""
            self.z_btnsignin.isEnabled = (email.isEmail() && text.isPassword())
        }
        z_btnsignin.addTarget(z_viewmodel, action: "func_signinclick", for: .touchUpInside)
        self.view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: "func_viewtap:"))
    }
    @objc private func func_viewtap(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended: self.view.endEditing(true)
        default: break
        }
    }
}
