
import UIKit
import SwiftBasicKit

class ZUserEditTextView: UIView {
    
    var z_aboutme: String {
        get {
            return self.z_textview.text
        }
        set(value) {
            self.z_textview.text = value
        }
    }
    var z_onTextBeginEdit: (() -> Void)?
    var z_onTextChangedEdit: ((_ text: String) -> Void)?
    
    private lazy var z_lbtitle: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(15.scale, 5, 300.scale, 25))
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 15
        z_temp.text = ZString.lbAboutMe.text
        return z_temp
    }()
    private lazy var z_textview: ZTextView = {
        let z_temp = ZTextView.init(frame: CGRect.init(17.scale, 30, 342.scale, self.height - 31))
        z_temp.placeholder = ZString.lbAboutMePlaceholder.text
        z_temp.maxLength = kMaxAboutme
        z_temp.isMultiline = false
        z_temp.returnKeyType = .done
        z_temp.keyboardAppearance = .dark
        return z_temp
    }()
    private lazy var z_viewline: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(z_textview.x, z_textview.y + z_textview.height, z_textview.width, 1))
        z_temp.backgroundColor = "#47474D".color
        return z_temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(z_lbtitle)
        self.addSubview(z_textview)
        self.addSubview(z_viewline)
        
        z_textview.onTextBeginEdit = {
            self.z_onTextBeginEdit?()
        }
        z_textview.onTextChangedEdit = { text in
            self.z_onTextChangedEdit?(text)
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
