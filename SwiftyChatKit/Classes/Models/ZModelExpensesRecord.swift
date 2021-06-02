
import UIKit
import HandyJSON
import GRDB.Swift
import SwiftBasicKit

/// 消费记录
class ZModelExpensesRecord: ZModelBase {
    
    /// 收入(+)或支出(-)代币数
    var amount: Int = 0
    /// 0: 其他 1:充值 2:通话 3:消息 9:提现 4: 活动 5:任务
    var biz_code: Int = 0
    /// 业务名称
    var biz_name: String = ""
    /// 发生时间
    var occurred_on: Double = 0
    /// 呼叫方向, 0:呼出, 1:呼入
    var biz_direction: Int = 0
    /// 通话时长,分钟
    var biz_duration: Int = 0
    /// 通话总金币
    var biz_token: Int = 0
    /// 通话金币
    var biz_call_token: Int = 0
    /// 礼物金币
    var biz_gift_token: Int = 0
    /// 评级: 1,2,3,4,5, 无此字段代表未评
    var biz_comment_rating: Int = 0
    /// 评价金币, 0或无此字段代表没有奖惩, 大于0代表奖励金币数，小于0代表惩罚金币数
    var biz_comment_token: Int = 0
    
    required init() {
        super.init()
    }
    required init<T: ZModelBase>(instance: T) {
        super.init(instance: instance)
        guard let model = instance as? Self else {
            return
        }
        self.amount = model.amount
        self.biz_code = model.biz_code
        self.biz_name = model.biz_name
        self.occurred_on = model.occurred_on
        self.biz_direction = model.biz_direction
        self.biz_duration = model.biz_duration
        self.biz_token = model.biz_token
        self.biz_call_token = model.biz_call_token
        self.biz_gift_token = model.biz_gift_token
        self.biz_comment_rating = model.biz_comment_rating
        self.biz_comment_token = model.biz_comment_token
    }
    required init(row: Row) {
        super.init(row: row)
        
    }
    override func encode(to container: inout PersistenceContainer) {
        super.encode(to: &container)
        
    }
    override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        
        mapper <<< self.amount <-- "amount"
        mapper <<< self.biz_code <-- "biz_code"
        mapper <<< self.biz_name <-- "biz_name"
        mapper <<< self.occurred_on <-- "occurred_on"
        mapper <<< self.biz_direction <-- "biz.direction"
        mapper <<< self.biz_duration <-- "biz.duration"
        mapper <<< self.biz_token <-- "biz.token"
        mapper <<< self.biz_call_token <-- "biz.call_token"
        mapper <<< self.biz_gift_token <-- "biz.gift_token"
        mapper <<< self.biz_comment_rating <-- "biz.comment.rating"
        mapper <<< self.biz_comment_token <-- "biz.comment.token"
    }
}
