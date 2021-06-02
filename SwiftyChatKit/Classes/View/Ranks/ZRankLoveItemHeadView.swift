
import UIKit
import SwiftBasicKit

class ZRankLoveItemHeadView: UICollectionReusableView {
    
    var z_onbuttonphotoclick: ((_ user: ZModelUserInfo?) -> Void)?
    var z_type: kEnumRankType = .Lover
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
                    if let otheruser = user.rank_other_people {
                        z_lbusernameother1.text = otheruser.nickname
                        z_imagephotoother1.setImageWitUrl(strUrl: otheruser.avatar, placeholder: Asset.anchorAvatar.image)
                    }
                case 1:
                    z_viewtop2.isHidden = false
                    z_imagephoto2.setImageWitUrl(strUrl: user.avatar, placeholder: Asset.anchorAvatar.image)
                    z_lbusername2.text = user.nickname
                    z_lbcount2.text = user.score.str
                    if let otheruser = user.rank_other_people {
                        z_lbusernameother2.text = otheruser.nickname
                        z_imagephotoother2.setImageWitUrl(strUrl: otheruser.avatar, placeholder: Asset.anchorAvatar.image)
                    }
                case 2:
                    z_viewtop3.isHidden = false
                    z_imagephoto3.setImageWitUrl(strUrl: user.avatar, placeholder: Asset.anchorAvatar.image)
                    z_lbusername3.text = user.nickname
                    z_lbcount3.text = user.score.str
                    if let otheruser = user.rank_other_people {
                        z_lbusernameother3.text = otheruser.nickname
                        z_imagephotoother3.setImageWitUrl(strUrl: otheruser.avatar, placeholder: Asset.anchorAvatar.image)
                    }
                default: break
                }
            }
        }
    }
    /// TOP1
    private lazy var z_viewtop1: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(self.width/2 - 125.scale/2, 0, 125.scale, self.height))
        z_temp.isHidden = true
        return z_temp
    }()
    private lazy var z_btnphoto1: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(0, z_imagephoto1.y, 125.scale, z_imagephoto1.height))
        z_temp.tag = 1
        return z_temp
    }()
    private lazy var z_imagephoto1: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(0, 25.scale, 78.scale, 78.scale))
        z_temp.image = Asset.defaultAvatar.image
        z_temp.border(color: "#FFB62D".color, radius: z_temp.height/2, width: 4)
        return z_temp
    }()
    private lazy var z_imagephotoother1: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(47.scale, z_imagephoto1.y, 78.scale, 78.scale))
        z_temp.image = Asset.defaultAvatar.image
        z_temp.border(color: "#FFB62D".color, radius: z_temp.height/2, width: 4)
        return z_temp
    }()
    private lazy var z_imagetop1: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(z_viewtop1.width/2 - 38.scale/2, z_imagephoto1.y + 56.scale, 38.scale, 38.scale))
        z_temp.image = Asset.rankTop1.image
        return z_temp
    }()
    private lazy var z_lbusername1: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(0, z_imagephoto1.y + z_imagephoto1.height + 20.scale, z_viewtop1.width, 21))
        z_temp.textAlignment = .center
        z_temp.textColor = "#E9E9E9".color
        z_temp.boldSize = 15
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_lbusernameother1: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(0, z_lbusername1.y + z_lbusername1.height, z_viewtop1.width, 21))
        z_temp.textAlignment = .center
        z_temp.textColor = "#E9E9E9".color
        z_temp.boldSize = 15
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_imageicon1: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(z_lbcount1.x - 25.scale, z_lbcount1.y, 22.scale, 22.scale))
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setImage(Asset.rankLike.image, for: .normal)
        return z_temp
    }()
    private lazy var z_lbcount1: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(z_imagetop1.x, z_imagephoto1.y + z_imagephoto1.height + 65.scale, z_imagephoto1.width/2, 22.scale))
        z_temp.textColor = "#493443".color
        z_temp.boldSize = 12
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    /// TOP2
    private lazy var z_viewtop2: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(0, 0, (kScreenWidth - z_viewtop1.width)/2, self.height))
        z_temp.isHidden = true
        return z_temp
    }()
    private lazy var z_btnphoto2: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(z_imagephoto2.x, z_imagephoto2.y, 80.scale, z_imagephoto2.height))
        z_temp.tag = 2
        return z_temp
    }()
    private lazy var z_imagephoto2: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(z_viewtop2.width/2 - 41.scale, 40.scale, 51.scale, 51.scale))
        z_temp.image = Asset.defaultAvatar.image
        z_temp.border(color: "#00CDEB".color, radius: z_temp.height/2, width: 4)
        return z_temp
    }()
    private lazy var z_imagephotoother2: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(z_imagephoto2.x + 30.scale, z_imagephoto2.y, 51.scale, 51.scale))
        z_temp.image = Asset.defaultAvatar.image
        z_temp.border(color: "#00CDEB".color, radius: z_temp.height/2, width: 4)
        return z_temp
    }()
    private lazy var z_imagetop2: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(z_viewtop2.width/2 - 32.scale/2, z_imagephoto2.y + 40.scale, 32.scale, 32.scale))
        z_temp.image = Asset.rankTop2.image
        return z_temp
    }()
    private lazy var z_lbusername2: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(0, z_imagephoto2.y + z_imagephoto2.height + 25.scale, z_viewtop2.width, 21))
        z_temp.textAlignment = .center
        z_temp.textColor = "#E9E9E9".color
        z_temp.boldSize = 15
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_lbusernameother2: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(z_lbusername2.x, z_lbusername2.y + z_lbusername2.height, z_lbusername2.width, 21))
        z_temp.textAlignment = .center
        z_temp.textColor = "#E9E9E9".color
        z_temp.boldSize = 15
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_imageicon2: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(z_lbcount2.x - 25.scale, z_lbcount2.y, 22.scale, 22.scale))
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setImage(Asset.rankLike.image, for: .normal)
        return z_temp
    }()
    private lazy var z_lbcount2: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(z_imagetop2.x, z_imagephoto2.y + z_imagephoto2.height + 70.scale, z_viewtop2.width/2, 22.scale))
        z_temp.textColor = "#493443".color
        z_temp.boldSize = 12
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    /// TOP3
    private lazy var z_viewtop3: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(z_viewtop1.x + z_viewtop1.width, 0, (kScreenWidth - z_viewtop1.width)/2, self.height))
        z_temp.isHidden = true
        return z_temp
    }()
    private lazy var z_btnphoto3: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(z_imagephoto3.x, z_imagephoto3.y, 80.scale, z_imagephoto3.height))
        z_temp.tag = 3
        return z_temp
    }()
    private lazy var z_imagephoto3: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(z_viewtop1.width/2 - 41.scale, 40.scale, 51.scale, 51.scale))
        z_temp.image = Asset.defaultAvatar.image
        z_temp.border(color: "#D55000".color, radius: z_temp.height/2, width: 4)
        return z_temp
    }()
    private lazy var z_imagephotoother3: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(z_imagephoto3.x + 30.scale, z_imagephoto3.y, 51.scale, 51.scale))
        z_temp.image = Asset.defaultAvatar.image
        z_temp.border(color: "#D55000".color, radius: z_temp.height/2, width: 4)
        return z_temp
    }()
    private lazy var z_imagetop3: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(z_viewtop3.width/2 - 32.scale/2, z_imagephoto3.y + 40.scale, 32.scale, 32.scale))
        z_temp.image = Asset.rankTop3.image
        return z_temp
    }()
    private lazy var z_lbusername3: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(0, z_imagephoto3.y + z_imagephoto3.height + 25.scale, z_viewtop3.width, 21))
        z_temp.textAlignment = .center
        z_temp.textColor = "#E9E9E9".color
        z_temp.boldSize = 15
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_lbusernameother3: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(z_lbusername3.x, z_lbusername3.y + z_lbusername3.height, z_lbusername3.width, 21))
        z_temp.textAlignment = .center
        z_temp.textColor = "#E9E9E9".color
        z_temp.boldSize = 15
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_imageicon3: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(z_lbcount3.x - 25.scale, z_lbcount3.y, 22.scale, 22.scale))
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setImage(Asset.rankLike.image, for: .normal)
        return z_temp
    }()
    private lazy var z_lbcount3: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(z_imagetop3.x, z_imagephoto3.y + z_imagephoto3.height + 70.scale, z_viewtop3.width/2, 22.scale))
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
        z_viewtop1.addSubview(z_lbusername1)
        z_viewtop1.addSubview(z_imagephotoother1)
        z_viewtop1.addSubview(z_lbusernameother1)
        z_viewtop1.addSubview(z_imagetop1)
        z_viewtop1.addSubview(z_imageicon1)
        z_viewtop1.addSubview(z_lbcount1)
        z_viewtop1.addSubview(z_btnphoto1)
        z_viewtop1.bringSubviewToFront(z_btnphoto1)
        
        z_viewtop2.addSubview(z_imagephoto2)
        z_viewtop2.addSubview(z_lbusername2)
        z_viewtop2.addSubview(z_imagephotoother2)
        z_viewtop2.addSubview(z_lbusernameother2)
        z_viewtop2.addSubview(z_imagetop2)
        z_viewtop2.addSubview(z_imageicon2)
        z_viewtop2.addSubview(z_lbcount2)
        z_viewtop2.addSubview(z_btnphoto2)
        z_viewtop2.bringSubviewToFront(z_btnphoto2)
        
        z_viewtop3.addSubview(z_imagephoto3)
        z_viewtop3.addSubview(z_lbusername3)
        z_viewtop3.addSubview(z_imagephotoother3)
        z_viewtop3.addSubview(z_lbusernameother3)
        z_viewtop3.addSubview(z_imagetop3)
        z_viewtop3.addSubview(z_imageicon3)
        z_viewtop3.addSubview(z_lbcount3)
        z_viewtop3.addSubview(z_btnphoto3)
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
