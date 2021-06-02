
import UIKit
import SwiftDate
import SwiftBasicKit

class ZRegisterBirthdayView: UIView {
    
    var z_year: Int {
        return self.z_year_s
    }
    var z_date: String {
        let month = z_month_s < 10 ? "0\(z_month_s)" : "\(z_month_s)"
        let day = z_day_s < 10 ? "0\(z_day_s)" : "\(z_day_s)"
        return "\(z_year_s)-\(month)-\(day)"
    }
    var z_birthday: String = "" {
        didSet {
            guard let date = z_birthday.toDate()?.date else { return }
            z_month_s = date.month
            z_day_s = date.day
            z_year_s = date.year
            
            z_datepicker.selectRow(z_month_s, inComponent: 0, animated: false)
            z_datepicker.selectRow(z_day_s, inComponent: 1, animated: false)
            if let yearrow = self.z_arrayYear.index(of: z_year_s) {
                z_datepicker.selectRow(yearrow, inComponent: 2, animated: false)
            }
        }
    }
    private var z_year_s: Int = Date().year - kMinAge
    private var z_month_s: Int = 6
    private var z_day_s: Int = 15
    private var z_arrayYear: [Int] = [Int]()
    private var z_arrayMonth: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ,11, 12]
    private var z_arrayMonthStr: [String] = ["Jan","Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    private var z_arrayMonthAllStr: [String] = ["January","February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    private var z_arrayDay: [Int] = [Int]()
    private lazy var z_lbtitle: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(28.scale, 0, 320.scale, 80))
        z_temp.textColor = "#7C3EF0".color
        z_temp.boldSize = 30
        z_temp.numberOfLines = 0
        z_temp.lineBreakMode = .byWordWrapping
        let text = ZString.lbYourBirthday.text
        z_temp.text = text
        let atttext = NSMutableAttributedString.init(string: text)
        atttext.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 23)], range: NSRange.init(location: 0, length: 4))
        z_temp.attributedText = atttext
        return z_temp
    }()
    private lazy var z_datepicker: UIPickerView = {
        let z_temp = UIPickerView.init(frame: CGRect.init(0, z_lbtitle.height, self.width, 220))
        z_temp.tintColor = "#FFFFFF".color
        z_temp.backgroundColor = "#100D13".color
        z_temp.setValue("#FFFFFF".color, forKey: "textColor")
        return z_temp
    }()
    /// 计算每个月的天数
    ///
    /// - Parameters:
    ///   - year: 年份
    ///   - month: 月份
    private func daysForm(year: Int, month: Int) {
        self.z_arrayDay.removeAll()
        let isLeapYear = year % 4 == 0 ? (year % 100 == 0 ? (year % 400 == 0 ? true : false) : true) : false
        switch month {
        case 1,3,5,7,8,10,12:
            for i in 1...31 {
                self.z_arrayDay.append(i)
            }
        case 4,6,9,11:
            for i in 1...30 {
                self.z_arrayDay.append(i)
            }
        case 2:
            if isLeapYear {
                for i in 1...29 {
                    self.z_arrayDay.append(i)
                }
            } else {
                for i in 1...28 {
                    self.z_arrayDay.append(i)
                }
            }
        default: break
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.z_arrayYear.removeAll()
        let maxyear = Date().year - kMinAge
        let minyear = Date().year - kMaxAge
        for year in minyear...maxyear {
            self.z_arrayYear.append(year)
        }
        self.daysForm(year: self.z_year_s, month: self.z_month_s)
        
        self.addSubview(z_lbtitle)
        self.addSubview(z_datepicker)
        
        z_datepicker.delegate = self
        z_datepicker.dataSource = self
        z_datepicker.reloadAllComponents()
        z_datepicker.selectRow(6, inComponent: 0, animated: false)
        z_datepicker.selectRow(self.z_arrayYear.count - 1, inComponent: 2, animated: false)
        z_datepicker.selectRow(15, inComponent: 1, animated: false)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    deinit {
        z_datepicker.delegate = nil
        z_datepicker.dataSource = nil
    }
}
extension ZRegisterBirthdayView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 1: return self.z_arrayMonthAllStr.count
        case 2: return self.z_arrayDay.count
        default: break
        }
        return self.z_arrayYear.count
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var val: String = ""
        switch component {
        case 0:
            val = self.z_arrayYear[row].str
        case 1:
            val = self.z_arrayMonthAllStr[row]
        case 2:
            val = self.z_arrayDay[row].str
        default: break
        }
        let text = val.count == 1 ? "0\(val)" : val
        let att = NSMutableAttributedString.init(string: text)
        att.addAttributes([NSAttributedString.Key.foregroundColor: "#FFFFFF".color, NSAttributedString.Key.font: UIFont.boldSystemFont(24)], range: NSRange.init(location: 0, length: text.count))
        return att
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            self.z_year_s = self.z_arrayYear[row]
            self.daysForm(year: self.z_year, month: self.z_month_s)
            self.z_datepicker.reloadComponent(2)
        case 1:
            self.z_month_s = self.z_arrayMonth[row]
            self.daysForm(year: self.z_year, month: self.z_month_s)
            self.z_datepicker.reloadComponent(2)
        case 2:
            self.z_day_s = self.z_arrayDay[row]
        default: break
        }
    }
}
