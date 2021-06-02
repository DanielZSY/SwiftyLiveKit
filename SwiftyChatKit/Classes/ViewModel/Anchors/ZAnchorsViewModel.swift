
import UIKit
import Foundation
import SwiftBasicKit

protocol ZAnchorsViewModelDelegate: class {
    func func_requesthotsuccessheader(models: [ZModelUserInfo]?)
    func func_requestnewsuccessheader(models: [ZModelUserInfo]?)
    func func_requesthotsuccessfooder(models: [ZModelUserInfo]?)
    func func_requestnewsuccessfooder(models: [ZModelUserInfo]?)
}

class ZAnchorsViewModel: ZBaseViewModel {
    
    weak var delegate: ZAnchorsViewModelDelegate?
    
    private let dickey = "anchors"
    private let hotlocalkey = "hotanchors"
    private let newlocalkey = "newanchors"
    
    private var hotpage: Int = 1
    private var newpage: Int = 1
    
    final func func_requesthotanchorslocal() {
        if let dic = ZLocalCacheManager.func_getlocaldata(key: hotlocalkey), let models = [ZModelUserInfo].deserialize(from: dic[self.dickey] as? [Any]) {
            self.delegate?.func_requesthotsuccessheader(models: models.compactMap({ (model) -> ZModelUserInfo? in return model }))
        }
    }
    final func func_requestnewanchorslocal() {
        if let dic = ZLocalCacheManager.func_getlocaldata(key: newlocalkey), let models = [ZModelUserInfo].deserialize(from: dic[self.dickey] as? [Any]) {
            self.delegate?.func_requestnewsuccessheader(models: models.compactMap({ (model) -> ZModelUserInfo? in return model }))
        }
    }
    final func func_requesthotanchorsheader() {
        var param = [String: Any]()
        param["filter"] = ["quick": "hot"]
        param["per_page"] = kPageCount
        param["page"] = 1
        ZNetworkKit.created.startRequest(target: .get(ZAction.apianchorlist.api, param), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success, let dic = result.body as? [String: Any], let models = [ZModelUserInfo].deserialize(from: dic[self.dickey] as? [Any]) {
                self.hotpage = 1
                ZLocalCacheManager.func_setlocaldata(dic: dic, key: self.hotlocalkey)
                self.delegate?.func_requesthotsuccessheader(models: models.compactMap({ (model) -> ZModelUserInfo? in return model }))
            } else {
                ZLocalCacheManager.func_setlocaldata(dic: [:], key: self.hotlocalkey)
                self.delegate?.func_requesthotsuccessheader(models: nil)
            }
        })
    }
    final func func_requesthotanchorsfooter() {
        var param = [String: Any]()
        param["filter"] = ["quick": "hot"]
        param["per_page"] = kPageCount
        param["page"] = hotpage + 1
        ZNetworkKit.created.startRequest(target: .get(ZAction.apianchorlist.api, param), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success, let dic = result.body as? [String: Any], let models = [ZModelUserInfo].deserialize(from: dic[self.dickey] as? [Any]) {
                self.hotpage += 1
                self.delegate?.func_requesthotsuccessfooder(models: models.compactMap({ (model) -> ZModelUserInfo? in return model }))
            } else {
                self.delegate?.func_requesthotsuccessfooder(models: nil)
            }
        })
    }
    final func func_requestnewanchorsheader() {
        var param = [String: Any]()
        param["filter"] = ["quick": "new"]
        param["per_page"] = kPageCount
        param["page"] = 1
        ZNetworkKit.created.startRequest(target: .get(ZAction.apianchorlist.api, param), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success, let dic = result.body as? [String: Any], let models = [ZModelUserInfo].deserialize(from: dic[self.dickey] as? [Any]) {
                self.newpage = 1
                ZLocalCacheManager.func_setlocaldata(dic: dic, key: self.newlocalkey)
                self.delegate?.func_requestnewsuccessheader(models: models.compactMap({ (model) -> ZModelUserInfo? in return model }))
            } else {
                ZLocalCacheManager.func_setlocaldata(dic: [:], key: self.newlocalkey)
                self.delegate?.func_requestnewsuccessheader(models: nil)
            }
        })
    }
    final func func_requestnewanchorsfooter() {
        var param = [String: Any]()
        param["filter"] = ["quick": "new"]
        param["per_page"] = kPageCount
        param["page"] = newpage + 1
        ZNetworkKit.created.startRequest(target: .get(ZAction.apianchorlist.api, param), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success, let dic = result.body as? [String: Any], let models = [ZModelUserInfo].deserialize(from: dic[self.dickey] as? [Any]) {
                self.newpage += 1
                self.delegate?.func_requestnewsuccessfooder(models: models.compactMap({ (model) -> ZModelUserInfo? in return model }))
            } else {
                self.delegate?.func_requestnewsuccessfooder(models: nil)
            }
        })
    }
}
