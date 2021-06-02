
import UIKit

class ZMatchLookingButton: UIButton {
    
    private lazy var z_imagelike: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(self.width/2 - 116.scale/2, self.height/2 - 116.scale/2, 116.scale, 116.scale))
        z_temp.image = Asset.matchLooking.image
        return z_temp
    }()
    private lazy var z_imageborder1: ZArcImageView = {
        let z_temp = ZArcImageView.init(frame: CGRect.init(self.width/2 - 196.scale/2, self.height/2 - 196.scale/2, 196.scale, 196.scale))
        z_temp.z_alphabordercolor = 0.9
        z_temp.z_arclinewidth = 3
        z_temp.border(color: "#1F1926".color.withAlphaComponent(0.9), radius: z_temp.height/2, width: 3)
        return z_temp
    }()
    private lazy var z_imageborder2: ZArcImageView = {
        let z_temp = ZArcImageView.init(frame: CGRect.init(self.width/2 - 256.scale/2, self.height/2 - 256.scale/2, 256.scale, 256.scale))
        z_temp.z_alphabordercolor = 0.6
        z_temp.z_arclinewidth = 3
        z_temp.border(color: "#1F1926".color.withAlphaComponent(0.9), radius: z_temp.height/2, width: 3)
        return z_temp
    }()
    private lazy var z_imageborder3: ZArcImageView = {
        let z_temp = ZArcImageView.init(frame: self.bounds)
        z_temp.z_alphabordercolor = 0.3
        z_temp.z_arclinewidth = 3
        z_temp.border(color: "#1F1926".color.withAlphaComponent(0.3), radius: z_temp.height/2, width: 3)
        return z_temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(z_imagelike)
        self.addSubview(z_imageborder1)
        self.addSubview(z_imageborder2)
        self.addSubview(z_imageborder3)
        self.bringSubviewToFront(z_imageborder3)
        self.bringSubviewToFront(z_imageborder2)
        self.bringSubviewToFront(z_imageborder1)
        self.bringSubviewToFront(z_imagelike)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    final func func_startanimation() {
        self.z_imageborder1.func_startarccircle()
        self.z_imageborder2.func_startarccircle()
        self.z_imageborder3.func_startarccircle()
        self.func_startheartbeatanimation()
    }
    final func func_endanimation() {
        self.z_imageborder1.func_endarccircle()
        self.z_imageborder2.func_endarccircle()
        self.z_imageborder3.func_endarccircle()
        self.func_stopheartbeatanimation()
    }
    private final func func_startheartbeatanimation() {
        self.func_stopheartbeatanimation()
        
        let z_temp = CABasicAnimation()
        z_temp.keyPath = "transform.scale"
        z_temp.fromValue = 0.9
        z_temp.toValue = 1.1
        z_temp.repeatCount = MAXFLOAT
        z_temp.duration = 0.3
        z_temp.autoreverses = true
        self.z_imagelike.layer.add(z_temp, forKey: "transformscale")
    }
    private final func func_stopheartbeatanimation() {
        self.z_imagelike.layer.removeAnimation(forKey: "transformscale")
    }
}
