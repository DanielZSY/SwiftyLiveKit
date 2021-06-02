
import UIKit
import SwiftBasicKit

class ZUserSettingsItemButton: UIButton {
    
    var z_showlocation: Bool {
        get {
            return self.z_switch.isOn
        }
        set(value) {
            self.z_switch.isOn = value
        }
    }
    var z_version: String = "" {
        didSet {
            self.z_lbdesc.text = self.z_version
        }
    }
    var z_cachesize: UInt64 = 0 {
        didSet {
            self.z_lbdesc.text = String(format: "%.2fMB", (Double(self.z_cachesize)/Double(1024)/Double(1024)))
        }
    }
    var z_type: String = "" {
        didSet {
            switch self.z_type {
            case "Deleteaccount":
                z_imageright.isHidden = false
                z_lbtitle.text = ZString.lbDeleteaccount.text
            case "ClearCache":
                z_lbdesc.isHidden = false
                z_imageright.isHidden = false
                z_lbtitle.text = ZString.lbClearCache.text
            case "Feedback":
                z_imageright.isHidden = false
                z_lbtitle.text = ZString.lbFeedback.text
            case "RateusinAppStore":
                z_imageright.isHidden = false
                z_lbtitle.text = ZString.lbRateusinAppStore.text
            case "TermsofService":
                z_imageright.isHidden = false
                z_lbtitle.text = ZString.lbTermsofService.text
            case "ShowLocation":
                z_switch.isHidden = false
                z_switch.addTarget(self, action: "func_switchvaluechange", for: .touchUpInside)
                z_lbtitle.text = ZString.lbShowLocation.text
            case "Version":
                z_lbdesc.isHidden = false
                z_lbtitle.text = ZString.lbVersion.text
            default: break
            }
        }
    }
    var z_onswitchchange: ((_ on: Bool) -> Void)?
    
    private lazy var z_lbtitle: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(21.scale, 0, 200.scale, self.height))
        z_temp.adjustsFontSizeToFitWidth = true
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 15
        return z_temp
    }()
    private lazy var z_lbdesc: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(self.width - 44.scale - 100.scale, 0, 100.scale, self.height))
        z_temp.isHidden = true
        z_temp.adjustsFontSizeToFitWidth = true
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 15
        z_temp.textAlignment = .right
        return z_temp
    }()
    private lazy var z_imageright: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(self.width - 20.scale - 8.scale, self.height/2 - 15.scale/2, 8.scale, 15.scale))
        z_temp.isHidden = true
        z_temp.image = Asset.arrowRight.image
        return z_temp
    }()
    private lazy var z_switch: ZSwitchButton = {
        let z_temp = ZSwitchButton.init(frame: CGRect.init(300.scale, self.height/2 - 25.scale/2, 55.scale, 25.scale))
        z_temp.isOn = true
        z_temp.isHidden = true
        return z_temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(z_lbtitle)
        self.addSubview(z_lbdesc)
        self.addSubview(z_imageright)
        self.addSubview(z_switch)
        self.backgroundColor = "#1E1925".color
    }
    @objc private func func_switchvaluechange() {
        z_switch.isOn = !z_switch.isOn
        self.z_onswitchchange?(z_switch.isOn)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
