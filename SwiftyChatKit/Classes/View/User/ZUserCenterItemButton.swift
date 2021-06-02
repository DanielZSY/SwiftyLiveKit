
import UIKit
import SwiftBasicKit

class ZUserCenterItemButton: UIButton {
    
    var z_type: String = "" {
        didSet {
            switch self.z_type {
            case "EitProfile":
                z_imageicon.image = Asset.userEditProfile.image
                z_lbtitle.text = ZString.lbEditProfile.text
            case "ExpensesRecord":
                z_imageicon.image = Asset.userRecord.image
                z_lbtitle.text = ZString.lbExpensesrecord.text
            case "Follow":
                z_imageicon.image = Asset.userFellow.image
                z_lbtitle.text = ZString.btnFollow.text
            case "Blacklist":
                z_imageicon.image = Asset.userBlacklist.image
                z_lbtitle.text = ZString.lbBlacklist.text
                z_imageicon.frame = CGRect.init(z_imageicon.x, self.height/2 - 23/2, 20, 23)
            case "Settings":
                z_imageicon.image = Asset.userSettings.image
                z_lbtitle.text = ZString.lbSettings.text
            default: break
            }
        }
    }
    private lazy var z_imageicon: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(43.scale, self.height/2 - 22/2, 22, 22))
        
        return z_temp
    }()
    private lazy var z_lbtitle: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(80.scale, 0, 200.scale, self.height))
        z_temp.textColor = "#606068".color
        z_temp.boldSize = 14
        return z_temp
    }()
    private lazy var z_imageright: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(321.scale, self.height/2 - 13.scale/2, 7.scale, 13.scale))
        z_temp.image = Asset.arrowRightW.image.withRenderingMode(.alwaysTemplate)
        z_temp.tintColor = "#606068".color
        return z_temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(z_imageicon)
        self.addSubview(z_lbtitle)
        self.addSubview(z_imageright)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
