
import UIKit
import SwiftDate
import SwiftBasicKit

internal let kMatchFilterKey: String = "kMatchFilterKey"

class ZMatchViewController: ZZBaseViewController {
    
    private var z_isautousercount: Bool = false
    private var z_lastusercount: Int = 2000
    private lazy var z_btnfilter: ZMatchFilterButton = {
        let z_temp = ZMatchFilterButton.init(frame: CGRect.init(10, kStatusHeight + 2, 112.scale, 30))
        z_temp.tag = 1
        z_temp.backgroundColor = "#2D2538".color
        z_temp.border(color: .clear, radius: 15, width: 0)
        return z_temp
    }()
    private lazy var z_btncoins: ZBalanceButton = {
        let z_temp = ZBalanceButton.init(frame: CGRect.init(kScreenWidth - 100.scale, kStatusHeight, 90.scale, 45))
        return z_temp
    }()
    private lazy var z_viewmatchanchors: ZMatchAnchorsView = {
        let z_tempy = z_btnfilter.y + z_btnfilter.height
        let z_temp = ZMatchAnchorsView.init(frame: CGRect.init(0, kIsIPhoneX ? z_tempy + 70.scale : z_tempy, kScreenWidth, 345))
        
        return z_temp
    }()
    private lazy var z_lbusercount: ZCountingLabel = {
        let z_tempy = z_viewmatchanchors.y + z_viewmatchanchors.height + 20.scale
        let z_temp = ZCountingLabel.init(frame: CGRect.init(kScreenWidth/2 - 50, kIsIPhoneX ? z_tempy + 20.scale : z_tempy, 100, 24))
        z_temp.textAlignment = .center
        z_temp.textColor = "#E9E9E9".color
        z_temp.boldSize = 24
        return z_temp
    }()
    private lazy var z_lbmatchuserdesc: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(0, z_lbusercount.y + z_lbusercount.height + 5.scale, kScreenWidth, 20))
        z_temp.textAlignment = .center
        z_temp.textColor = "#515158".color
        z_temp.boldSize = 12
        z_temp.text = ZString.lbPeopleAreOnline.text
        return z_temp
    }()
    private lazy var z_imagematchcoins: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(kScreenWidth/2 - 16, z_lbmatchuserdesc.y + z_lbmatchuserdesc.height + 16, 16, 18))
        z_temp.image = Asset.iconDiamond1.image
        return z_temp
    }()
    private lazy var z_lbmatchcoins: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(z_imagematchcoins.x + z_imagematchcoins.width + 5, z_imagematchcoins.y - 1, 150, 20))
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 17
        z_temp.text = ZConfig.shared.match_price_both.str
        return z_temp
    }()
    private lazy var z_btnstart: ZMatchStartButton = {
        let z_tempy = z_imagematchcoins.y + z_imagematchcoins.height + 26.scale
        let z_temp = ZMatchStartButton.init(frame: CGRect.init(31.scale, kIsIPhoneX ? z_tempy + 20.scale : z_tempy, 314.scale, 87.scale))
        return z_temp
    }()
    private let z_viewmodel: ZMatchViewModel = ZMatchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        z_viewmodel.vc = self
        self.isNavigationHidden = true
        self.view.addSubview(z_btnfilter)
        self.view.addSubview(z_btncoins)
        self.view.bringSubviewToFront(z_btncoins)
        self.view.addSubview(z_viewmatchanchors)
        self.view.addSubview(z_lbusercount)
        self.view.addSubview(z_lbmatchuserdesc)
        self.view.addSubview(z_imagematchcoins)
        self.view.addSubview(z_lbmatchcoins)
        self.view.addSubview(z_btnstart)
        
        self.view.addSubview(z_btnfirst)
        self.view.bringSubviewToFront(z_btnfirst)
        
        z_btncoins.addTarget(self, action: "func_btncoinsclick", for: .touchUpInside)
        z_btnfilter.addTarget(self, action: "func_btnfilterclick", for: .touchUpInside)
        z_btnstart.addTarget(self, action: "func_btnstartclick", for: .touchUpInside)
        
        z_viewmodel.func_reloadusercount()
        z_viewmodel.delegate = self
        
        z_btnfilter.tag = ((ZSettingKit.shared.getUserConfig(key: "kMatchFilterKey") as? String) ?? "1").intValue
        didSelectChange(type: z_btnfilter.tag)
        func_reloaduserinfo()
        NotificationCenter.default.addObserver(self, selector: "func_PayRechargeSuccess:", name: Notification.Name.init(rawValue: "PayRechargeSuccess"), object: nil)
        NotificationCenter.default.addObserver(self, selector: "func_UserBalanceChange:", name: Notification.Names.UserBalanceChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: "func_UserInfoRefresh:", name: Notification.Name.init(rawValue: "UserInfoRefresh"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        z_isautousercount = true
        func_startautouseronlinecount()
        z_btncoins.text = ZSettingKit.shared.balance.str
        
        z_btnstart.startAnimation()
        z_viewmatchanchors.func_startscrolling()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        z_isautousercount = false
        z_btnstart.stopAnimation()
    }
    deinit {
        z_viewmodel.delegate = nil
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init(rawValue: "PayRechargeSuccess"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Names.UserBalanceChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init(rawValue: "UserInfoRefresh"), object: nil)
    }
    override func func_UserBalanceChange(_ sender: Notification) {
        super.func_UserBalanceChange(sender)
        
        z_btncoins.text = ZSettingKit.shared.balance.str
    }
    @objc private func func_btncoinsclick() {
        let z_tempvc = ZRechargeViewController.init()
        ZRouterKit.push(toVC: z_tempvc, fromVC: self, animated: true)
    }
    @objc private func func_btnstartclick() {
        let z_tempvc = ZMatchLookingViewController.init()
        z_tempvc.z_type = self.z_btnfilter.tag
        ZRouterKit.push(toVC: z_tempvc, fromVC: self, animated: true)
    }
    @objc private func func_btnfilterclick() {
        let z_tempvc = ZMatchFilterViewController.init()
        z_tempvc.delete = self
        z_tempvc.z_type = z_btnfilter.tag
        z_tempvc.showType = 2
        ZRouterKit.present(toVC: z_tempvc, fromVC: self, animated: false, completion: {
            z_tempvc.func_showviewcontent()
        })
    }
    private func func_startautouseronlinecount() {
        if self.z_isautousercount {
            DispatchQueue.DispatchAfter(after: 5, handler: {
                var random = [Int]()
                var minCount = Int(self.z_lastusercount - 20)
                minCount = minCount <= 1000 ? 1001: minCount
                minCount = minCount >= 3000 ? 3001: minCount
                var maxCount = Int(self.z_lastusercount + 20)
                maxCount = maxCount <= 1020 ? 1021: maxCount
                maxCount = maxCount >= 3020 ? 3021: maxCount
                for item in minCount...maxCount {
                    random.append(item)
                }
                let count = random.sample ?? Int(self.z_lastusercount) + 2
                self.func_reloadusercount(count: count)
            })
        }
    }
    private func func_reloaduserinfo() {
        ZNetworkKit.created.startRequest(target: .get(ZAction.apiuser.api, nil), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success, let dic = result.body as? [String: Any] {
                ZSettingKit.shared.updateUser(dic: dic)
                guard let model = ZModelUserInfo.deserialize(from: dic) else { return }
                if let activity = model.activity,
                   let new_user_draw_token = activity["new_user_draw_token"] as? [String: Any],
                   let token_amount = new_user_draw_token["token_amount"] as? Int, token_amount > 0 {
                    DispatchQueue.DispatchAfter(after: 5, handler: { [weak self] in
                        guard let `self` = self, self.isVideoVCing == false else { return }
                        let z_tempvc = ZFreePackageViewController()
                        z_tempvc.z_coins = token_amount
                        ZRouterKit.present(toVC: z_tempvc, animated: false)
                    })
                }
                if let activity = model.activity, let first_recharge = activity["first_recharge"] as? [String: Any], let recharge = ZModelRecharge.deserialize(from: first_recharge) {
                    DispatchQueue.DispatchAfter(after: 10, handler: { [weak self] in
                        guard let `self` = self, self.isVideoVCing == false else { return }
                        let z_tempvc = ZFirstPackageViewController()
                        z_tempvc.z_modelr = recharge.copyable()
                        ZRouterKit.present(toVC: z_tempvc, animated: false)
                    })
                }
                NotificationCenter.default.post(name: Notification.Name.init(rawValue: "UserInfoRefresh"), object: nil)
            }
        })
    }
}
extension ZMatchViewController: ZMatchFilterViewControllerDelete {
    
    func didSelectChange(type: Int) {
        self.z_btnfilter.tag = type
        switch type {
        case 1: self.z_lbmatchcoins.text = ZConfig.shared.match_price_both.str
        case 2: self.z_lbmatchcoins.text = ZConfig.shared.match_price_male.str
        case 3: self.z_lbmatchcoins.text = ZConfig.shared.match_price_female.str
        default: self.z_lbmatchcoins.text = ZConfig.shared.match_price_both.str
        }
        ZSettingKit.shared.setUserConfig(key: kMatchFilterKey, value: type.str)
    }
}
extension ZMatchViewController: ZMatchViewModelDelegate {
    
    func func_reloadusercount(count: Int) {
        self.z_lbusercount.animate(fromValue: Double(self.z_lastusercount), toValue: Double(count), duration: 3)
        self.z_lastusercount = count
        self.func_startautouseronlinecount()
    }
    func func_insufficientbalance(msg: String) {
        
    }
    func func_matchuserend(model: ZModelUserInfo?) {
        
    }
}
