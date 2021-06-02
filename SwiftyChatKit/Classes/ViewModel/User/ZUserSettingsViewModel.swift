
import UIKit
import SwiftBasicKit

class ZUserSettingsViewModel: ZBaseViewModel {
    
    final func func_requestdeleteaccount() {
        ZProgressHUD.show(vc: self.vc)
        ZNetworkKit.created.startRequest(target: .post(ZAction.apiuserdestroy.api, nil), responseBlock: { [weak self] result in
            ZProgressHUD.dismiss()
            guard let `self` = self else { return }
            if result.success {
                ZSettingKit.shared.logout()
                ZConfig.shared.configRoot()
            } else {
                ZProgressHUD.showMessage(vc: self.vc, text: result.message)
            }
        })
    }
    final func func_requestlogout() {
        ZProgressHUD.show(vc: self.vc)
        ZNetworkKit.created.startRequest(target: .post(ZAction.apilogout.api, nil), responseBlock: { [weak self] result in
            ZProgressHUD.dismiss()
            guard let `self` = self else { return }
            if result.success {
                ZSettingKit.shared.setUserConfig(key: "kMatchFilterKey", value: "1")
                ZSettingKit.shared.logout()
                ZConfig.shared.configRoot()
            } else {
                ZProgressHUD.showMessage(vc: self.vc, text: result.message)
            }
        })
    }
    final func func_changeshowlocation(on: Bool) {
        var param = [String: Any]()
        param["settings"] = ["show_location": on]
        ZNetworkKit.created.startRequest(target: .post(ZAction.apiuser.api, nil), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success {
                if var user = ZSettingKit.shared.user?.rawData {
                    user["show_location"] = on
                    ZSettingKit.shared.updateUser(dic: user)
                }
            }
        })
    }
}
