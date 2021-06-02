
import UIKit
import SwiftBasicKit

class ZLoginGenderPickerView: UIView {

    var z_ongenderclick: ((_ gender: zUserGender) -> Void)?
    private lazy var z_btnmale: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(29.scale, 0, self.width - 30.scale, self.height/2))
        z_temp.tag = 1
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setTitle(ZString.lbIAM.text + ZString.lbMale.text, for: .normal)
        z_temp.setTitleColor("#7037E9".color, for: .normal)
        z_temp.contentHorizontalAlignment = .left
        return z_temp
    }()
    private lazy var z_btnfemale: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(29.scale, self.height/2, self.width - 30.scale, self.height/2))
        z_temp.tag = 2
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setTitle(ZString.lbIAM.text + ZString.lbFemale.text, for: .normal)
        z_temp.setTitleColor("#EF7F9C".color, for: .normal)
        z_temp.contentHorizontalAlignment = .left
        return z_temp
    }()
    private lazy var z_viewline: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(0, self.height/2, self.width, 0.5.scale))
        z_temp.backgroundColor = "#2D2638".color
        return z_temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(z_btnmale)
        self.addSubview(z_btnfemale)
        self.addSubview(z_viewline)
        self.backgroundColor = "#1F1825".color
        self.clipsToBounds = true
        
        z_btnmale.addTarget(self, action: "func_btngenderclick:", for: .touchUpInside)
        z_btnfemale.addTarget(self, action: "func_btngenderclick:", for: .touchUpInside)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    @objc private func func_btngenderclick(_ sender: UIButton) {
        self.z_ongenderclick?(sender.tag == 1 ? .male : .female)
    }
}
