
import UIKit
import Foundation
import SwiftBasicKit

protocol ZMatchViewModelDelegate: class {
    func func_reloadusercount(count: Int)
    func func_matchuserend(model: ZModelUserInfo?)
}

class ZMatchViewModel: ZBaseViewModel {
    
    weak var delegate: ZMatchViewModelDelegate?
    
    final func func_reloadusercount() {
        ZNetworkKit.created.startRequest(target: .get(ZAction.apiusercount.api, nil), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success, let dic = result.body as? [String: Any], let count = dic["anchor_online_count"] as? Int {
                self.delegate?.func_reloadusercount(count: (count))
            } else {
                self.delegate?.func_reloadusercount(count: (2000))
            }
        })
    }
    final func func_reloadmatchuser(gender: zUserGender) {
        var param = [String: Any]()
        param["role"] = zUserRole.anchor.rawValue
        param["gender"] = gender.rawValue
        ZNetworkKit.created.startRequest(target: .get(ZAction.apiusermatch.api, param), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success, let dic = result.body as? [String: Any], let model = ZModelUserInfo.deserialize(from: dic) {
                self.delegate?.func_matchuserend(model: model)
            } else {
                self.delegate?.func_matchuserend(model: nil)
            }
        })
    }
}
