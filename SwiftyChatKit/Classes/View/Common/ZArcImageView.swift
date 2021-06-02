
import UIKit

/// 弧形图片
class ZArcImageView: UIImageView {
    
    var z_alphabordercolor: CGFloat = 0.95
    var z_arcstart: CGFloat = 0.0
    var z_arclinewidth: CGFloat = 3
    
    private var z_arcLayer: CAShapeLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    final func func_startarccircle() {
        z_arcLayer = self.func_createarcircle()
        
        z_arcLayer?.strokeStart = z_arcstart
        z_arcLayer?.strokeEnd = 0.125
        
        let z_temp = CABasicAnimation(keyPath: "transform.rotation.z")
        z_temp.fromValue = 0.0
        z_temp.toValue = M_PI*2
        z_temp.duration = 5
        z_temp.repeatCount = MAXFLOAT
        z_temp.autoreverses = false
        z_temp.fillMode = .forwards
        z_temp.isRemovedOnCompletion = false
        self.layer.add(z_temp, forKey: "arctransformrotationz")
    }
    final func func_endarccircle() {
        self.layer.removeAllAnimations()
        z_arcLayer?.removeFromSuperlayer()
        z_arcLayer = nil
    }
    private func func_createarcircle() -> CAShapeLayer {
        let z_temp = CAShapeLayer()
        z_temp.frame = self.bounds
        z_temp.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        z_temp.fillColor = UIColor.clear.cgColor
        z_temp.lineWidth = z_arclinewidth
        z_temp.strokeColor = "#F3A1BF".color.withAlphaComponent(z_alphabordercolor).cgColor
        
        let z_temppath = UIBezierPath(ovalIn: self.bounds)
        z_temp.path = z_temppath.cgPath
        self.layer.addSublayer(z_temp)
        
        return z_temp
    }
}
