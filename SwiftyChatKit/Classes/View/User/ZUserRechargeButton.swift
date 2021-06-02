
import UIKit
import SwiftBasicKit

class ZUserRechargeButton: UIButton {
    
    var z_coins: Double = 0 {
        didSet {
            self.z_lbcoins.text = self.z_coins.str
        }
    }
    private lazy var z_imagebg: UIImageView = {
        let z_temp = UIImageView.init(frame: self.bounds)
        z_temp.image = Asset.btnPurple.image
        z_temp.border(color: .clear, radius: self.height/2, width: 0)
        return z_temp
    }()
    private lazy var z_imagecoins: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(21.scale, z_imagebg.height/2 - 26.scale/2, 22.scale, 26.scale))
        z_temp.image = Asset.iconDiamond2.image
        return z_temp
    }()
    private lazy var z_lbcoins: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(58.scale, 0, 180, z_imagebg.height))
        z_temp.textColor = "#FFAC04".color
        z_temp.boldSize = 18
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_lbrecharge: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(z_imagebg.width - 43.scale - 100, 0, 100, z_imagebg.height))
        z_temp.textColor = "#E9E9E9".color
        z_temp.boldSize = 12
        z_temp.textAlignment = .right
        z_temp.text = ZString.lbRecharge.text
        return z_temp
    }()
    private lazy var z_imageright: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(z_imagebg.width - 25.scale - 7.scale, z_imagebg.height/2 - 13.scale/2, 7.scale, 13.scale))
        z_temp.image = Asset.arrowRightW.image
        return z_temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(z_imagebg)
        
        z_imagebg.addSubview(z_imagecoins)
        z_imagebg.addSubview(z_lbcoins)
        z_imagebg.addSubview(z_lbrecharge)
        z_imagebg.addSubview(z_imageright)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
