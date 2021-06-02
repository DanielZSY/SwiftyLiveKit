
import UIKit
import SwiftBasicKit

internal protocol ZMatchFilterViewControllerDelete: class {
    func didSelectChange(type: Int)
}
class ZMatchFilterViewController: ZZBaseViewController {
    
    weak var delete: ZMatchFilterViewControllerDelete?
    var z_type: Int = 1
    
    private lazy var z_viewbg: UIView = {
        let z_temp = UIView.init(frame: CGRect.main())
        z_temp.backgroundColor = "#000000".color.withAlphaComponent(0.6)
        return z_temp
    }()
    private lazy var z_viewcontent: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(0, kScreenHeight, kScreenWidth, 255.scale))
        z_temp.alpha = 0
        z_temp.backgroundColor = "#1E1925".color
        return z_temp
    }()
    private lazy var z_lbtitle: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(0, 25.scale, z_viewcontent.width, 24))
        z_temp.text = ZString.lbMatchTypeTitle.text
        z_temp.textAlignment = .center
        z_temp.textColor = "#E9E9E9".color
        z_temp.boldSize = 18
        return z_temp
    }()
    private lazy var z_btnboth: ZMatchFilterItemButton = {
        let z_temp = ZMatchFilterItemButton.init(frame: CGRect.init(34.scale, 76.scale, 96.scale, 103.scale))
        z_temp.tag = 1
        z_temp.border(color: .clear, radius: 15, width: 0)
        return z_temp
    }()
    private lazy var z_btnfemale: ZMatchFilterItemButton = {
        let z_temp = ZMatchFilterItemButton.init(frame: CGRect.init(z_btnboth.x + z_btnboth.width + 10.scale, 76.scale, 96.scale, 103.scale))
        z_temp.tag = 2
        z_temp.border(color: .clear, radius: 15, width: 0)
        return z_temp
    }()
    private lazy var z_btnmale: ZMatchFilterItemButton = {
        let z_temp = ZMatchFilterItemButton.init(frame: CGRect.init(z_btnfemale.x + z_btnfemale.width + 10.scale, 76.scale, 96.scale, 103.scale))
        z_temp.tag = 3
        z_temp.border(color: .clear, radius: 15, width: 0)
        return z_temp
    }()
    private lazy var z_lbcoinstitle: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(117.scale, z_btnboth.y + z_btnboth.height + 15.scale, 100, 30.scale))
        z_temp.text = ZString.lbMyCoins.text + ":"
        z_temp.textColor = "#E9E9E9".color
        z_temp.boldSize = 12
        return z_temp
    }()
    private lazy var z_imagecoins: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(182.scale, z_lbcoinstitle.y + 8.scale, 12.scale, 14.scale))
        z_temp.image = Asset.iconDiamond1.image
        return z_temp
    }()
    private lazy var z_lbcoins: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(z_imagecoins.x + z_imagecoins.width + 8.scale, z_lbcoinstitle.y, 150, 30.scale))
        z_temp.text = "0"
        z_temp.textColor = "#E9E9E9".color
        z_temp.boldSize = 12
        return z_temp
    }()
    private lazy var z_btncontinue: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(34.scale, z_viewcontent.height - 75, 308.scale, 45))
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setTitle(ZString.btnContinue.text, for: .normal)
        z_temp.setTitleColor("#E9E9E9".color, for: .normal)
        z_temp.titleLabel?.boldSize = 18
        z_temp.backgroundColor = "#7037E9".color
        z_temp.border(color: .clear, radius: 45/2, width: 0)
        return z_temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
        self.view.addSubview(z_viewbg)
        self.view.addSubview(z_viewcontent)
        self.view.bringSubviewToFront(z_viewcontent)
        
        z_viewcontent.addSubview(z_lbtitle)
        z_viewcontent.addSubview(z_btnboth)
        z_viewcontent.addSubview(z_btnfemale)
        z_viewcontent.addSubview(z_btnmale)
        z_viewcontent.addSubview(z_lbcoinstitle)
        z_viewcontent.addSubview(z_imagecoins)
        z_viewcontent.addSubview(z_lbcoins)
        //z_viewcontent.addSubview(z_btncontinue)
        
        z_lbcoins.text = ZSettingKit.shared.balance.str
        //z_btncontinue.addTarget(self, action: "func_btncontinueclick", for: .touchUpInside)
        z_viewbg.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: "func_viewbgtap:"))
        
        z_btnboth.addTarget(self, action: "func_btntypeclick:", for: .touchUpInside)
        z_btnfemale.addTarget(self, action: "func_btntypeclick:", for: .touchUpInside)
        z_btnmale.addTarget(self, action: "func_btntypeclick:", for: .touchUpInside)
        
        func_typechange()
    }
    private func func_typechange() {
        switch self.z_type {
        case 1:
            z_btnboth.isSelected = true
            z_btnfemale.isSelected = false
            z_btnmale.isSelected = false
        case 2:
            z_btnboth.isSelected = false
            z_btnfemale.isSelected = true
            z_btnmale.isSelected = false
        case 3:
            z_btnboth.isSelected = false
            z_btnfemale.isSelected = false
            z_btnmale.isSelected = true
        default: break
        }
    }
    @objc private func func_btntypeclick(_ sender: ZMatchFilterItemButton) {
        self.z_type = sender.tag
        self.func_typechange()
        self.func_btncontinueclick()
    }
    @objc private func func_viewbgtap(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            UIView.animate(withDuration: 0.25, animations: {
                self.z_viewcontent.y = kScreenHeight
                self.z_viewbg.alpha = 0
            }, completion: { _ in
                ZRouterKit.dismiss(fromVC: self, animated: false, completion: nil)
            })
        default: break
        }
    }
    @objc private func func_btncontinueclick() {
        self.delete?.didSelectChange(type: self.z_type)
        UIView.animate(withDuration: 0.25, animations: {
            self.z_viewcontent.y = kScreenHeight
            self.z_viewbg.alpha = 0
        }, completion: { _ in
            ZRouterKit.dismiss(fromVC: self, animated: false, completion: nil)
        })
    }
    final func func_showviewcontent() {
        UIView.animate(withDuration: 0.25, animations: {
            self.z_viewbg.alpha = 1
            self.z_viewcontent.alpha = 1
            self.z_viewcontent.y = kScreenHeight - self.z_viewcontent.height
        })
    }
}
