
import UIKit
import SwiftBasicKit

class ZRankItemCVC: ZBaseCVC {
    
    var z_type: kEnumRankType = .Anchor {
        didSet {
            switch z_type {
            case .Anchor: self.z_btnicon.setImage(Asset.rankHot.image, for: .normal)
            case .Gold: self.z_btnicon.setImage(Asset.rankMoney.image, for: .normal)
            case .Gift: self.z_btnicon.setImage(Asset.rankGiftPack.image, for: .normal)
            case .Lover: self.z_btnicon.setImage(Asset.rankLike.image, for: .normal)
            default: break
            }
        }
    }
    var z_row: Int = 0 {
        didSet {
            switch self.z_row {
            case 0:
                self.z_lbnum.isHidden = true
                self.z_imagenum.isHidden = false
                self.z_imagenum.image = Asset.rankTop1.image
            case 1:
                self.z_lbnum.isHidden = true
                self.z_imagenum.isHidden = false
                self.z_imagenum.image = Asset.rankTop2.image
            case 2:
                self.z_lbnum.isHidden = true
                self.z_imagenum.isHidden = false
                self.z_imagenum.image = Asset.rankTop3.image
            default:
                self.z_lbnum.isHidden = false
                self.z_imagenum.isHidden = true
            }
            self.z_lbnum.text = (self.z_row + 1).str
        }
    }
    var z_model: ZModelUserInfo? {
        didSet {
            guard let user = self.z_model else { return }
            z_lbcount.text = user.score.str
            z_lbusername.text = user.nickname
            z_imagephoto.setImageWitUrl(strUrl: user.avatar, placeholder: Asset.anchorAvatar.image)
        }
    }
    private lazy var z_viewcontent: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(15.scale, 10.scale, kScreenWidth - 30.scale, self.contentView.height - 10.scale))
        z_temp.backgroundColor = "#1E1925".color
        z_temp.border(color: .clear, radius: 15.scale, width: 0)
        return z_temp
    }()
    private lazy var z_imagephoto: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(z_lbnum.width, self.z_viewcontent.height/2 - 50.scale/2, 50.scale, 50.scale))
        z_temp.border(color: .clear, radius: z_temp.height/2, width: 0)
        return z_temp
    }()
    private lazy var z_lbusername: UILabel = {
        let z_tempx = z_imagephoto.x + z_imagephoto.width + 10.scale
        let z_temp = UILabel.init(frame: CGRect.init(z_tempx, self.z_viewcontent.height/2 - 22.scale/2, z_btnicon.x - z_tempx - 5.scale, 22.scale))
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 15
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_lbnum: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(0, self.z_viewcontent.height/2 - 22.scale/2, 47.scale, 22.scale))
        z_temp.isHidden = true
        z_temp.textAlignment = .center
        z_temp.textColor = "#493443".color
        z_temp.boldSize = 15
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_imagenum: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(z_lbnum.width/2 - 22.scale/2, self.z_viewcontent.height/2 - 22.scale/2, 22.scale, 22.scale))
        z_temp.isHidden = true
        return z_temp
    }()
    private lazy var z_btnicon: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(z_viewcontent.width - 94.scale, self.z_viewcontent.height/2 - 20.scale/2, 20.scale, 20.scale))
        z_temp.isUserInteractionEnabled = false
        z_temp.adjustsImageWhenHighlighted = false
        return z_temp
    }()
    private lazy var z_lbcount: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(z_viewcontent.width - 68.scale, self.z_viewcontent.height/2 - 22.scale/2, 65.scale, 22.scale))
        z_temp.textColor = "#493443".color
        z_temp.boldSize = 12
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(z_viewcontent)
        z_viewcontent.addSubview(z_lbnum)
        z_viewcontent.addSubview(z_lbcount)
        z_viewcontent.addSubview(z_lbusername)
        z_viewcontent.addSubview(z_imagephoto)
        z_viewcontent.addSubview(z_imagenum)
        z_viewcontent.addSubview(z_btnicon)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
