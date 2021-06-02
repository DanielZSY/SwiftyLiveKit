
import UIKit

struct ZModelCountry {
    var name_en: String = ""
    var name_zh: String = ""
    var name_locale: String = ""
    var name_code: Int = 1
}

class ZCountryManager: NSObject {
    
    var models = [ZModelCountry]()
    
    static let shared = ZCountryManager()
    
    func func_getCountry(code: String) -> ZModelCountry? {
        
        if self.models.count > 0 {
            let array = self.models.filter { (model) -> Bool in
                return model.name_locale.uppercased() == code.uppercased()
            }
            return array.first
        }
        let bundle = Bundle.resourcesAssetBundle
        let path = bundle.bundlePath.appendingPathComponent("country.txt")
        guard let data = try? Data.init(contentsOf: URL.init(fileURLWithPath: path)) else {
            return nil
        }
        guard let array = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [Any] else {
            return nil
        }
        let models = array.compactMap { (item) -> ZModelCountry? in
            guard let dic = item as? [String: Any],
                  let name_en = dic["en"] as? String,
                  let name_zh = dic["zh"] as? String,
                  let name_locale = dic["locale"] as? String,
                  let name_code = dic["code"] as? Int,
                  name_locale.uppercased() == code.uppercased()
            else { return nil }
            let model = ZModelCountry.init(name_en: name_en, name_zh: name_zh, name_locale: name_locale, name_code: name_code)
            self.models.append(model)
            return model
        }
        return self.models.filter { (model) -> Bool in
            return model.name_locale.uppercased() == code.uppercased()
        }.first
    }
}
