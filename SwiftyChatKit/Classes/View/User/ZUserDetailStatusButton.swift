
import UIKit
import SwiftBasicKit

class ZUserDetailStatusButton: UIButton {

    var z_modeluser: ZModelUserInfo? {
        didSet {
            guard let model = z_modeluser else { return }
            
            switch model.is_online {
            case true:
                switch model.is_busy {
                case true:
                    self.z_lbtitle.text = ZString.lbBusy.text
                    self.z_imageicon.image = Asset.anchorBusy.image
                    self.z_imageicon.frame = CGRect.init(self.width/2, self.height/2 - 19.scale/2, 19.scale, 19.scale)
                case false:
                    self.z_lbtitle.text = ZString.lbCallNow.text
                    self.z_imageicon.image = Asset.anchorCall.image
                    self.z_imageicon.frame = CGRect.init(self.width/2, self.height/2 - 24.scale/2, 27.scale, 24.scale)
                default: break
                }
            case false:
                self.z_lbtitle.text = ZString.lbOffline.text
                self.z_imageicon.image = Asset.anchorBusy.image
                self.z_imageicon.frame = CGRect.init(self.width/2, self.height/2 - 19.scale/2, 19.scale, 19.scale)
            default: break
            }
            self.onlineColor(online: model.is_online, busy: model.is_busy)
        }
    }
    override var frame: CGRect {
        didSet {
            self.z_lbtitle.width = self.z_lbtitle.text?.getWidth(self.z_lbtitle.font, height: self.z_lbtitle.height) ?? 0
            self.z_lbtitle.x = frame.size.width/2 - self.z_lbtitle.width/2 + self.z_imageicon.width
            self.z_imageicon.x = self.z_lbtitle.x - self.z_imageicon.width - 9.scale
        }
    }
    private lazy var z_imageicon: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(self.width/2, self.height/2 - 19.scale, 19.scale, 19.scale))
        return z_temp
    }()
    private lazy var z_lbtitle: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(self.width/2, 10.scale, 0, self.height - 20.scale))
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 18
        return z_temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(z_imageicon)
        self.addSubview(z_lbtitle)
        self.border(color: .clear, radius: self.height/2, width: 0)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
