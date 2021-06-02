
import UIKit
import SwiftBasicKit

class ZStartViewModel: ZBaseViewModel {
    
    var z_guest: Bool = false
    var z_gender: zUserGender = .male
    
    final func func_request_loginpre(_ block: ((_ guest: Bool) -> Void)?) {
        var param = [String: Any]()
        param["app_id"] = ZKey.appId.serviceAppId
        param["udid"] = ZSettingKit.shared.udid
        ZNetworkKit.created.startRequest(target: .post(ZAction.apiloginpre.api, param), responseBlock: { result in
            if result.success, let dic = result.body as? [String: Any], let method = dic["method"] as? [String: Any], let guest = method["guest"] as? Bool {
                block?(guest)
            } else {
                block?(false)
            }
        })
    }
    @objc final func func_loginclick() {
        if self.z_guest {
            var param = [String: Any]()
            param["gender"] = self.z_gender.rawValue
            param["udid"] = ZSettingKit.shared.udid
            param["app_id"] = ZKey.appId.serviceAppId
            param["device"] = ["SystemVersion": kSystemVersion,
                               "SystemName": kSystemName,
                               "AppVersion": kAppVersion,
                               "DeviceName": kDeviceName,
                               "Language": kCurrentLanguage]
            ZProgressHUD.show(vc: self.vc)
            ZNetworkKit.created.startRequest(target: .post(ZAction.apilogin.api, param), responseBlock: { [weak self] res in
                guard let `self` = self else { return }
                if res.success, let dic = res.body as? [String: Any], let api_token = dic["api_token"] as? String {
                    ZSettingKit.shared.updateToken(token: api_token)
                    ZNetworkKit.created.startRequest(target: .get(ZAction.apiuser.api, nil), responseBlock: { [weak self] result in
                        ZProgressHUD.dismiss()
                        guard let `self` = self else { return }
                        if result.success, let user = result.body as? [String: Any] {
                            ZSettingKit.shared.updateUser(dic: user)
                            ZConfig.shared.configRoot()
                        } else {
                            ZProgressHUD.showMessage(vc: self.vc, text: result.message)
                        }
                    })
                } else {
                    ZProgressHUD.dismiss()
                    ZProgressHUD.showMessage(vc: self.vc, text: res.message)
                }
            })
        } else {
            let z_tempvc = ZRegisterViewController.init()
            ZRouterKit.push(toVC: z_tempvc, fromVC: self.vc, animated: true)
        }
    }
    @objc final func func_signinclick() {
        let z_tempvc = ZLoginViewController.init()
        ZRouterKit.push(toVC: z_tempvc, fromVC: self.vc, animated: true)
    }
}
