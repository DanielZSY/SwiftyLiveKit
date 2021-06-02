
import UIKit
import SwiftDate
import SwiftBasicKit

protocol ZUserEditViewModelDelegate: class {
    func func_changeuserinfosuccess()
    func func_requesstuserinfosuccess()
    func func_photochange()
}
class ZUserEditViewModel: ZBaseViewModel {
    
    var z_changeduser: Bool = false
    var z_username: String = ""
    var z_aboutme: String = ""
    var z_height: String = ""
    var z_weight: String = ""
    var z_bodytype: String = ""
    var z_belong: String = ""
    var z_birthday: String = ""
    var z_photos: [String] = [String]()
    
    weak var delegate: ZUserEditViewModelDelegate?
    
    final func func_uploaduserphoto(image: UIImage) {
        ZProgressHUD.show(vc: self.vc)
        ZNetworkKit.created.startRequest(target: .uploadImages(ZAction.apiupload.api, [image]), responseBlock: { [weak self] res in
            ZProgressHUD.dismiss()
            guard let `self` = self else { return }
            if res.success, let dic = res.body as? [String: Any], let url = dic["url"] as? String {
                self.z_photos.append(url)
                self.z_changeduser = true
                self.delegate?.func_photochange()
            } else {
                ZProgressHUD.showMessage(vc: self.vc, text: res.message)
            }
        })
    }
    final func func_changeuserinfo() {
        var param = [String: Any]()
        param["photos"] = self.z_photos
        param["head"] = self.z_photos.first
        param["mood"] = self.z_aboutme
        param["nickname"] = self.z_username
        param["birthday"] = self.z_birthday
        if let year = self.z_birthday.toDate()?.date.year {
            param["age"] = Date().year - year
        }
        param["attrs"] = ["height": self.z_height, "weight": self.z_weight, "bodytype": self.z_bodytype, "belong": self.z_belong]
        ZProgressHUD.show(vc: self.vc)
        ZNetworkKit.created.startRequest(target: .post(ZAction.apiuser.api, param), responseBlock: { [weak self] result in
            ZProgressHUD.dismiss()
            guard let `self` = self else { return }
            if result.success {
                self.z_changeduser = false
                ZSettingKit.shared.updatePhotos(array: self.z_photos)
                ZProgressHUD.showMessage(vc: nil, text: ZString.alertUserinfoupdatesuccessfully.text)
                self.delegate?.func_changeuserinfosuccess()
            } else {
                ZProgressHUD.showMessage(vc: self.vc, text: result.message)
            }
        })
    }
    final func func_changeuserphotos() {
        var param = [String: Any]()
        param["photos"] = self.z_photos
        param["head"] = self.z_photos.first
        ZProgressHUD.show(vc: self.vc)
        ZNetworkKit.created.startRequest(target: .post(ZAction.apiuser.api, param), responseBlock: { [weak self] result in
            ZProgressHUD.dismiss()
            guard let `self` = self else { return }
            if result.success {
                self.z_changeduser = false
                ZSettingKit.shared.updatePhotos(array: self.z_photos)
                ZProgressHUD.showMessage(vc: nil, text: ZString.alertUserPhotosupdatesuccessfully.text)
                self.delegate?.func_changeuserinfosuccess()
            } else {
                ZProgressHUD.showMessage(vc: self.vc, text: result.message)
            }
        })
    }
    final func func_changephotomoveup(row: Int) {
        if row > 0 && self.z_photos.count > row {
            (self.z_photos[row], self.z_photos[row-1]) = (self.z_photos[row-1], self.z_photos[row])
            self.z_changeduser = true
            self.delegate?.func_photochange()
        }
    }
    final func func_changephotomovedown(row: Int) {
        if row > 0 && self.z_photos.count > row {
            (self.z_photos[row], self.z_photos[row-1]) = (self.z_photos[row-1], self.z_photos[row])
            self.z_changeduser = true
            self.delegate?.func_photochange()
        }
    }
    final func func_changephototohead(row: Int) {
        if self.z_photos.count > row {
            let photo = self.z_photos[row]
            self.z_photos.remove(at: row)
            self.z_photos.insert(photo, at: 0)
            self.z_changeduser = true
            self.delegate?.func_photochange()
        }
    }
    final func func_deleteuserphotos(row: Int) {
        if self.z_photos.count > row {
            self.z_photos.remove(at: row)
            self.z_changeduser = true
            self.delegate?.func_photochange()
        }
    }
    final func func_requestuserphotos(loadlocal: Bool = true) {
        if loadlocal, let photos = ZSettingKit.shared.photos {
            self.z_photos.removeAll()
            self.z_photos.append(contentsOf: photos)
            self.delegate?.func_requesstuserinfosuccess()
        }
        ZNetworkKit.created.startRequest(target: .get(ZAction.apiuserphotos.api, nil), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success, let dic = result.body as? [String: Any], let photos = dic["photos"] as? [String] {
                self.z_photos.removeAll()
                self.z_photos.append(contentsOf: photos)
                ZSettingKit.shared.updatePhotos(array: photos)
                self.delegate?.func_requesstuserinfosuccess()
            }
        })
    }
    final func func_reloaduserinfo() {
        ZNetworkKit.created.startRequest(target: .get(ZAction.apiuser.api, nil), responseBlock: { result in
            if result.success, let user = result.body as? [String: Any] {
                ZSettingKit.shared.updateUser(dic: user)
            }
        })
    }
}
