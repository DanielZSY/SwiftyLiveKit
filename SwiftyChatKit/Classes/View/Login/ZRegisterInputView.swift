
import UIKit
import SwiftBasicKit

class ZRegisterInputView: UIView {
    
    var z_ontextchange: ((_ text: String) -> Void)?
    var z_showkey: Bool = false {
        didSet {
            if self.z_showkey {
                self.z_textInput.becomeFirstResponder()
            } else {
                self.z_textInput.resignFirstResponder()
            }
        }
    }
    var z_text: String {
        return self.z_textInput.text ?? ""
    }
    override var tag: Int {
        didSet {
            var text = ZString.lbYourEMail.text
            switch self.tag {
            case 1:
                z_textInput.keyboardType = .emailAddress
            case 2:
                text = ZString.lbYourName.text
                z_textInput.placeholder = ZString.lbUserName.text
                z_textInput.maxLength = kMaxUsername
            case 3:
                text = ZString.lbYourPassword.text
                z_textInput.placeholder = ZString.lbPassword.text
                z_textInput.maxLength = kMaxPassword
                z_textInput.isSecureTextEntry = true
            default: break
            }
            z_lbtitle.text = text
            let atttext = NSMutableAttributedString.init(string: text)
            atttext.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 23)], range: NSRange.init(location: 0, length: 4))
            z_lbtitle.attributedText = atttext
        }
    }
    private lazy var z_lbtitle: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(28.scale, 0, 320.scale, 80))
        z_temp.textColor = "#7C3EF0".color
        z_temp.boldSize = 30
        z_temp.numberOfLines = 0
        z_temp.lineBreakMode = .byWordWrapping
        return z_temp
    }()
    private lazy var z_textInput: ZTextField = {
        let z_temp = ZTextField.init(frame: CGRect.init(28.scale, z_lbtitle.height + 10.scale, 320.scale, 50.scale))
        z_temp.placeholder = ZString.lbEMail.text
        z_temp.maxLength = kMaxEmail
        z_temp.isShowBorder = true
        z_temp.borderNormalColor = "#47474D".color
        z_temp.borderSelectColor = "#7037E9".color
        return z_temp
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(z_lbtitle)
        self.addSubview(z_textInput)
        
        z_textInput.onTextChanged = { text in
            self.z_ontextchange?(text)
        }
        z_textInput.onTextEndEdit = { text in
            self.z_ontextchange?(text)
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    final func func_showkey() {
        self.z_textInput.becomeFirstResponder()
    }
}
