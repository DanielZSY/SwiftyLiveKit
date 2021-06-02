
import UIKit
import SwiftBasicKit

class ZListNodataView: UIView {

    var z_datacount: Int = 0 {
        didSet {
            z_viewai.stopAnimating()
            z_viewcontent.isHidden = z_datacount > 0
        }
    }
    private lazy var z_viewai: UIActivityIndicatorView = {
        let z_temp = UIActivityIndicatorView.init(style: .white)
        z_temp.frame = CGRect.init(origin: CGPoint.init(x: self.width/2 - 15, y: self.height/2 - 15), size: CGSize.init(width: 30, height: 30))
        return z_temp
    }()
    private lazy var z_viewcontent: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(0, 0, self.width, self.height))
        z_temp.isHidden = true
        z_temp.backgroundColor = .clear
        return z_temp
    }()
    private lazy var z_imageicon: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(self.width/2 - 366.scale/2, self.height/2 - 70.scale, 366.scale, 98.scale))
        z_temp.image = Asset.defaultNodata.image
        return z_temp
    }()
    private lazy var z_lbtitle: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(0, z_imageicon.y + z_imageicon.height + 5.scale, self.width, 25))
        z_temp.textAlignment = .center
        z_temp.textColor = "#515158".color
        z_temp.boldSize = 18
        z_temp.text = ZString.lbNoData.text
        return z_temp
    }()
     
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.addSubview(z_viewcontent)
        self.addSubview(z_viewai)
        
        z_viewcontent.addSubview(z_lbtitle)
        z_viewcontent.addSubview(z_imageicon)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    final func startAnimating() {
        self.z_viewai.startAnimating()
    }
}
extension UIScrollView {
    
    private struct AssociatedKey {
        static var aiviewKey = "aiviewKey"
    }
    var viewNodata: ZListNodataView {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKey.aiviewKey) as? ZListNodataView else {
                let view = ZListNodataView.init(frame: self.bounds)
                self.viewNodata = view
                return view
            }
            return value
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.aiviewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
extension UICollectionView {
    
    final func addNoDataView() {
        self.backgroundView = self.viewNodata
        self.backgroundView?.frame = self.bounds
    }
    final func startAnimating() {
        self.viewNodata.startAnimating()
    }
    final func stopAnimating(count: Int) {
        self.viewNodata.z_datacount = count
    }
}
extension UITableView {
    
    final func addNoDataView() {
        self.backgroundView = self.viewNodata
        self.backgroundView?.frame = self.bounds
    }
    final func startAnimating() {
        self.viewNodata.startAnimating()
    }
    final func stopAnimating(count: Int) {
        self.viewNodata.z_datacount = count
    }
}
