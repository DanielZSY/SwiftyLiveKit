
import UIKit
import SwiftBasicKit

class ZAnchorsDetailRankButton: UIButton {

    var z_model: ZModelUserInfo? {
        didSet {
            guard let user = self.z_model else {
                return
            }
            z_imagephoto.setImageWitUrl(strUrl: user.avatar, placeholder: Asset.defaultAvatar.image)
        }
    }
    override var tag: Int {
        didSet {
            switch tag {
            case 1:
                z_imagerank.image = Asset.rankTop1.image
                z_imagephoto.border(color: "#FFB62D".color, radius: z_imagephoto.height/2, width: 4.scale)
            case 2:
                z_imagerank.image = Asset.rankTop2.image
                z_imagephoto.border(color: "#00CDEB".color, radius: z_imagephoto.height/2, width: 4.scale)
            case 3:
                z_imagerank.image = Asset.rankTop3.image
                z_imagephoto.border(color: "#D55000".color, radius: z_imagephoto.height/2, width: 4.scale)
            default: break
            }
        }
    }
    private lazy var z_imagephoto: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(0, 0, 80.scale, 80.scale))
        return z_temp
    }()
    private lazy var z_imagerank: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(z_imagephoto.x + z_imagephoto.width/2 - 26.scale/2, z_imagephoto.y + z_imagephoto.height - 14.scale, 26.scale, 26.scale))
        return z_temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(z_imagephoto)
        self.addSubview(z_imagerank)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
