
import UIKit
import SwiftBasicKit

class ZUserFollowItemCVC: ZBaseCVC {
    
    var z_row: Int = 0
    var z_hidmessage: Bool = false {
        didSet {
            z_btnmessage.isHidden = z_hidmessage
        }
    }
    var z_model: ZModelUserInfo? {
        didSet {
            guard let user = z_model else { return }
            if user.followed_at > 0 {
                z_lbtime.text = user.followed_at.strMessageTime
            } else if user.blocked_at > 0 {
                z_lbtime.text = user.blocked_at.strMessageTime
            } else {
                z_lbtime.text = ""
            }
            z_lbusername.text = user.nickname
            z_imagephoto.setImageWitUrl(strUrl: user.avatar, placeholder: Asset.defaultAvatar.image)
        }
    }
    /// opt 1 详情 2 消息 3 删除
    var z_onbuttonclick: ((_ opt: Int, _ tag: Int, _ row: Int) -> Void)?
    
    private lazy var z_imagephoto: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(10.scale, 10.scale, 68.scale, 68.scale))
        z_temp.image = Asset.defaultAvatar.image
        z_temp.isUserInteractionEnabled = true
        z_temp.border(color: .clear, radius: 68.scale/2, width: 0)
        return z_temp
    }()
    private lazy var z_lbusername: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(88.scale, z_imagephoto.y, 152.scale, z_imagephoto.height/2))
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 14
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_lbtime: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(z_lbusername.x, z_lbusername.y + z_lbusername.height, z_lbusername.width, 25))
        z_temp.textColor = "#515158".color
        z_temp.boldSize = 12
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_btnmessage: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(230.scale, self.contentView.height/2 - 20.scale, 74.scale, 40.scale))
        z_temp.tag = 2
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setImage(Asset.userChat.image, for: .normal)
        return z_temp
    }()
    private lazy var z_btndelete: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(z_btnmessage.x + z_btnmessage.width + 10, self.contentView.height/2 - 20.scale, 40.scale, 40.scale))
        z_temp.tag = 3
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setImage(Asset.userDelete.image, for: .normal)
        return z_temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(z_imagephoto)
        self.contentView.addSubview(z_lbusername)
        self.contentView.addSubview(z_lbtime)
        self.contentView.addSubview(z_btnmessage)
        self.contentView.addSubview(z_btndelete)
        
        z_imagephoto.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: "func_imagephototap:"))
        z_btnmessage.addTarget(self, action: "func_buttonclick:", for: .touchUpInside)
        z_btndelete.addTarget(self, action: "func_buttonclick:", for: .touchUpInside)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    @objc private func func_imagephototap(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            self.z_onbuttonclick?(1, self.tag, self.z_row)
        default: break
        }
    }
    @objc private func func_buttonclick(_ sender: UIButton) {
        self.z_onbuttonclick?(sender.tag, self.tag, self.z_row)
    }
}
