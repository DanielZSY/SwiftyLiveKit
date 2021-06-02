
import UIKit

class ZCollectionSpaceReusableView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
