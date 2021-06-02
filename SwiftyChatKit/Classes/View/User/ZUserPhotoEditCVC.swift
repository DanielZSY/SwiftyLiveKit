
import UIKit
import SwiftBasicKit

class ZUserPhotoEditCVC: ZBaseCVC {
    
    var z_imageavatarpath: String = "" {
        didSet {
            self.z_btndelete.isHidden = false
            self.z_imagephoto.setImageWitUrl(strUrl: self.z_imageavatarpath, placeholder: Asset.defaultAvatar.image)
        }
    }
    var z_onbuttonevent: ((_ opt: ZUserEditPhotoOperation, _ row: Int) -> Void)?
    
    private lazy var z_imagephoto: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(13.scale, 10, 173.scale, 235.scale))
        z_temp.image = Asset.defaultAvatar.image
        z_temp.isUserInteractionEnabled = true
        z_temp.border(color: .clear, radius: 15, width: 0)
        return z_temp
    }()
    private lazy var z_btndelete: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(z_imagephoto.width - 35, z_imagephoto.height - 35, 35, 35))
        z_temp.isHidden = true
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setImage(Asset.userClose.image, for: .normal)
        return z_temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(z_imagephoto)
        self.z_imagephoto.addSubview(z_btndelete)
        
        z_imagephoto.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: "func_imagephototap:"))
        z_btndelete.addTarget(self, action: "func_btndeleteclick", for: .touchUpInside)
    }
    @objc private func func_imagephototap(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended: self.z_onbuttonevent?(.cover, self.tag)
        default: break
        }
    }
    @objc private func func_btndeleteclick() {
        self.z_onbuttonevent?(.delete, self.tag)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
