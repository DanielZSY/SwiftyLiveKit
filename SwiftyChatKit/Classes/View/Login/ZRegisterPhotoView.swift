
import UIKit
import SwiftBasicKit

class ZRegisterPhotoView: UIView {
    
    var z_onselectphoto: (() -> Void)?
    var z_image: UIImage? {
        didSet {
            z_imagephoto.image = z_image
        }
    }
    private lazy var z_lbtitle: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(28.scale, 0, 320.scale, 80))
        z_temp.textColor = "#7C3EF0".color
        z_temp.boldSize = 30
        z_temp.numberOfLines = 0
        z_temp.lineBreakMode = .byWordWrapping
        let text = ZString.lbYourPhoto.text
        z_temp.text = text
        let atttext = NSMutableAttributedString.init(string: text)
        atttext.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 23)], range: NSRange.init(location: 0, length: 4))
        z_temp.attributedText = atttext
        return z_temp
    }()
    private lazy var z_imagephoto: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(80.scale, z_lbtitle.height + 55.scale, 216.scale, 259.scale))
        z_temp.image = Asset.defaultImage.image
        z_temp.isUserInteractionEnabled = true
        z_temp.border(color: .clear, radius: 20, width: 0)
        return z_temp
    }()
    private lazy var z_btnupload: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(147.scale, 193.scale, 48.scale, 48.scale))
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setImage(Asset.loginUpdate.image, for: .normal)
        return z_temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(z_lbtitle)
        self.addSubview(z_imagephoto)
        z_imagephoto.addSubview(z_btnupload)
        self.bringSubviewToFront(z_btnupload)
        
        //z_imagephoto.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: "func_imagephototap:"))
        z_btnupload.addTarget(self, action: "func_btnuploadclick", for: .touchUpInside)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    @objc private func func_imagephototap(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended: self.z_onselectphoto?()
        default: break
        }
    }
    @objc private func func_btnuploadclick() {
        self.z_onselectphoto?()
    }
}
