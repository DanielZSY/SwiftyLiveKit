
import UIKit

class ZUserPhotoEditAddView: UICollectionReusableView {
    
    var z_onbtnaddphotoclick: (() -> Void)?
    
    private lazy var z_btnaddphoto: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(28.scale, 20.scale, 320.scale, 50.scale))
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.titleLabel?.boldSize = 15
        z_temp.setTitle(ZString.lbAddAPhoto.text, for: .normal)
        z_temp.setTitleColor("#FFFFFF".color, for: .normal)
        z_temp.backgroundColor = "#7037E9".color
        z_temp.border(color: .clear, radius: 50.scale/2, width: 0)
        return z_temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(z_btnaddphoto)
        
        z_btnaddphoto.addTarget(self, action: "func_btnaddphotoclick", for: .touchUpInside)
    }
    @objc private func func_btnaddphotoclick() {
        self.z_onbtnaddphotoclick?()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
