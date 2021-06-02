
import UIKit
import SwiftDate
import SwiftBasicKit

protocol ZRegisterViewModelDelegate: class {
    func func_bindsuccess()
    func func_checkemailsuccess()
}

class ZRegisterViewModel: ZBaseViewModel {
    
    weak var delegate: ZRegisterViewModelDelegate?
    
    var z_gender: zUserGender = .male
    var z_username: String = ""
    var z_password: String = ""
    var z_email: String = ""
    var z_birthday: String = ""
    var z_year: Int = kMinAge
    
    @objc final func func_registerclick() {
        self.vc?.view.endEditing(true)
        guard z_username.count >= kMinUsername, z_username.count <= kMaxUsername else {
            ZProgressHUD.showMessage(vc: self.vc, text: ZString.errorUsernamePrompt.text)
            return
        }
        guard z_password.isPassword() else {
            ZProgressHUD.showMessage(vc: self.vc, text: ZString.errorPasswordPrompt.text)
            return
        }
        guard z_email.isEmail() else {
            ZProgressHUD.showMessage(vc: self.vc, text: ZString.errorEmailPrompt.text)
            return
        }
        ZProgressHUD.show(vc: self.vc)
        var param = [String: Any]()
        let age = Date().year - z_year
        param["profile"] = ["gender": z_gender.rawValue, "birthday": z_birthday, "nickname": z_username, "age": age]
        param["gender"] = z_gender.rawValue
        param["nickname"] = z_username
        param["password"] = z_password.md5().lowercased()
        param["age"] = age
        param["birthday"] = z_birthday
        param["email"] = z_email
        param["udid"] = ZSettingKit.shared.udid
        param["app_id"] = ZKey.appId.serviceAppId
        param["device"] = ["SystemVersion": kSystemVersion,
                           "SystemName": kSystemName,
                           "AppVersion": kAppVersion,
                           "DeviceName": kDeviceName,
                           "Language": kCurrentLanguage]
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
    }
    @objc final func func_bindclick() {
        ZProgressHUD.show(vc: self.vc)
        var param = [String: Any]()
        let age = Date().year - z_year
        param["profile"] = ["gender": z_gender.rawValue, "birthday": z_birthday, "nickname": z_username, "age": age]
        param["gender"] = z_gender.rawValue
        param["nickname"] = z_username
        param["password"] = z_password.md5().lowercased()
        param["age"] = age
        param["birthday"] = z_birthday
        param["email"] = z_email
        ZNetworkKit.created.startRequest(target: .post(ZAction.apiuser.api, param), responseBlock: { [weak self] res in
            guard let `self` = self else { return }
            if res.success {
                ZNetworkKit.created.startRequest(target: .get(ZAction.apiuser.api, nil), responseBlock: { [weak self] result in
                    ZProgressHUD.dismiss()
                    guard let `self` = self else { return }
                    if result.success, let user = result.body as? [String: Any] {
                        ZSettingKit.shared.updateUser(dic: user)
                        self.delegate?.func_bindsuccess()
                    } else {
                        ZProgressHUD.showMessage(vc: self.vc, text: result.message)
                    }
                })
            } else {
                ZProgressHUD.dismiss()
                ZProgressHUD.showMessage(vc: self.vc, text: res.message)
            }
        })
    }
    @objc final func func_checkemail() {
        ZProgressHUD.show(vc: self.vc)
        var param = [String: Any]()
        param["account"] = z_email
        ZNetworkKit.created.startRequest(target: .get(ZAction.apicheckemail.api, param), responseBlock: { [weak self] res in
            ZProgressHUD.dismiss()
            guard let `self` = self else { return }
            if res.success {
                self.delegate?.func_checkemailsuccess()
            } else {
                ZProgressHUD.showMessage(vc: self.vc, text: res.message)
            }
        })
    }
}
