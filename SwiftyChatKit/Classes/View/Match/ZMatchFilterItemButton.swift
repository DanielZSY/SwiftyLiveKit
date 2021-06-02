
import UIKit
import SwiftBasicKit

class ZMatchFilterItemButton: UIButton {

    override var isSelected: Bool {
        didSet {
            self.func_changeselect()
        }
    }
    override var tag: Int {
        didSet {
            switch self.tag {
            case 1:
                z_imagetype.image = Asset.matchBothW.image.withRenderingMode(.alwaysTemplate)
                z_imagetype.width = 30.scale
                z_imagetype.x = self.width/2 - 30.scale/2
                z_lbtype.text = ZString.lbBoth.text
                z_lbcoins.text = ZConfig.shared.match_price_both.str
            case 2:
                z_imagetype.image = Asset.matchFemaleW.image.withRenderingMode(.alwaysTemplate)
                z_lbtype.text = ZString.lbFemale.text
                z_lbcoins.text = ZConfig.shared.match_price_male.str
            case 3:
                z_imagetype.image = Asset.matchMaleW.image.withRenderingMode(.alwaysTemplate)
                z_lbtype.text = ZString.lbMale.text
                z_lbcoins.text = ZConfig.shared.match_price_female.str
            default: break
            }
        }
    }
    private lazy var z_imagetype: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(self.width/2 - 26.scale/2, 13.scale, 26.scale, 26.scale))
        
        return z_temp
    }()
    private lazy var z_lbtype: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(0, z_imagetype.y + z_imagetype.height + 8.scale, self.width, 22))
        z_temp.textColor = "#E9E9E9".color
        z_temp.textAlignment = .center
        z_temp.boldSize = 15
        return z_temp
    }()
    private lazy var z_imagecoins: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(self.width/2 - 12.scale, 73.scale, 12.scale, 14.scale))
        z_temp.image = Asset.iconDiamond1.image
        return z_temp
    }()
    private lazy var z_lbcoins: UILabel = {
        let z_tempx = z_imagecoins.x + z_imagecoins.width + 3.scale
        let z_temp = UILabel.init(frame: CGRect.init(z_tempx, z_imagecoins.y - 3, self.width - z_tempx, 20))
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 12
        z_temp.text = "0"
        return z_temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(z_imagetype)
        self.addSubview(z_lbtype)
        self.addSubview(z_imagecoins)
        self.addSubview(z_lbcoins)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private func func_changeselect() {
        if self.isSelected {
            z_imagetype.tintColor = "#FFFFFF".color
            z_lbtype.textColor = "#FFFFFF".color
            z_lbcoins.textColor = "#FFFFFF".color
            self.backgroundColor = "#7037E9".color
        } else {
            z_imagetype.tintColor = "#655C72".color
            z_lbtype.textColor = "#655C72".color
            z_lbcoins.textColor = "#655C72".color
            self.backgroundColor = "#2D2538".color
        }
    }
}
