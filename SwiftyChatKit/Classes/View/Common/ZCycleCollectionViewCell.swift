
import UIKit

class ZCycleCollectionViewCell: UICollectionViewCell {
    
    var z_on_itemcycleclick: ((_ row: Int) -> Void)?
    
    lazy var z_imagemain: UIImageView  = {
        let z_temp = UIImageView.init(frame: self.bounds)
        
        z_temp.backgroundColor = .clear
        z_temp.isUserInteractionEnabled = true
        z_temp.contentMode = UIView.ContentMode.scaleAspectFill
        
        return z_temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(self.z_imagemain)
        
        self.z_imagemain.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(imageTapGestureEvent(_:))))
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    @objc private func imageTapGestureEvent(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended: self.z_on_itemcycleclick?(self.tag)
        default: break
        }
    }
}
