
import UIKit
import BFKit
import OneSignal
import SwiftBasicKit
import SwiftyStoreKit
import AlamofireNetworkActivityIndicator

public struct ZConfig {
    
    internal var match_price_both: Int = 6
    internal var match_price_male: Int = 40
    internal var match_price_female: Int = 40
    
    internal var isNotificationAuthorize: Bool {
        let status = OneSignal.getUserDevice()?.getNotificationPermissionStatus()
        return status == .authorized
    }
    public weak var window: UIWindow?
    public var iniVersion: String = ""
    public static var shared = ZConfig()
    internal func configRoot() {
        if ZSettingKit.shared.isLogin {
            self.requestAppConfig()
            self.requestCommonData()
            let itemVC = ZMainViewController()
            self.window?.rootViewController = itemVC
            ZCurrentVC.shared.rootVC = itemVC.viewControllers?.first as? ZNavigationController
        } else {
            let itemVC = ZStartViewController()
            let itemNVC = ZNavigationController.init(rootViewController: itemVC)
            self.window?.rootViewController = itemNVC
            ZCurrentVC.shared.rootVC = itemNVC
        }
        NotificationCenter.post(name: Notification.Name.init(rawValue: "LoginStatusChange"), object: ZSettingKit.shared.isLogin)
    }
    public func configReloadApp(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        #if DEBUG
        ZSettingKit.shared.setUserConfig(key: "kUDIDConfigKey".md5(), value: "")
        #endif
        self.configColor()
        ZConfig.shared.configRoot()
        self.configNotification(launchOptions)
        ZObserverManager.shared.configObserver()
        NetworkActivityIndicatorManager.shared.isEnabled = true
    }
    public func configWillTerminate() {
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "AppWillTerminate"), object: nil, userInfo: nil)
    }
    private func configColor() {
        UITextField.appearance().keyboardAppearance = .dark
        ZProgressHUD.shared.hudLabelText = "Loading"
        ZProgressHUD.shared.hudTextColor = "#FFFFFF".color
        ZProgressHUD.shared.hudBGColor = "#1E1925".color
        ZProgressHUD.shared.hudImage = Asset.hudCircle.image
        
        ZAlertView.shared.attributedButtonColor = "#FFFFFF"
        ZAlertView.shared.attributedCancelColor = "#7037E9"
        
        ZColor.shared.configNavColor(bg: "#100D13", line: "#100D13", btn: "#FFFFFF", title: "#FFFFFF")
        ZColor.shared.configViewColor(bg: "#100D13", border: "#1E1925", title: "#823AF3", desc: "#47474D")
        ZColor.shared.configTabColor(bg: "#1E1925", line: "#1E1925", btnNormal: "#845d79", btnSelect: "#F4F4F4", titleNormal: "#845d79", titleSelect: "#F4F4F4")
        ZColor.shared.configInputColor(bg: "#100D13", border: "#E0E0E0", cursor: "#7037E9", text: "#7037E9", prompt: "#47474D", keybg: "#1F1824")
    }
    private func configNotification(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        #if DEBUG
        OneSignal.setLogLevel(.LL_DEBUG, visualLevel: .LL_NONE)
        #endif
        let notificationReceivedBlock: OSHandleNotificationReceivedBlock = { notification in
            BFLog.debug("Received Notification: \(notification?.payload.notificationID ?? "")")
        }
        let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
            guard let payload: OSNotificationPayload = result?.notification.payload, let userInfo = payload.additionalData else { return }
            self.dealReceiveNotification(userInfo)
        }
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false, kOSSettingsKeyInAppLaunchURL: false]
        OneSignal.initWithLaunchOptions(launchOptions, appId: ZKey.appId.pushAppId, handleNotificationReceived: notificationReceivedBlock, handleNotificationAction: notificationOpenedBlock, settings: onesignalInitSettings)
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.none;
    }
    internal func registerNotification(_ userResponse: ((_ accepted: Bool) -> Void)? = nil) {
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            BFLog.debug("registerNotification accepted: \(accepted)")
            if accepted {
                NotificationCenter.default.post(name: Notification.Name.init(rawValue: "BindPushNotification"), object: nil)
            }
            userResponse?(accepted)
        })
    }
    private func requestCommonData () {
        if ZSettingKit.shared.isLogin {
            DispatchQueue.DispatchAfter(after: 2, handler: {
                ZNetworkKit.created.startRequest(target: .get(ZAction.apisupport.api, nil), responseBlock: { result in
                    if result.success, let dic = result.body as? [String: Any], let model = ZModelUserBase.deserialize(from: dic) {
                        model.role = .customerService
                        ZSQLiteKit.setModel(model: model)
                        
                        var user: ZModelMessageRecord?
                        ZSQLiteKit.getModel(model: &user, filter: "userid = ? AND login_userid = ?", values: [model.userid, ZSettingKit.shared.userId])
                        if user == nil { user = ZModelMessageRecord.init() }
                        user?.message_user = model
                        ZSQLiteKit.setModel(model: user!)
                    }
                })
            })
            DispatchQueue.DispatchAfter(after: 5, handler: {
                ZNetworkKit.created.startRequest(target: .get(ZAction.apitokenlist.api, nil), responseBlock: { result in
                    if result.success, let dic = result.body as? [String: Any], let array = dic["tokens"] as? [Any], let models = [ZModelPurchase].deserialize(from: array) {
                        ZLocalCacheManager.func_setlocaldata(dic: dic, key: "apptokens")
                    }
                })
            })
            DispatchQueue.DispatchAfter(after: 10, handler: {
                ZNetworkKit.created.startRequest(target: .get(ZAction.apigiftlist.api, nil), responseBlock: { result in
                    if result.success, let dic = result.body as? [String: Any], let array = dic["gifts"] as? [Any], let models = [ZModelPurchase].deserialize(from: array) {
                        ZLocalCacheManager.func_setlocaldata(dic: dic, key: "appgifts")
                    }
                })
            })
        }
    }
    private func requestAppConfig() {
        if ZSettingKit.shared.isLogin {
            if let configs = ZSettingKit.shared.getUserConfig(key: "kIniVersionKey") as? [String: Any],
               let version = configs["ini_version"] as? String,
               version == ZConfig.shared.iniVersion {
                return
            }
            ZNetworkKit.created.startRequest(target: .get(ZAction.apiconfig.api, nil), responseBlock: { result in
                if result.success, let dic = result.body as? [String: Any], let model = ZModelConfig.deserialize(from: dic) {
                    ZConfig.shared.match_price_both = model.match_price_both
                    ZConfig.shared.match_price_male = model.match_price_male
                    ZConfig.shared.match_price_female = model.match_price_female
                    if model.agora_app_id.count > 0 {
                        ZKey.shared.configAppId(appleId: ZKey.appId.appleId,
                                                serviceAppId: ZKey.appId.serviceAppId,
                                                messageAppId: model.agora_app_id,
                                                pushAppId: ZKey.appId.pushAppId,
                                                bugAppId: ZKey.appId.bugAppId,
                                                countAppId: ZKey.appId.countAppId)
                    }
                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "AppConfigParam"), object: dic)
                }
            })
        }
    }
    internal func changeIconBadgeNumber() {
        if ZSettingKit.shared.isLogin {
            var count: Int = 0
            ZSQLiteKit.getMessageUnreadCount(count: &count)
            UIApplication.shared.applicationIconBadgeNumber = count
        } else {
            self.clearIconBadgeNumber()
        }
    }
    internal func clearIconBadgeNumber() {
        UIApplication.shared.applicationIconBadgeNumber = 1
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    private func dealReceiveNotification(_ userinfo: [AnyHashable: Any]) {
        BFLog.debug("dealReceiveNotification  userinfo: \(userinfo)")
        let dicCustom = NSDictionary.init(dictionary: userinfo)
        guard let type = dicCustom["type"] as? Int else {
            return
        }
        if let eventStr = dicCustom["event"] as? String {
            self.setNotificationEvent(type, eventStr)
            return
        }
        if let eventDic = dicCustom["event"] as? [String: Any] {
            self.setNotificationEvent(type, try? eventDic.json())
        }
    }
    private func dealLocalNotification(_ userinfo: [AnyHashable: Any]) {
        BFLog.debug("dealLocalNotification  userinfo: \(userinfo)")
    }
    private func setNotificationEvent(_ type: Int, _ json: String?) {
        if !ZSettingKit.shared.isLogin { return }
        self.changeIconBadgeNumber()
    }
}
