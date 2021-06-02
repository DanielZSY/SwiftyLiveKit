
import UIKit
import HandyJSON

/// 排行榜周期
enum kEnumRankTime: Int, HandyJSONEnum {
    case Day = 1
    case Week = 2
    case Month = 3
}
/// 排行榜类型
enum kEnumRankType: Int, HandyJSONEnum {
    case Anchor = 1
    case Gold = 2
    case Gift = 3
    case Lover = 4
}
