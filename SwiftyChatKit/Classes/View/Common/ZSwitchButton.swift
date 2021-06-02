
import UIKit
import SwiftBasicKit

class ZSwitchButton: UIButton {

    var isOn: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.25, animations: {
                if self.isOn {
                    self.backgroundColor = "#1E1925".color
                    self.z_imageicon.tintColor = "#515158".color
                    self.z_imageicon.x = 1
                } else {
                    self.backgroundColor = "#515158".color
                    self.z_imageicon.tintColor = "#F4F4F4".color
                    self.z_imageicon.x = self.width -  1 - self.z_imageicon.width
                }
            })
        }
    }
    private lazy var z_imageicon: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(1, 1, self.height - 2, self.height - 2))
        z_temp.image = UIImage.init(color: "#F4F4F4".color)?.withRenderingMode(.alwaysTemplate)
        z_temp.tintColor = "#515158".color
        z_temp.border(color: .clear, radius: z_temp.height/2, width: 0)
        return z_temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(z_imageicon)
        self.border(color: .clear, radius: self.height/2, width: 0)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
