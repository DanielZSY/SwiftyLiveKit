
import UIKit
import SwiftBasicKit

class ZRankItemHeadView: UICollectionReusableView {
    
    var z_onbuttonphotoclick: ((_ user: ZModelUserInfo?) -> Void)?
    var z_type: kEnumRankType = .Anchor {
        didSet {
            switch self.z_type {
            case .Anchor:
                z_imageicon1.setImage(Asset.rankHot.image, for: .normal)
                z_imageicon2.setImage(Asset.rankHot.image, for: .normal)
                z_imageicon3.setImage(Asset.rankHot.image, for: .normal)
            case .Gift:
                z_imageicon1.setImage(Asset.rankGiftPack.image, for: .normal)
                z_imageicon2.setImage(Asset.rankGiftPack.image, for: .normal)
                z_imageicon3.setImage(Asset.rankGiftPack.image, for: .normal)
            case .Gold:
                z_imageicon1.setImage(Asset.rankMoney.image, for: .normal)
                z_imageicon2.setImage(Asset.rankMoney.image, for: .normal)
                z_imageicon3.setImage(Asset.rankMoney.image, for: .normal)
            case .Lover:
                z_imageicon1.setImage(Asset.rankLike.image, for: .normal)
                z_imageicon2.setImage(Asset.rankLike.image, for: .normal)
                z_imageicon3.setImage(Asset.rankLike.image, for: .normal)
            default: break
            }
        }
    }
    var z_arrayUser: [ZModelUserInfo]? {
        didSet {
            z_viewtop1.isHidden = true
            z_viewtop2.isHidden = true
            z_viewtop3.isHidden = true
            guard let array = z_arrayUser else { return }
            for (i, user) in array.enumerated() {
                switch i {
                case 0:
                    z_viewtop1.isHidden = false
                    z_imagephoto1.setImageWitUrl(strUrl: user.avatar, placeholder: Asset.anchorAvatar.image)
                    z_lbusername1.text = user.nickname
                    z_lbcount1.text = user.score.str
                case 1:
                    z_viewtop2.isHidden = false
                    z_imagephoto2.setImageWitUrl(strUrl: user.avatar, placeholder: Asset.anchorAvatar.image)
                    z_lbusername2.text = user.nickname
                    z_lbcount2.text = user.score.str
                case 2:
                    z_viewtop3.isHidden = false
                    z_imagephoto3.setImageWitUrl(strUrl: user.avatar, placeholder: Asset.anchorAvatar.image)
                    z_lbusername3.text = user.nickname
                    z_lbcount3.text = user.score.str
                default: break
                }
            }
        }
    }
    private lazy var z_viewtop1: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(self.width/2 - 110.scale/2, 0, 110.scale, self.height))
        z_temp.isHidden = true
        return z_temp
    }()
    private lazy var z_btnphoto1: UIButton = {
        let z_temp = UIButton.init(frame: z_imagephoto1.frame)
        z_temp.tag = 1
        return z_temp
    }()
    private lazy var z_imagephoto1: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(10.scale, 30.scale, 90.scale, 90.scale))
        z_temp.image = Asset.defaultAvatar.image
        z_temp.border(color: "#FFB62D".color, radius: z_temp.height/2, width: 4)
        return z_temp
    }()
    private lazy var z_imagetop1: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(z_imagephoto1.x + z_imagephoto1.width/2 - 38.scale/2, z_imagephoto1.y + z_imagephoto1.height - 20.scale, 38.scale, 38.scale))
        z_temp.image = Asset.rankTop1.image
        return z_temp
    }()
    private lazy var z_lbusername1: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(z_imagephoto1.x - 5.scale, z_imagephoto1.y + z_imagephoto1.height + 23.scale, 100.scale, 21))
        z_temp.textAlignment = .center
        z_temp.textColor = "#E9E9E9".color
        z_temp.boldSize = 15
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_imageicon1: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(z_lbcount1.x - 25.scale, z_lbcount1.y, 22.scale, 22.scale))
        z_temp.adjustsImageWhenHighlighted = false
        return z_temp
    }()
    private lazy var z_lbcount1: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(z_imagetop1.x, z_imagephoto1.y + z_imagephoto1.height + 50.scale, z_imagephoto1.width/2, 22.scale))
        z_temp.textColor = "#493443".color
        z_temp.boldSize = 12
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_viewtop2: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(20.scale, 0, 110.scale, self.height))
        z_temp.isHidden = true
        return z_temp
    }()
    private lazy var z_btnphoto2: UIButton = {
        let z_temp = UIButton.init(frame: z_imagephoto2.frame)
        z_temp.tag = 2
        return z_temp
    }()
    private lazy var z_imagephoto2: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(z_viewtop2.width/2 - 62.scale/2, 46.scale, 62.scale, 62.scale))
        z_temp.image = Asset.defaultAvatar.image
        z_temp.border(color: "#00CDEB".color, radius: z_temp.height/2, width: 4)
        return z_temp
    }()
    private lazy var z_imagetop2: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(z_imagephoto2.x + z_imagephoto2.width/2 - 32.scale/2, z_imagephoto2.y + z_imagephoto2.height - 20.scale, 32.scale, 32.scale))
        z_temp.image = Asset.rankTop2.image
        return z_temp
    }()
    private lazy var z_lbusername2: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(z_imagephoto2.x + z_imagephoto2.width/2 - 100.scale/2, z_imagephoto2.y + z_imagephoto2.height + 25.scale, 100.scale, 21))
        z_temp.textAlignment = .center
        z_temp.textColor = "#E9E9E9".color
        z_temp.boldSize = 15
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_imageicon2: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(z_lbcount2.x - 25.scale, z_lbcount2.y, 22.scale, 22.scale))
        return z_temp
    }()
    private lazy var z_lbcount2: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(z_imagetop2.x, z_imagephoto2.y + z_imagephoto2.height + 53.scale, z_imagephoto2.width/2, 22.scale))
        z_temp.textColor = "#493443".color
        z_temp.boldSize = 12
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_viewtop3: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(self.width - 110.scale - 24.scale, 0, 110.scale, self.height))
        z_temp.isHidden = true
        return z_temp
    }()
    private lazy var z_btnphoto3: UIButton = {
        let z_temp = UIButton.init(frame: z_imagephoto3.frame)
        z_temp.tag = 3
        return z_temp
    }()
    private lazy var z_imagephoto3: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(z_viewtop3.width/2 - 62.scale/2, 46.scale, 62.scale, 62.scale))
        z_temp.image = Asset.defaultAvatar.image
        z_temp.border(color: "#D55000".color, radius: z_temp.height/2, width: 4)
        return z_temp
    }()
    private lazy var z_imagetop3: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(z_imagephoto3.x + z_imagephoto3.width/2 - 32.scale/2, z_imagephoto3.y + z_imagephoto3.height - 20.scale, 32.scale, 32.scale))
        z_temp.image = Asset.rankTop3.image
        return z_temp
    }()
    private lazy var z_lbusername3: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(z_imagephoto3.x + z_imagephoto3.width/2 - 100.scale/2, z_imagephoto3.y + z_imagephoto3.height + 25.scale, 100.scale, 21))
        z_temp.textAlignment = .center
        z_temp.textColor = "#E9E9E9".color
        z_temp.boldSize = 15
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_imageicon3: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(z_lbcount3.x - 25.scale, z_lbcount3.y, 22.scale, 22.scale))
        return z_temp
    }()
    private lazy var z_lbcount3: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(z_imagetop3.x, z_imagephoto3.y + z_imagephoto3.height + 53.scale, z_imagephoto3.width/2 + 10, 22.scale))
        z_temp.textColor = "#493443".color
        z_temp.boldSize = 12
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(z_viewtop1)
        self.addSubview(z_viewtop2)
        self.addSubview(z_viewtop3)
        z_viewtop1.addSubview(z_imagephoto1)
        z_viewtop1.addSubview(z_imagetop1)
        z_viewtop1.addSubview(z_btnphoto1)
        z_viewtop1.addSubview(z_lbusername1)
        z_viewtop1.addSubview(z_imageicon1)
        z_viewtop1.addSubview(z_lbcount1)
        z_viewtop1.bringSubviewToFront(z_btnphoto1)
        
        z_viewtop2.addSubview(z_imagephoto2)
        z_viewtop2.addSubview(z_imagetop2)
        z_viewtop2.addSubview(z_btnphoto2)
        z_viewtop2.addSubview(z_lbusername2)
        z_viewtop2.addSubview(z_imageicon2)
        z_viewtop2.addSubview(z_lbcount2)
        z_viewtop2.bringSubviewToFront(z_btnphoto2)
        
        z_viewtop3.addSubview(z_imagephoto3)
        z_viewtop3.addSubview(z_imagetop3)
        z_viewtop3.addSubview(z_btnphoto3)
        z_viewtop3.addSubview(z_lbusername3)
        z_viewtop3.addSubview(z_imageicon3)
        z_viewtop3.addSubview(z_lbcount3)
        z_viewtop3.bringSubviewToFront(z_btnphoto3)
        
        z_btnphoto1.addTarget(self, action: "func_btnphotoclick:", for: .touchUpInside)
        z_btnphoto2.addTarget(self, action: "func_btnphotoclick:", for: .touchUpInside)
        z_btnphoto3.addTarget(self, action: "func_btnphotoclick:", for: .touchUpInside)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    @objc private func func_btnphotoclick(_ sender: UIButton) {
        if let array = self.z_arrayUser, array.count >= sender.tag {
            self.z_onbuttonphotoclick?(array[sender.tag - 1])
        }
    }
}
