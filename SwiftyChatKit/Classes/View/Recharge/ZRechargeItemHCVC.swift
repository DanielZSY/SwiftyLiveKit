
import UIKit
import SwiftBasicKit

class ZRechargeItemHCVC: ZBaseCVC {
    
    var z_modelRecharge: ZModelRecharge? {
        didSet {
            self.func_contentchange()
        }
    }
    var z_modelPurchase: ZModelPurchase?
    override var tag: Int {
        didSet {
            switch self.tag {
            case 0:
                z_viewmain.border(color: "#7037E9".color, radius: 15, width: 3)
            default:
                z_viewmain.border(color: "#1E1925".color, radius: 15, width: 3)
            }
        }
    }
    private lazy var z_viewmain: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(16.scale, 10.scale, 344.scale, 75.scale))
        z_temp.backgroundColor = "#1E1925".color
        return z_temp
    }()
    private lazy var z_imagecoins: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(23.scale, 16.scale, 29.scale, 34.scale))
        z_temp.image = Asset.iconDiamond3.image
        return z_temp
    }()
    private lazy var z_lbcoins: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(70.scale, z_imagecoins.y, 150.scale, 34.scale))
        z_temp.boldSize = 18
        z_temp.textColor = "#E9E9E9".color
        return z_temp
    }()
    private lazy var z_lbprice: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(253.scale, 22.scale, 72.scale, 31.scale))
        z_temp.fontSize = 12
        z_temp.textAlignment = .center
        z_temp.textColor = "#E9E9E9".color
        z_temp.backgroundColor = "#7037E9".color
        z_temp.border(color: .clear, radius: 31.scale/2, width: 0)
        return z_temp
    }()
    private lazy var z_lboff: UILabel = {
        let z_temp = UILabel.init(frame: z_imageoff.bounds)
        z_temp.boldSize = 12
        z_temp.textAlignment = .center
        z_temp.textColor = "#FFFFFF".color
        return z_temp
    }()
    private lazy var z_imageoff: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(0, z_viewmain.height - 21, 86.scale, 21))
        z_temp.isHidden = true
        z_temp.image = Asset.btnPurple.image
        z_temp.backgroundColor = "#1E1925".color
        let z_temp_path = UIBezierPath.init(roundedRect: z_temp.bounds, byRoundingCorners: [.topRight], cornerRadii: CGSize.init(width: 21, height: 21))
        let z_temp_mask = CAShapeLayer.init()
        z_temp_mask.path = z_temp_path.cgPath
        z_temp.layer.mask = z_temp_mask
        return z_temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(z_viewmain)
        self.z_viewmain.addSubview(z_imagecoins)
        self.z_viewmain.addSubview(z_lbcoins)
        self.z_viewmain.addSubview(z_lbprice)
        self.z_viewmain.addSubview(z_imageoff)
        self.z_imageoff.addSubview(z_lboff)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private func func_contentchange() {
        guard let modelp = self.z_modelPurchase else { return }
        guard let modelr = self.z_modelRecharge else { return }
        let givetoken = modelr.token_amount - modelr.original_token_amount
        z_imageoff.isHidden = givetoken <= 0
        z_lbprice.text = "$" + modelr.price.strDouble
        if givetoken > 0 {
            let token = modelr.original_token_amount.str
            let otoken = " +" + givetoken.str
            let atttoken = NSMutableAttributedString.init(string: token + otoken)
            atttoken.addAttributes([NSAttributedString.Key.foregroundColor: "#E9E9E9".color], range: NSRange.init(location: 0, length: token.count))
            z_lbcoins.textColor = "#FFC64D".color
            z_lbcoins.attributedText = atttoken
            let givescale = (Double(givetoken) / Double(modelr.original_token_amount)) * 100
            z_lboff.text = givescale.str + "%" + ZString.lbOFF.text
        } else {
            z_lbcoins.textColor = "#E9E9E9".color
            z_lbcoins.text = modelr.original_token_amount.str
            z_lboff.text = ""
        }
    }
}
