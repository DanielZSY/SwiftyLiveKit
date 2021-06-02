
import UIKit
import HandyJSON
import GRDB.Swift
import SwiftBasicKit

/// 通话记录
class ZModelCallRecord: ZModelBase {
    
    /// 通话ID
    var callid: Int = 0
    /// 呼叫方向, 0:呼出, 1:呼入
    var direction: Int = 0
    /// 通话时长, 秒
    var duration: Int = 0
    /// 通话总金币
    var token: Int = 0
    /// 通话金币
    var call_token: Int = 0
    /// 礼物金币
    var gift_token: Int = 0
    /// 对方用户信息
    var calluser: ZModelUserInfo?
    
    required init() {
        super.init()
    }
    required init<T: ZModelBase>(instance: T) {
        super.init(instance: instance)
        guard let model = instance as? Self else {
            return
        }
        self.callid = model.callid
        self.direction = model.direction
        self.duration = model.duration
        self.token = model.token
        self.call_token = model.call_token
        self.gift_token = model.gift_token
        if let user = model.calluser {
            self.calluser = ZModelUserInfo.init(instance: user)
        }
    }
    required init(row: Row) {
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        super.encode(to: &container)
    }
    override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        
        mapper <<< self.callid <-- "id"
        mapper <<< self.calluser <-- "user"
    }
}
