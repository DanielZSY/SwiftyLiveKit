
import UIKit
import SwiftBasicKit

enum ZUserEditPhotoOperation: Int {
    /// 删除
    case delete = 1
    /// 封面
    case cover = 2
}
class ZUserEditPhotoView: UIView {
    
    var z_imageavatarpath: String = "" {
        didSet {
            self.isselect = true
            self.z_btndelete.isHidden = false
            self.z_imagephoto.setImageWitUrl(strUrl: self.z_imageavatarpath, placeholder: Asset.defaultImage.image)
        }
    }
    var z_imageavatar: UIImage? {
        didSet {
            if let photo = self.z_imageavatar {
                self.isselect = true
                self.z_btndelete.isHidden = false
                self.z_imagephoto.image = photo
            } else {
                self.isselect = false
                self.z_btndelete.isHidden = true
                self.z_imagephoto.image = Asset.defaultImage.image
            }
        }
    }
    var z_onbuttonevent: ((_ opt: ZUserEditPhotoOperation, _ row: Int) -> Void)?
    
    private var isselect: Bool = false
    private lazy var z_imagephoto: UIImageView = {
        let z_temp = UIImageView.init(image: Asset.defaultImage.image)
        z_temp.frame = self.bounds
        z_temp.isUserInteractionEnabled = true
        z_temp.border(color: UIColor.clear, radius: 15, width: 0)
        return z_temp
    }()
    private lazy var z_btndelete: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(self.width - 35, self.height - 35, 35, 35))
        z_temp.isHidden = true
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setImage(Asset.userClose.image, for: .normal)
        return z_temp
    }()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(z_imagephoto)
        self.addSubview(z_btndelete)
        self.bringSubviewToFront(z_btndelete)
        
        z_imagephoto.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: "func_imagephototap:"))
        z_btndelete.addTarget(self, action: "func_btndeleteclick", for: .touchUpInside)
    }
    @objc private func func_imagephototap(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            if self.isselect {
                self.z_onbuttonevent?(.cover, self.tag)
            }
        default: break
        }
    }
    @objc private func func_btndeleteclick() {
        self.z_onbuttonevent?(.delete, self.tag)
    }
}
