
import UIKit
import SwiftBasicKit

class ZRankViewController: ZZBaseViewController {
    
    private var z_currentpage: Int = 0
    private lazy var z_btnback: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(0, kStatusHeight, 55, 50))
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setImage(Asset.arrowLeftW.image, for: .normal)
        return z_temp
    }()
    private let btnitemw = (kScreenWidth - 50)/4
    private lazy var z_btnanchor: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(50, kStatusHeight, btnitemw, 45))
        z_temp.tag = 1
        z_temp.isSelected = true
        z_temp.isHighlighted = false
        z_temp.titleLabel?.boldSize = 18
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setTitle(ZString.lbAnchor.text, for: .normal)
        z_temp.setTitle(ZString.lbAnchor.text, for: .selected)
        z_temp.setTitleColor("#493443".color, for: .normal)
        z_temp.setTitleColor("#FFFFFF".color, for: .selected)
        return z_temp
    }()
    private lazy var z_btngold: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(z_btnanchor.x + z_btnanchor.width, kStatusHeight, btnitemw, 45))
        z_temp.tag = 2
        z_temp.isSelected = false
        z_temp.isHighlighted = false
        z_temp.titleLabel?.boldSize = 18
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setTitle(ZString.lbGold.text, for: .normal)
        z_temp.setTitle(ZString.lbGold.text, for: .selected)
        z_temp.setTitleColor("#493443".color, for: .normal)
        z_temp.setTitleColor("#FFFFFF".color, for: .selected)
        return z_temp
    }()
    private lazy var z_btngift: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(z_btngold.x + z_btngold.width, kStatusHeight, btnitemw, 45))
        z_temp.tag = 3
        z_temp.isSelected = false
        z_temp.isHighlighted = false
        z_temp.titleLabel?.boldSize = 18
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setTitle(ZString.lbGift.text, for: .normal)
        z_temp.setTitle(ZString.lbGift.text, for: .selected)
        z_temp.setTitleColor("#493443".color, for: .normal)
        z_temp.setTitleColor("#FFFFFF".color, for: .selected)
        return z_temp
    }()
    private lazy var z_btnlover: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(z_btngift.x + z_btngift.width, kStatusHeight, btnitemw, 45))
        z_temp.tag = 4
        z_temp.isSelected = false
        z_temp.isHighlighted = false
        z_temp.titleLabel?.boldSize = 18
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setTitle(ZString.lbLover.text, for: .normal)
        z_temp.setTitle(ZString.lbLover.text, for: .selected)
        z_temp.setTitleColor("#493443".color, for: .normal)
        z_temp.setTitleColor("#FFFFFF".color, for: .selected)
        return z_temp
    }()
    private lazy var z_viewmain: UIView = {
        let z_temp = UIView.init(frame: CGRect.main())
        z_temp.backgroundColor = .clear
        return z_temp
    }()
    private lazy var z_viewanchor: ZRankItemView = {
        let z_temp = ZRankItemView.init(vc: self, frame: CGRect.main())
        z_temp.scrollsToTop = true
        z_temp.z_type = .Anchor
        return z_temp
    }()
    private lazy var z_viewgold: ZRankItemView = {
        let z_temp = ZRankItemView.init(vc: self, frame: CGRect.main())
        z_temp.scrollsToTop = false
        z_temp.z_type = .Gold
        return z_temp
    }()
    private lazy var z_viewgift: ZRankItemView = {
        let z_temp = ZRankItemView.init(vc: self, frame: CGRect.main())
        z_temp.scrollsToTop = false
        z_temp.z_type = .Gift
        return z_temp
    }()
    private lazy var z_viewlover: ZRankItemView = {
        let z_temp = ZRankItemView.init(vc: self, frame: CGRect.main())
        z_temp.scrollsToTop = false
        z_temp.z_type = .Lover
        return z_temp
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isNavigationHidden = true
        self.view.addSubview(self.z_btnback)
        self.view.addSubview(self.z_btnanchor)
        self.view.addSubview(self.z_btngold)
        self.view.addSubview(self.z_btngift)
        self.view.addSubview(self.z_btnlover)
        self.view.addSubview(self.z_viewmain)
        self.view.sendSubviewToBack(self.z_viewmain)
        
        self.z_viewmain.addSubview(z_viewanchor)
        self.z_viewmain.addSubview(z_viewgold)
        self.z_viewmain.addSubview(z_viewgift)
        self.z_viewmain.addSubview(z_viewlover)
        
        self.z_btnback.addTarget(self, action: "func_btnbackclick", for: .touchUpInside)
        self.z_btnanchor.addTarget(self, action: "func_btnitemclick:", for: .touchUpInside)
        self.z_btngold.addTarget(self, action: "func_btnitemclick:", for: .touchUpInside)
        self.z_btngift.addTarget(self, action: "func_btnitemclick:", for: .touchUpInside)
        self.z_btnlover.addTarget(self, action: "func_btnitemclick:", for: .touchUpInside)
        
        self.z_viewanchor.func_reloadheader()
        self.z_viewanchor.z_onbuttonphotoclick = { user in
            guard let model = user else { return }
            let z_tempvc = ZUserDetailViewController()
            z_tempvc.z_model = model.copyable()
            ZRouterKit.push(toVC: z_tempvc, fromVC: self, animated: true)
        }
        self.z_viewgift.z_onbuttonphotoclick = { user in
            guard let model = user else { return }
            let z_tempvc = ZUserDetailViewController()
            z_tempvc.z_model = model.copyable()
            ZRouterKit.push(toVC: z_tempvc, fromVC: self, animated: true)
        }
        self.z_viewlover.z_onbuttonphotoclick = { user in
            guard let model = user?.rank_other_people else { return }
            let z_tempvc = ZUserDetailViewController()
            z_tempvc.z_model = model.copyable()
            ZRouterKit.push(toVC: z_tempvc, fromVC: self, animated: true)
        }
    }
    deinit {
        
    }
    @objc private func func_btnbackclick() {
        ZRouterKit.pop(fromVC: self)
    }
    @objc private func func_btnitemclick(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            z_btnanchor.isSelected = true
            z_btngold.isSelected = false
            z_btngift.isSelected = false
            z_btnlover.isSelected = false
            z_viewanchor.scrollsToTop = true
            z_viewgold.scrollsToTop = false
            z_viewgift.scrollsToTop = false
            z_viewlover.scrollsToTop = false
            z_viewanchor.func_reloadheader()
        case 2:
            z_btnanchor.isSelected = false
            z_btngold.isSelected = true
            z_btngift.isSelected = false
            z_btnlover.isSelected = false
            z_viewanchor.scrollsToTop = false
            z_viewgold.scrollsToTop = true
            z_viewgift.scrollsToTop = false
            z_viewlover.scrollsToTop = false
            z_viewgold.func_reloadheader()
        case 3:
            z_btnanchor.isSelected = false
            z_btngold.isSelected = false
            z_btngift.isSelected = true
            z_btnlover.isSelected = false
            z_viewanchor.scrollsToTop = false
            z_viewgold.scrollsToTop = false
            z_viewgift.scrollsToTop = true
            z_viewlover.scrollsToTop = false
            z_viewgift.func_reloadheader()
        case 4:
            z_btnanchor.isSelected = false
            z_btngold.isSelected = false
            z_btngift.isSelected = false
            z_btnlover.isSelected = true
            z_viewanchor.scrollsToTop = false
            z_viewgold.scrollsToTop = false
            z_viewgift.scrollsToTop = false
            z_viewlover.scrollsToTop = true
            z_viewlover.func_reloadheader()
        default: break
        }
    }
}
