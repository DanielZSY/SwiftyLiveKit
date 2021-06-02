
import UIKit
import Foundation
import SwiftBasicKit
import SwiftyStoreKit

protocol ZRechargeViewModelDeletegate: class {
    func func_requestsupportsuccess(model: ZModelUserInfo?)
    func func_requestppasuccess(dic: [String: Any])
    func func_reloadarrayfaild()
    func func_reloadarraysuccess(models: [ZModelPurchase]?)
}
class ZRechargeViewModel: ZBaseViewModel {
    
    let dickey = "tokens"
    let localkey = "apptokens"
    var title: String?
    weak var delegate: ZRechargeViewModelDeletegate?
    
    /// 本地内购
    final func func_reloadrechargelocal() {
        if let dic = ZLocalCacheManager.func_getlocaldata(key: localkey), let array = dic[dickey] as? [Any], let models = [ZModelPurchase].deserialize(from: array) {
            let array = models.compactMap({ (model) -> ZModelPurchase? in
                return model
            })
            self.delegate?.func_reloadarraysuccess(models: array)
        } else {
            self.delegate?.func_reloadarrayfaild()
        }
    }
    /// 获取内购列表
    final func func_reloadrechargearray() {
        ZNetworkKit.created.startRequest(target: .get(ZAction.apitokenlist.api, nil), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success, let dic = result.body as? [String: Any], let array = dic[self.dickey] as? [Any], let models = [ZModelPurchase].deserialize(from: array) {
                ZLocalCacheManager.func_setlocaldata(dic: dic, key: self.localkey)
                self.delegate?.func_reloadarraysuccess(models: models.compactMap({ (model) -> ZModelPurchase? in return model }))
            } else {
                ZProgressHUD.showMessage(vc: self.vc, text: result.message)
            }
        })
    }
    /// 发起ppa支付
    final func func_requestpparecharge(model: ZModelRecharge) {
        var param = [String: Any]()
        param["code"] = model.code
        ZProgressHUD.show(vc: self.vc)
        ZNetworkKit.created.startRequest(target: .post(ZAction.apiusertoken.api, param), responseBlock: { [weak self] result in
            ZProgressHUD.dismiss()
            guard let `self` = self else { return }
            if result.success, let dic = result.body as? [String: Any] {
                self.delegate?.func_requestppasuccess(dic: dic)
            } else {
                ZProgressHUD.showMessage(vc: self.vc, text: result.message)
            }
        })
    }
    /// 发起内购支付
    final func func_requestapplerecharge(model: ZModelRecharge) {
        ZProgressHUD.show(vc: self.vc)
        ZSwiftStoreKit.purchaseProduct(productId: model.code, diamond: 0, completion: { [weak self] error in
            ZProgressHUD.dismiss()
            guard let `self` = self else { return }
            guard let err = error else {
                self.func_requestservicerecharge(model: model)
                return
            }
            ZProgressHUD.showMessage(vc: self.vc, text: err.localizedDescription)
        })
    }
    /// 上报购买成功的内购项
    private final func func_requestservicerecharge(model: ZModelRecharge) {
        guard let receiptData = SwiftyStoreKit.localReceiptData else { return }
        let receiptString = receiptData.base64EncodedString(options: [])
        var param = [String: Any]()
        param["code"] = model.code
        param["receipt"] = receiptString
        ZProgressHUD.show(vc: self.vc)
        ZNetworkKit.created.startRequest(target: .post(ZAction.apiusertoken.api, param), responseBlock: { [weak self] result in
            ZProgressHUD.dismiss()
            guard let `self` = self else { return }
            if result.success {
                ZProgressHUD.showMessage(vc: nil, text: ZString.successRecharge.text)
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "PayRechargeSuccess"), object: nil)
            } else {
                ZProgressHUD.show(vc: self.vc)
                ZNetworkKit.created.startRequest(target: .post(ZAction.apiusertoken.api, param), responseBlock: { [weak self] result in
                    ZProgressHUD.dismiss()
                    guard let `self` = self else { return }
                    if result.success {
                        ZProgressHUD.showMessage(vc: nil, text: ZString.successRecharge.text)
                        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "PayRechargeSuccess"), object: nil)
                    } else {
                        var dicreceipt = ZLocalCacheManager.func_getlocaldata(key: "receiptdata") ?? [String: Any]()
                        dicreceipt[receiptString.md5()] = ["pid": model.code, "uid": ZSettingKit.shared.userId, "receipt": ZCryptoContentManager.encrypt(receiptString)]
                        ZLocalCacheManager.func_setlocaldata(dic: dicreceipt, key: "receiptdata")
                        ZProgressHUD.showMessage(vc: self.vc, text: result.message)
                    }
                })
            }
        })
    }
    /// 检测本地是否存在未提交成功的内购项
    final func func_checkrechargefaild() {
        if let dic = ZLocalCacheManager.func_getlocaldata(key: "receiptdata"),
           let key = dic.keys.first,
           let dicreceipt = dic[key] as? [String: Any],
           let pid = dicreceipt["pid"] as? String,
           let uid = dicreceipt["uid"] as? String,
           let receipt = dicreceipt["receipt"] as? String,
           pid.count > 0,
           uid.count > 0,
           receipt.count > 0,
           uid == ZSettingKit.shared.userId {
            var param = [String: Any]()
            param["code"] = pid
            param["receipt"] = ZCryptoContentManager.decrypt(receipt)
            ZNetworkKit.created.startRequest(target: .post(ZAction.apiusertoken.api, param), responseBlock: { [weak self] result in
                guard let `self` = self else { return }
                if result.success {
                    
                } else {
                    
                }
            })
        }
    }
    /// 获取客服对象
    final func func_requestsupport() {
        ZNetworkKit.created.startRequest(target: .get(ZAction.apisupport.api, nil), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success, let dic = result.body as? [String: Any], let model = ZModelUserInfo.deserialize(from: dic) {
                model.role = .customerService
                self.delegate?.func_requestsupportsuccess(model: model)
            }
        })
    }
}
