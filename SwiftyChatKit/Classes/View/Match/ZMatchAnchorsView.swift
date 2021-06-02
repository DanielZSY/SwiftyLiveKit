
import UIKit
import SwiftBasicKit

class ZMatchAnchorsView: UIView {
    
    private lazy var z_viewanchors1: ZAutoScrollImage = {
        let z_temp = ZAutoScrollImage.init(frame: CGRect.init(0, 15, self.width, 100))
        z_temp.isUserInteractionEnabled = false
        return z_temp
    }()
    private lazy var z_viewanchors2: ZAutoScrollImage = {
        let z_temp = ZAutoScrollImage.init(frame: CGRect.init(0, 130, self.width, 100))
        z_temp.scrollDirection = .Right
        z_temp.isUserInteractionEnabled = false
        return z_temp
    }()
    private lazy var z_viewanchors3: ZAutoScrollImage = {
        let z_temp = ZAutoScrollImage.init(frame: CGRect.init(0, 245, self.width, 100))
        z_temp.isUserInteractionEnabled = false
        return z_temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(z_viewanchors1)
        self.addSubview(z_viewanchors2)
        self.addSubview(z_viewanchors3)
        
        self.z_viewanchors1.observeApplicationNotifications()
        self.z_viewanchors2.observeApplicationNotifications()
        self.z_viewanchors3.observeApplicationNotifications()
        
        var array = [String]()
        for item in 912...926 {
            array.append("usermatchanchor\(item)")
        }
        self.z_viewanchors1.imageNames.append(contentsOf: array)
        array.removeAll()
        for item in 927...941 {
            array.append("usermatchanchor\(item)")
        }
        self.z_viewanchors2.imageNames.append(contentsOf: array)
        array.removeAll()
        for item in 942...956 {
            array.append("usermatchanchor\(item)")
        }
        self.z_viewanchors3.imageNames.append(contentsOf: array)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    final func func_startscrolling() {
        self.z_viewanchors1.scrollLabelIfNeededAction()
        self.z_viewanchors2.scrollLabelIfNeededAction()
        self.z_viewanchors3.scrollLabelIfNeededAction()
    }
}
