
import UIKit
import SwiftBasicKit

class ZMatchLookingViewController: ZZBaseViewController {
    
    var z_type: Int = 1 {
        didSet {
            switch self.z_type {
            case 1: self.z_gender = .none
            case 2: self.z_gender = .female
            case 3: self.z_gender = .female
            default: break
            }
        }
    }
    private var z_waittimes: [Double] = [8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
    private var z_isstartmatch: Bool = false
    private var z_matchcoins: Double {
        switch self.z_type {
        case 2: return Double(ZConfig.shared.match_price_female)
        case 3: return Double(ZConfig.shared.match_price_male)
        default: break
        }
        return Double(ZConfig.shared.match_price_both)
    }
    private var z_gender: zUserGender = .none
    private lazy var z_btncoins: ZBalanceButton = {
        let z_temp = ZBalanceButton.init(frame: CGRect.init(kScreenWidth - 100.scale, kStatusHeight, 90.scale, 45))
        return z_temp
    }()
    private lazy var z_btnlooking: ZMatchLookingButton = {
        let z_temp = ZMatchLookingButton.init(frame: CGRect.init(kScreenWidth/2 - 328.scale/2, kStatusHeight + 100, 328.scale, 328.scale))
        
        return z_temp
    }()
    private lazy var z_lblookingtitle: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(0, z_btnlooking.y + z_btnlooking.height, kScreenWidth, 30))
        z_temp.textAlignment = .center
        z_temp.text = ZString.lbLooking.text
        z_temp.textColor = "#FFF5F5".color
        z_temp.boldSize = 24
        return z_temp
    }()
    private lazy var z_lblookingdesc: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(kScreenWidth/2 - 100.scale, z_lblookingtitle.y + z_lblookingtitle.height + 20.scale, 200.scale, 40))
        z_temp.textAlignment = .center
        z_temp.text = ZString.lbLookDesc.text
        z_temp.textColor = "#515158".color
        z_temp.boldSize = 15
        z_temp.numberOfLines = 0
        return z_temp
        return z_temp
    }()
    private lazy var z_btnrecharge: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(z_lblookingdesc.x, z_lblookingdesc.y + z_lblookingdesc.height, z_lblookingdesc.width, 50.scale))
        z_temp.isHidden = true
        z_temp.customStyle()
        z_temp.setTitle(ZString.lbRecharge.text, for: .normal)
        return z_temp
    }()
    private let z_viewmodel: ZMatchViewModel = ZMatchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        z_viewmodel.vc = self
        self.isNavigationAlpha = 0
        self.view.addSubview(z_btncoins)
        self.view.addSubview(z_btnlooking)
        self.view.addSubview(z_lblookingtitle)
        self.view.addSubview(z_lblookingdesc)
        //self.view.addSubview(z_btnrecharge)
        self.view.bringSubviewToFront(z_lblookingtitle)
        
        z_viewmodel.delegate = self
        //z_btnrecharge.addTarget(self, action: "func_btnrechargeclick", for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: "func_UserBalanceChange:", name: Notification.Names.UserBalanceChange, object: nil)
        //NotificationCenter.default.addObserver(self, selector: "func_ShowVideoEndVC:", name: Notification.Names.ShowVideoEndVC, object: nil)
    }
    deinit {
        z_viewmodel.delegate = nil
        NotificationCenter.default.removeObserver(self, name: Notification.Names.UserBalanceChange, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        z_btncoins.text = ZSettingKit.shared.balance.str
        //z_btnrecharge.isHidden = ZSettingKit.shared.balance > self.z_matchcoins
        //z_lblookingdesc.isHidden = ZSettingKit.shared.balance <= self.z_matchcoins
        z_btnlooking.func_startanimation()
        
        func_audomatchuser()
        ZAudioCallManager.shared.playSound(name: "match")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        z_btnlooking.func_endanimation()
        ZAudioCallManager.shared.stopSound()
    }
    private func func_audomatchuser() {
        if !self.isCurrentShowVC || self.z_isstartmatch { return }
        var after = self.z_waittimes.sample ?? 10
        #if DEBUG
        after = 3
        #endif
        DispatchQueue.DispatchAfter(after: after, handler: { [weak self] in
            guard let `self` = self else { return }
            self.z_isstartmatch = true
            self.z_viewmodel.func_reloadmatchuser(gender: self.z_gender)
            self.func_audomatchuser()
        })
    }
    @objc private func func_btnrechargeclick() {
        NotificationCenter.default.post(name: Notification.Names.ShowRechargeVC, object: 2)
    }
    @objc override func func_UserBalanceChange(_ sender: Notification) {
        z_btncoins.text = ZSettingKit.shared.balance.str
    }
}
extension ZMatchLookingViewController: ZMatchViewModelDelegate {
    
    func func_reloadusercount(count: Int) {
        
    }
    func func_matchuserend(model: ZModelUserInfo?) {
        self.z_isstartmatch = false
        guard let user = model else { return }
        let z_tempvc = ZUserDetailViewController.init()
        z_tempvc.z_model = user
        z_tempvc.z_isCountdown = true
        ZRouterKit.push(toVC: z_tempvc, fromVC: self, animated: true)
    }
}
