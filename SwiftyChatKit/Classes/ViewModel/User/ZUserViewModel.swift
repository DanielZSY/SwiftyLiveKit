
import UIKit
import SwiftBasicKit

protocol ZUserViewModelDelegate: class {
    func func_requestuserdetailfaild()
    func func_requestuserdetailsuccess()
    func func_requestuserchange()
}
class ZUserViewModel: ZBaseViewModel {
    
    weak var delegate: ZUserViewModelDelegate?
    
    final func func_requestuserdetail() {
        ZNetworkKit.created.startRequest(target: .get(ZAction.apiuser.api, nil), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success, let dic = result.body as? [String: Any] {
                ZSettingKit.shared.updateUser(dic: dic)
                self.delegate?.func_requestuserdetailsuccess()
            } else {
                self.delegate?.func_requestuserdetailfaild()
            }
        })
    }
    final func func_uploaduserphoto(image: UIImage) {
        ZProgressHUD.show(vc: self.vc)
        ZNetworkKit.created.startRequest(target: .uploadImages(ZAction.apiupload.api, [image]), responseBlock: { [weak self] res in
            guard let `self` = self else { return }
            if res.success, let dic = res.body as? [String: Any], let url = dic["url"] as? String {
                var param = [String: Any]()
                param["head"] = url
                var photos = ZSettingKit.shared.user?.photos ?? [String]()
                photos.insert(url, at: 0)
                if let oldurl = ZSettingKit.shared.user?.avatar, oldurl.count > 0 {
                    photos.remove(oldurl)
                }
                param["photos"] = photos
                ZNetworkKit.created.startRequest(target: .post(ZAction.apiuser.api, param), responseBlock: { [weak self] result in
                    ZProgressHUD.dismiss()
                    guard let `self` = self else { return }
                    if result.success {
                        if var user = ZSettingKit.shared.user?.rawData {
                            user["photos"] = photos
                            var profile = user["profile"] as? [String: Any]
                            profile?["head"] = url
                            user["profile"] = profile
                            ZSettingKit.shared.updateUser(dic: user)
                        }
                        self.delegate?.func_requestuserchange()
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
    final func func_changeuserinmode(on: Bool) {
        var param = [String: Any]()
        param["settings"] = ["incognito_mode": on]
        ZNetworkKit.created.startRequest(target: .post(ZAction.apiuser.api, param), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success {
                if var user = ZSettingKit.shared.user?.rawData {
                    user["incognito_mode"] = on
                    ZSettingKit.shared.updateUser(dic: user)
                }
            }
        })
    }
}
