
import UIKit
import SwiftBasicKit

final class ZLoginViewModel: ZBaseViewModel {
    
    var z_email: String = ""
    var z_password: String = ""
    
    @objc final func func_signinclick() {
        self.vc?.view.endEditing(true)
        guard self.z_email.isEmail() else {
            ZProgressHUD.showMessage(vc: self.vc, text: ZString.errorEmailPrompt.text)
            return
        }
        guard self.z_password.isPassword() else {
            ZProgressHUD.showMessage(vc: self.vc, text: ZString.errorPasswordPrompt.text)
            return
        }
        var param = [String: Any]()
        param["password"] = z_password.md5().lowercased()
        param["email"] = z_email
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
                        ZSettingKit.shared.updateToken(token: "")
                        ZProgressHUD.showMessage(vc: self.vc, text: result.message)
                    }
                })
            } else {
                ZProgressHUD.dismiss()
                ZProgressHUD.showMessage(vc: self.vc, text: res.message)
            }
        })
    }
}
