
import UIKit
import SwiftBasicKit

class ZChatlistCallHistoryCVC: ZBaseCVC {
    
    var z_model: ZModelCallRecord? {
        didSet {
            guard let user = z_model?.calluser else { return }
            z_imagephoto.setImageWitUrl(strUrl: user.avatar, placeholder: Asset.defaultImage.image)
            z_lbusername.text = user.nickname + "," + user.age.str
            z_viewonline.onlineColor(online: user.is_online, busy: user.is_busy)
        }
    }
    private lazy var z_imagephoto: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(10, 0, 120.scale, 160.scale))
        z_temp.image = Asset.defaultAvatar.image
        z_temp.border(color: .clear, radius: 10, width: 0)
        return z_temp
    }()
    private lazy var z_imagebottom: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(0, z_imagephoto.height - 61.scale, z_imagephoto.width, 61.scale))
        z_temp.image = Asset.defaultTransparent.image.down
        z_temp.border(color: .clear, radius: 10, width: 0)
        return z_temp
    }()
    private lazy var z_lbusername: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(22.scale, 36.scale, z_imagebottom.width - 27.scale, 20.scale))
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 14
        return z_temp
    }()
    private lazy var z_viewonline: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(10.scale, z_lbusername.y + 13.scale/2, 7.scale, 7.scale))
        z_temp.border(color: .clear, radius: 7.scale/2, width: 0)
        return z_temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(z_imagephoto)
        z_imagephoto.addSubview(z_imagebottom)
        z_imagebottom.addSubview(z_viewonline)
        z_imagebottom.addSubview(z_lbusername)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
