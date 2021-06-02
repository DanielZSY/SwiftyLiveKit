
import UIKit
import BFKit
import SwiftBasicKit

class ZObserverManager: NSObject {
    
    static let shared = ZObserverManager.init()
    
    override init() {
        super.init()
    }
    final func configObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.funcShowRechargeVC(_:)), name: Notification.Names.ShowRechargeVC, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.funcShowVideoEndVC(_:)), name: Notification.Names.ShowVideoEndVC, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.funcShowUserDetailVC(_:)), name: Notification.Names.ShowUserDetailVC, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.funcLoginExpired(_:)), name: Notification.Names.LoginExpired, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.funcInsufficientBalance(_:)), name: Notification.Names.InsufficientBalance, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.funcShowUpdateVC(_:)), name: Notification.Name.init(rawValue: "ShowUpdateVC"), object: nil)
    }
    final func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: Notification.Names.ShowRechargeVC, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Names.ShowVideoEndVC, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Names.ShowUserDetailVC, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Names.LoginExpired, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Names.InsufficientBalance, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init(rawValue: "ShowUpdateVC"), object: nil)
    }
    @objc private func funcLoginExpired(_ sender: Notification) {
        if ZSettingKit.shared.isLogin {
            ZSettingKit.shared.logout()
            ZConfig.shared.configRoot()
        }
    }
    @objc private func funcShowRechargeVC(_ sender: Notification) {
        if let dic = sender.object as? [String: Any] {
            let z_tempvc = ZRechargeWebViewController.init()
            z_tempvc.z_link = dic["link"] as? String
            z_tempvc.z_success = dic["success"] as? String
            z_tempvc.z_failed = dic["failed"] as? String
            z_tempvc.z_title = dic["title"] as? String
            z_tempvc.showType = 2
            ZRouterKit.present(toVC: z_tempvc, animated: false, completion: nil)
            return
        }
        guard let _ = sender.object as? Int else { return }
        let z_tempvc = ZRechargeAlertViewController.init()
        z_tempvc.showType = 2
        ZRouterKit.present(toVC: z_tempvc, animated: false, completion: nil)
    }
    @objc private func funcShowVideoEndVC(_ sender: Notification) {
        guard let dic = sender.object as? [String: Any] else { return }
        BFLog.debug("funcShowVideoEndVC object: \(dic)")
    }
    @objc private func funcShowUserDetailVC(_ sender: Notification) {
        guard let model = sender.object as? ZModelUserInfo else { return }
        let z_tempvc = ZUserDetailViewController()
        z_tempvc.z_model = model.copyable()
        ZRouterKit.push(toVC: z_tempvc, animated: true)
    }
    @objc private func funcShowUpdateVC(_ sender: Notification) {
        guard let model = sender.object as? ZModelUpdate else { return }
        DispatchQueue.DispatchAfter(after: 10, handler: {
            let z_tempvc = ZUpdateViewController.init()
            z_tempvc.z_model = model
            ZRouterKit.present(toVC: z_tempvc, animated: false, completion: nil)
        })
    }
    /// 余额不足
    @objc private func funcInsufficientBalance(_ sender: Notification) {
        if self.isVideoVCing { return }
        let z_tempvc = ZRechargeAlertViewController.init()
        z_tempvc.showType = 2
        ZRouterKit.present(toVC: z_tempvc, animated: false, completion: nil)
    }
    private var isVideoVCing: Bool {
        if let currentVC = ZRouterKit.getCurrentVC(), let callVC = NSClassFromString("ZVideoViewController"), currentVC.isMember(of: callVC) {
            return true
        }
        return false
    }
}
