
import UIKit
import BFKit
import SwiftBasicKit

class ZMainViewController: UITabBarController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    override var shouldAutorotate: Bool {
        return self.selectedViewController?.shouldAutorotate ?? false
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.selectedViewController?.supportedInterfaceOrientations ?? UIInterfaceOrientationMask.portrait
    }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.selectedViewController?.preferredInterfaceOrientationForPresentation ?? UIInterfaceOrientation.portrait
    }
    required convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.modalPresentationStyle = .fullScreen
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.tabBar.isTranslucent = true
        self.tabBar.shadowImage = UIImage.withColor(ZColor.shared.TabBarLineColor)?.withAlpha(0)
        self.tabBar.backgroundImage = UIImage.withColor(ZColor.shared.TabBarTintColor)?.withAlpha(0)
        NotificationCenter.default.addObserver(self, selector: #selector(func_ReceivedNewMessage(_:)), name: Notification.Names.ReceivedNewMessage, object: nil)
        NotificationCenter.default.addObserver(self, selector: "func_ShowAnchorListVC", name: NSNotification.Name.init(rawValue: "ShowAnchorListVC"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.func_setitems()
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Names.ReceivedNewMessage, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "ShowAnchorListVC"), object: nil)
    }
    private func func_setitems() {
        let count = self.viewControllers?.count ?? 0
        if count == 0 {
            
            let item1VC = ZMatchViewController.init(nibName: nil, bundle: nil)
            let item1Image = Asset.tabMatch.image
            let itemSelect1Image = Asset.tabMatchS.image
            self.func_addchild(vc: item1VC, item1Image, itemSelect1Image, "")
            let item1RVC = ZNavigationController.init(rootViewController: item1VC)
            
            let item2VC = ZAnchorsViewController.init(nibName: nil, bundle: nil)
            let item2Image = Asset.tabSearch.image
            let itemSelect2Image = Asset.tabSearchS.image
            self.func_addchild(vc: item2VC, item2Image, itemSelect2Image, "")
            let item2RVC = ZNavigationController.init(rootViewController: item2VC)
            
            let item3VC = ZChatListViewController.init(nibName: nil, bundle: nil)
            let item3Image = Asset.tabMseeage.image
            let itemSelect3Image = Asset.tabMseeageS.image
            self.func_addchild(vc: item3VC, item3Image, itemSelect3Image, "")
            let item3RVC = ZNavigationController.init(rootViewController: item3VC)
            
            let item4VC = ZUserViewController.init(nibName: nil, bundle: nil)
            let item4Image = Asset.tabSetting.image
            let itemSelect4Image = Asset.tabSettingS.image
            self.func_addchild(vc: item4VC, item4Image, itemSelect4Image, "")
            let item4RVC = ZNavigationController.init(rootViewController: item4VC)
            
            self.viewControllers = [item1RVC, item2RVC, item3RVC, item4RVC]
            self.selectedIndex = 0
            
            ZCurrentVC.shared.rootVC = item1RVC
        }
        self.func_setunreadcount()
    }
    @objc private func func_ShowAnchorListVC() {
        self.selectedIndex = 1
    }
    @objc private func func_ReceivedNewMessage(_ sender: Notification) {
        self.func_setunreadcount()
    }
    private func func_setunreadcount() {
        guard let item = self.tabBar.items?[2] else { return }
        var count: Int = 0
        ZSQLiteKit.getMessageUnreadCount(count: &count)
        item.badgeValue = count > 0 ? "\(count > 99 ? 99 : count)" : nil
    }
    private func func_addchild(vc: UIViewController, _ unimage: UIImage, _ selimage: UIImage, _ title: String) {
        vc.tabBarItem = nil
        let tabBarItem = UITabBarItem.init(title: title, image: unimage.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: selimage.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        
        let fontsize = UIFont.systemFont(12)
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: fontsize], for: .normal)
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: fontsize], for: .selected)
        tabBarItem.badgeColor = "#C12070".color
        vc.tabBarItem = tabBarItem
    }
}
extension ZMainViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController.isMember(of: ZNavigationController.classForCoder()) {
            ZCurrentVC.shared.rootVC = viewController as? ZNavigationController
        } else {
            ZCurrentVC.shared.rootVC = viewController.navigationController as? ZNavigationController
        }
    }
}
