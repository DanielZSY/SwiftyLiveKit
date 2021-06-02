
import UIKit
import SwiftBasicKit

class ZMatchFilterButton: UIButton {

    override var tag: Int {
        didSet {
            switch self.tag {
            case 1:
                z_imagetype.image = Asset.matchBothW.image
                z_imagetype.width = 17.scale
                z_lbtype.text = ZString.lbBoth.text
            case 2:
                z_imagetype.image = Asset.matchFemaleW.image
                z_imagetype.width = 15.scale
                z_lbtype.text = ZString.lbFemale.text
            case 3:
                z_imagetype.image = Asset.matchMaleW.image
                z_imagetype.width = 15.scale
                z_lbtype.text = ZString.lbMale.text
            default: break
            }
        }
    }
    private lazy var z_imagetype: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(8.scale, self.height/2 - 15.scale/2, 15.scale, 15.scale))
        
        return z_temp
    }()
    private lazy var z_lbtype: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(33.scale, 0, 58.scale, self.height))
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 15
        return z_temp
    }()
    private lazy var z_imagedown: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(90.scale, self.height/2 - 3.scale, 10.scale, 6.scale))
        z_temp.image = Asset.arrowDown.image
        return z_temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(z_imagetype)
        self.addSubview(z_lbtype)
        self.addSubview(z_imagedown)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
