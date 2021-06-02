
import UIKit
import SwiftBasicKit

class ZUserIncognitoModeView: UIView {

    var z_onmode: Bool = true {
        didSet {
            self.z_switch.isOn = self.z_onmode
        }
    }
    var z_onswitchchange: ((_ on: Bool) -> Void)?
    
    private lazy var z_imagesee: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(43.scale, 6, 21, 11))
        z_temp.image = Asset.userincognito.image
        return z_temp
    }()
    private lazy var z_lbtitle: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(70.scale, 0, 200.scale, 23))
        z_temp.textColor = "#493443".color
        z_temp.boldSize = 18
        z_temp.text = ZString.lbIncognitomode.text
        return z_temp
    }()
    private lazy var z_lbdesc: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(44, z_lbtitle.y + z_lbtitle.height, 160, 35))
        z_temp.textColor = "#606068".color
        z_temp.boldSize = 12
        z_temp.text = ZString.lbIncognitomodeDesc.text
        z_temp.numberOfLines = 0
        return z_temp
    }()
    private lazy var z_switch: ZSwitchButton = {
        let z_temp = ZSwitchButton.init(frame: CGRect.init(273.scale, self.height/2 - 26.scale/2, 55.scale, 26.scale))
        z_temp.isOn = true
        return z_temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(z_imagesee)
        self.addSubview(z_lbtitle)
        self.addSubview(z_lbdesc)
        self.addSubview(z_switch)
        
        z_switch.addTarget(self, action: "func_switchvaluechange", for: .touchUpInside)
    }
    @objc private func func_switchvaluechange() {
        z_switch.isOn = !z_switch.isOn
        self.z_onswitchchange?(z_switch.isOn)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
