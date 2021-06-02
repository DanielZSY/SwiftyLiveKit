
import UIKit
import SwiftBasicKit

class ZChatlistMessagesView: UICollectionReusableView {
    /// 是否授权通知
    var z_isauthorize: Bool = true {
        didSet {
            z_btnnotification.isHidden = self.z_isauthorize
        }
    }
    /// 点击开启通知
    var z_onbuttonnotificationclick: (() -> Void)?
    private lazy var z_lbtitle: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(10.scale, 0, 300.scale, 45.scale))
        z_temp.textColor = "#E9E9E9".color
        z_temp.boldSize = 18
        z_temp.text = ZString.lbMessages.text
        return z_temp
    }()
    private lazy var z_btnnotification: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(10.scale, z_lbtitle.height, 355.scale, 60.scale))
        z_temp.isHidden = true
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.backgroundColor = "#D337E9".color
        z_temp.border(color: .clear, radius: 10, width: 0)
        return z_temp
    }()
    private lazy var z_imagenotification: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(22.scale, 16.scale, 33.scale, 27.scale))
        z_temp.image = Asset.chatMessage.image
        return z_temp
    }()
    private lazy var z_lbnotification: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(71.scale, 16.scale, 200.scale, 27.scale))
        z_temp.text = ZString.lbAllowPushNotification.text
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 12
        z_temp.numberOfLines = 0
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(z_lbtitle)
        self.addSubview(z_btnnotification)
        self.backgroundColor = "#100D13".color
        
        z_btnnotification.addSubview(z_imagenotification)
        z_btnnotification.addSubview(z_lbnotification)
        z_btnnotification.addTarget(self, action: "func_btnnotificationclick", for: .touchUpInside)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    @objc private func func_btnnotificationclick() {
        self.z_onbuttonnotificationclick?()
    }
}
