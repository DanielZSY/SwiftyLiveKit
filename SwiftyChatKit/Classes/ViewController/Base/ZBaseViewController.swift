
import UIKit
import SwiftBasicKit

class ZZBaseViewController: ZBaseViewController {
    
    internal var isVideoVCing: Bool {
        if let currentVC = ZRouterKit.getCurrentVC(), let callVC = NSClassFromString("ZCallViewController"), currentVC.isMember(of: callVC) {
            return true
        }
        if let currentVC = ZRouterKit.getCurrentVC(), let callVC = NSClassFromString("ZVideoViewController"), currentVC.isMember(of: callVC) {
            return true
        }
        return false
    }
    internal lazy var z_btnfirst: ZFirstPackageButton = {
        let z_temp = ZFirstPackageButton.init(frame: CGRect.init(kScreenWidth - 67.scale - 12.scale, kScreenHeight - kTabbarHeight - 12.scale - 63.scale, 67.scale, 63.scale))
        z_temp.tag = 101
        z_temp.isHidden = true
        z_temp.isUserInteractionEnabled = true
        z_temp.addTarget(self, action: "func_showFirstVC", for: .touchUpInside)
        return z_temp
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .lightContent
        } else {
            return .lightContent
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isNavigationAlpha = 1
        self.imageBack = Asset.arrowLeftW.image
        self.setNavBarLeftButton(isBack: true)
        self.view.backgroundColor = ZColor.shared.ViewBackgroundColor
        self.navigationController?.navigationBar.tintColor = ZColor.shared.NavBarButtonColor
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ZColor.shared.NavBarTitleColor]
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.func_showFirstButton()
    }
    @objc func func_UserBalanceChange(_ sender: Notification) {
        if let _ = self.view.viewWithTag(101) {
            self.func_dismissFirstButton()
        }
    }
    @objc func func_PayRechargeSuccess(_ sender: Notification) {
        ZNetworkKit.created.startRequest(target: .get(ZAction.apiuser.api, nil), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success, let dic = result.body as? [String: Any] {
                ZSettingKit.shared.updateUser(dic: dic)
                self.func_dismissFirstButton()
            }
        })
    }
    @objc func func_UserInfoRefresh(_ sender: Notification) {
        self.func_showFirstButton()
    }
    private final func func_dismissFirstButton() {
        if !z_btnfirst.isHidden {
            z_btnfirst.isHidden = true
            z_btnfirst.stopAnimation()
        }
    }
    private final func func_showFirstButton() {
        guard let _ = self.view.viewWithTag(101) else { return }
        if let activity = ZSettingKit.shared.user?.activity, let first_recharge = activity["first_recharge"] as? [String: Any], let recharge = ZModelRecharge.deserialize(from: first_recharge) {
            let date = Date.time()
            if let localtime = ZSettingKit.shared.getUserConfig(key: "first_recharge_start_time") as? TimeInterval {
                let localdate = Date.init(timeIntervalSince1970: localtime)
                if date.timeIntervalSince1970 - localtime >= 24*60*60 { return }
                z_btnfirst.setFirstTime(time: localtime)
            } else {
                ZSettingKit.shared.setUserConfig(key: "first_recharge_start_time", value: date.timeIntervalSince1970)
                z_btnfirst.setFirstTime(time: date.timeIntervalSince1970)
            }
            z_btnfirst.isHidden = false
            z_btnfirst.startAnimation()
        } else {
            z_btnfirst.isHidden = true
            z_btnfirst.stopAnimation()
        }
    }
    @objc final func func_showFirstVC() {
        if let activity = ZSettingKit.shared.user?.activity, let first_recharge = activity["first_recharge"] as? [String: Any], let recharge = ZModelRecharge.deserialize(from: first_recharge) {
            let z_tempvc = ZFirstPackageViewController()
            z_tempvc.z_modelr = recharge.copyable()
            ZRouterKit.present(toVC: z_tempvc, animated: false)
        }
    }
}
