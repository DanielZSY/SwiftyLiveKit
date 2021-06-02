
import UIKit
import Foundation
import SwiftBasicKit

class ZBaseViewModel {
    
    var page: Int = 1
    weak var vc: ZZBaseViewController?
    
    /// 发起呼叫
    final func func_callanchor(model: ZModelUserInfo?, type: Int = 1, completion:((_ success: Bool) -> Void)? = nil) {
        guard let user = model else { return }
        ZProgressHUD.show(vc: self.vc)
        var param = [String: Any]()
        param["callee_id"] = user.userid
        param["type"] = type
        ZNetworkKit.created.startRequest(target: .post(ZAction.apicall.api, param), responseBlock: { [weak self] result in
            ZProgressHUD.dismiss()
            completion?(result.success)
            guard let `self` = self else { return }
            if !result.success {
                ZProgressHUD.showMessage(vc: self.vc, text: result.message)
            }
        })
    }
    /// 根据key获取本地缓存
    final func func_requestlocaldata<T: ZModelBase>(models: inout [T]?, key: String, dickey: String) {
        if let dic = ZLocalCacheManager.func_getlocaldata(key: key), let array = [T].deserialize(from: dic[dickey] as? [Any]) {
            models = array.compactMap({ (item) -> T? in return item })
        }
    }
}
