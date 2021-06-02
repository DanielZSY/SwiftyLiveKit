
import UIKit
import BFKit
import SnapKit

class ZMatchStartButton: UIButton {
    
    private lazy var z_imagebg: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(self.width/2 - 262.scale/2, self.height/2 - 55.scale/2, 262.scale, 55.scale))
        z_temp.backgroundColor = "#7037E9".color
        z_temp.border(color: .clear, radius: z_temp.height/2, width: 0)
        return z_temp
    }()
    private lazy var z_lbtitle: UILabel = {
        let z_temp = UILabel.init(frame: self.z_imagebg.bounds)
        z_temp.text = ZString.btnStart.text
        z_temp.textAlignment = .center
        z_temp.textColor = .white
        z_temp.boldSize = 15
        return z_temp
    }()
    private lazy var z_imageborder: UIImageView = {
        let z_temp = UIImageView.init(frame: self.bounds)
        
        z_temp.backgroundColor = "#7037E9".color.withAlphaComponent(0.2)
        z_temp.border(color: .clear, radius: self.height/2, width: 0)
        
        return z_temp
    }()
    private lazy var z_imageanimation: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(self.width/2 - 285.scale/2, self.height/2 - 69.scale/2, 285.scale, 69.scale))
        
        z_temp.backgroundColor = "#7037E9".color.withAlphaComponent(0.6)
        z_temp.border(color: .clear, radius: z_temp.height/2, width: 0)
        
        return z_temp
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    required convenience init() {
        self.init(frame: CGRect.zero)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.addSubview(self.z_imagebg)
        z_imagebg.addSubview(z_lbtitle)
        
        self.addSubview(self.z_imageborder)
        self.addSubview(self.z_imageanimation)
        self.bringSubviewToFront(self.z_imageanimation)
        self.bringSubviewToFront(self.z_imagebg)
    }
    final func startAnimation() {
        UIView.animate(withDuration: 2, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.z_imageanimation.alpha = 0.2
            self.z_imageanimation.frame = self.z_imageborder.frame
            self.z_imageanimation.border(color: .clear, radius: (self.z_imageborder.height/2), width: 0)
        }, completion: { _ in
            self.z_imageanimation.border(color: .clear, radius: (self.z_imageanimation.height/2), width: 0)
            UIView.animate(withDuration: 2, animations: {
                self.z_imageanimation.alpha = 0.6
                self.z_imageanimation.frame = self.z_imagebg.frame
                self.z_imageanimation.border(color: .clear, radius: (self.z_imagebg.height/2), width: 0)
            }, completion: { _ in
                self.z_imageanimation.border(color: .clear, radius: (self.z_imageanimation.height/2), width: 0)
            })
        })
    }
    final func stopAnimation() {
        self.z_imageanimation.layer.removeAllAnimations()
    }
}
