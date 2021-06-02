
import UIKit
import SwiftBasicKit

protocol ZRankViewModelDelegate: class {
    func func_requestranklocalsuccess(models: [ZModelUserInfo]?, type: kEnumRankType, time: kEnumRankTime)
    func func_requestrankheadersuccess(models: [ZModelUserInfo]?, type: kEnumRankType, time: kEnumRankTime)
    func func_requestrankfootersuccess(models: [ZModelUserInfo]?, type: kEnumRankType, time: kEnumRankTime)
}
fileprivate let dicKey: String = "appranks"
class ZRankViewModel: ZBaseViewModel {

    weak var delegate: ZRankViewModelDelegate?
    var modeluser: ZModelUserInfo? {
        didSet {
            guard let user = self.modeluser else { return }
            dicKey = "appranks" + user.userid
        }
    }
    private var dicKey: String = "appranks"
    private var pageDayCount: Int = 1
    private var pageWeekCount: Int = 1
    private var pageMonthCount: Int = 1
    
    func func_requestranklocal(type: kEnumRankType, time: kEnumRankTime) {
        if let dic = ZLocalCacheManager.func_getlocaldata(key: self.dicKey + type.rawValue.str + time.rawValue.str), let models = [ZModelUserInfo].deserialize(from: dic["rank"] as? [Any]) {
            self.delegate?.func_requestranklocalsuccess(models: models.compactMap({ (model) -> ZModelUserInfo? in return model }), type: type, time: time)
        } else {
            self.delegate?.func_requestranklocalsuccess(models: nil, type: type, time: time)
        }
    }
    func func_requestrankheader(type: kEnumRankType, time: kEnumRankTime) {
        var param = [String: Any]()
        param["type"] = type.rawValue
        param["range"] = time.rawValue
        param["per_page"] = kPageCount
        param["page"] = 1
        if let user = self.modeluser, type == .Lover {
            param["anchor_id"] = user.userid
        }
        ZNetworkKit.created.startRequest(target: .get(ZAction.apirank.api, param), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success, let dic = result.body as? [String: Any], let models = [ZModelUserInfo].deserialize(from: dic["rank"] as? [Any]) {
                switch time {
                case .Day: self.pageDayCount = 1
                case .Week: self.pageWeekCount = 1
                case .Month: self.pageMonthCount = 1
                default: break
                }
                ZLocalCacheManager.func_setlocaldata(dic: dic, key: self.dicKey + type.rawValue.str + time.rawValue.str)
                self.delegate?.func_requestrankheadersuccess(models: models.compactMap({ (model) -> ZModelUserInfo? in return model }), type: type, time: time)
            }
        })
    }
    func func_requestrankfooter(type: kEnumRankType, time: kEnumRankTime) {
        var param = [String: Any]()
        param["type"] = type.rawValue
        param["range"] = time.rawValue
        param["per_page"] = kPageCount
        switch time {
        case .Day: param["page"] = self.pageDayCount + 1
        case .Week: param["page"] = self.pageWeekCount + 1
        case .Month: param["page"] = self.pageMonthCount + 1
        default: break
        }
        if let user = self.modeluser, type == .Lover {
            param["anchor_id"] = user.userid
        }
        ZNetworkKit.created.startRequest(target: .get(ZAction.apirank.api, param), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success, let dic = result.body as? [String: Any], let models = [ZModelUserInfo].deserialize(from: dic["rank"] as? [Any]) {
                switch time {
                case .Day: self.pageDayCount += 1
                case .Week: self.pageWeekCount += 1
                case .Month: self.pageMonthCount += 1
                default: break
                }
                self.delegate?.func_requestrankfootersuccess(models: models.compactMap({ (model) -> ZModelUserInfo? in return model }), type: type, time: time)
            }
        })
    }
}
