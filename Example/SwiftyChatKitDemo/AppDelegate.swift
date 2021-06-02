import UIKit
import BFKit
import OneSignal
import SwiftBasicKit
import SwiftyChatKit
import SwiftyMessageKit
import AlamofireNetworkActivityIndicator

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .black
        self.window?.makeKeyAndVisible()
        
        BFLog.active = true
        ZSQLiteKit.shared.open()
        ZSettingKit.shared.reloadUser(true)
        ZSwiftStoreKit.completeTransactions()
        ZSwiftStoreKit.configProductIds(key: "com.yule.live.video.ios.", ids: [1,2,3,4,5,6,7])
        ZKey.shared.configService(api: "https://qa.a.live4fun.xyz/", web: "https://qa.a.live4fun.xyz/", wss: "wss://qa.m.live4fun.xyz:9283/")
        ZKey.shared.configAppId(appleId: "1564682022", serviceAppId: "bdd3ba1cb2b540432e341b9b4523b2b9", pushAppId: "826c1b7d-759e-4350-b0ab-5093eff868e8")
        
        self.reloadConfigData()
        ZReload.configMessageKit()
        ZConfig.shared.window = self.window
        ZConfig.shared.configReloadApp(launchOptions)
        return true
    }
    func applicationWillTerminate(_ application: UIApplication) {
        ZConfig.shared.configWillTerminate()
    }
}
extension AppDelegate {
    
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
    internal func reloadConfigData() {
        ZNetworkKit.created.startRequest(target: .post("", ZParams.shared.appParams), responseBlock: { result in
            
        })
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
}
