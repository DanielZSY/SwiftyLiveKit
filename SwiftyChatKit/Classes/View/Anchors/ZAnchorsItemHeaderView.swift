
import UIKit
import SwiftBasicKit

class ZAnchorsItemHeaderView: UICollectionReusableView {
    
    var on_btncompleteclick: (() -> Void)?
    
    private lazy var z_imagemain: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(10.scale, 10.scale, 356.scale, 122.scale))
        z_temp.image = Asset.anchorComplete.image
        z_temp.isUserInteractionEnabled = true
        return z_temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(z_imagemain)
        self.backgroundColor = "#100D13".color
        z_imagemain.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: "func_btncompleteclick:"))
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    @objc private func func_btncompleteclick(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended: self.on_btncompleteclick?()
        default: break
        }
    }
}
