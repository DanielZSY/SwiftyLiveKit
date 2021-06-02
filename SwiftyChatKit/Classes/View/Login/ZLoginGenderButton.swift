
import UIKit
import SwiftBasicKit

class ZLoginGenderButton: UIButton {

    var z_gender: zUserGender = .male {
        didSet {
            switch z_gender {
            case .female:
                z_imagegender.image = Asset.loginFemale.image.withRenderingMode(.alwaysTemplate)
                z_lbgender.text = ZString.lbIAM.text + ZString.lbFemale.text
            default:
                z_imagegender.image = Asset.loginMale.image.withRenderingMode(.alwaysTemplate)
                z_lbgender.text = ZString.lbIAM.text + ZString.lbMale.text
            }
        }
    }
    private lazy var z_imagegender: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(19.scale, 9.scale, 14.scale, 14.scale))
        z_temp.image = Asset.loginMale.image.withRenderingMode(.alwaysTemplate)
        z_temp.tintColor = "#FFFFFF".color
        return z_temp
    }()
    private lazy var z_imagedown: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(self.width - 12.scale - 18.scale, 13.scale, 12.scale, 8.scale))
        z_temp.image = Asset.loginGender.image
        return z_temp
    }()
    private lazy var z_lbgender: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(z_imagegender.x + z_imagegender.width + 8.scale, 0, 86.scale, self.height))
        z_temp.text = ZString.lbIAM.text + ZString.lbMale.text
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 14
        return z_temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.border(color: .clear, radius: self.height/2, width: 0)
        self.backgroundColor = "#7037E9".color
        self.addSubview(z_imagegender)
        self.addSubview(z_imagedown)
        self.addSubview(z_lbgender)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
