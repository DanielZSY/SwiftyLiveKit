
import UIKit
import SwiftBasicKit

class ZUserEditTextField: UIView {
    
    var z_showkey: Bool = false {
        didSet {
            if z_showkey {
                z_textfield.becomeFirstResponder()
            } else {
                z_textfield.resignFirstResponder()
            }
        }
    }
    override var tag: Int {
        didSet {
            switch tag {
            case 1:
                z_lbtitle.text = ZString.lbUserName.text
                z_textfield.placeholder = ZString.lbUserName.text
                z_textfield.maxLength = kMaxUsername
            case 2:
                z_lbtitle.text = ZString.lbBirthday.text
                z_textfield.placeholder = ZString.lbBirthday.text
                z_textfield.inputView = self.z_datepicker
                z_textfield.inputView?.backgroundColor = "#1F1824".color
                z_datepicker.addTarget(self, action: "func_datepickervaluechanged", for: .valueChanged)
            case 4:
                z_lbtitle.text = ZString.lbHeight.text
                z_textfield.placeholder = ZString.lbHeight.text
                z_textfield.maxLength = 3
                z_textfield.keyboardType = .numberPad
            case 5:
                z_lbtitle.text = ZString.lbWeight.text
                z_textfield.placeholder = ZString.lbWeight.text
                z_textfield.maxLength = 6
                z_textfield.keyboardType = .numberPad
            case 6:
                z_lbtitle.text = ZString.lbBodytype.text
                z_textfield.placeholder = ZString.lbBodytype.text
                array.removeAll()
                array.append(contentsOf: ["Slender",
                                          "Average",
                                          "Athletic/Toned",
                                          "Heavyset"])
                z_textfield.inputView = self.z_viewpicker
                z_textfield.inputView?.backgroundColor = "#1F1824".color
                z_viewpicker.delegate = self
                z_viewpicker.dataSource = self
                z_viewpicker.reloadAllComponents()
            case 7:
                z_lbtitle.text = ZString.lbBelong.text
                z_textfield.placeholder = ZString.lbBelong.text
                array.removeAll()
                array.append(contentsOf: ["White/Caucasian",
                                          "Average",
                                          "Latino/Hispanic",
                                          "Other",
                                          "Asian",
                                          "Native American",
                                          "Middle Eastern",
                                          "Pacific IsIander",
                                          "East Indian",
                                          "Latino/Hispanic"])
                z_textfield.inputView = self.z_viewpicker
                z_textfield.inputView?.backgroundColor = "#1F1824".color
                z_viewpicker.delegate = self
                z_viewpicker.dataSource = self
                z_viewpicker.reloadAllComponents()
            default: break
            }
        }
    }
    var z_birthday: String = "" {
        didSet {
            self.z_textfield.text = self.z_birthday
            guard let date = self.z_birthday.toDate()?.date else { return }
            z_datepicker.date = date
        }
    }
    var z_text: String {
        get {
            return self.z_textfield.text ?? ""
        }
        set (value) {
            self.z_textfield.text = value
        }
    }
    var z_bodytype: String {
        get {
            return self.z_textfield.text ?? ""
        }
        set (value) {
            self.z_textfield.text = value
            let row = self.array.firstIndex(of: value) ?? 0
            self.z_viewpicker.selectRow(row, inComponent: 0, animated: false)
        }
    }
    var z_belong: String {
        get {
            return self.z_textfield.text ?? ""
        }
        set (value) {
            self.z_textfield.text = value
            let row = self.array.firstIndex(of: value) ?? 0
            self.z_viewpicker.selectRow(row, inComponent: 0, animated: false)
        }
    }
    var z_onTextBeginEdit: (() -> Void)?
    var z_onTextChangedEdit: ((_ text: String) -> Void)?
    
    private var array: [String] = [String]()
    
    private lazy var z_datepicker: ZDatePicker = {
        let z_temp = ZDatePicker.init(frame: CGRect.init(0, 0, kScreenWidth, 230))
        z_temp.locale = Locale.current
        z_temp.calendar = Calendar.current
        z_temp.timeZone = TimeZone.current
        z_temp.datePickerMode = .date
        z_temp.date = Date().dateByAdding(-kMinAge, .year).date
        z_temp.minimumDate = Date().dateByAdding(-kMaxAge, .year).date
        z_temp.maximumDate = Date().dateByAdding(-kMinAge, .year).date
        return z_temp
    }()
    private lazy var z_viewpicker: ZPickerView = {
        let z_temp = ZPickerView.init(frame: CGRect.init(0, 0, kScreenWidth, 230))
        z_temp.tintColor = "#FFFFFF".color
        z_temp.backgroundColor = "#1F1824".color
        z_temp.setValue("#FFFFFF".color, forKey: "textColor")
        return z_temp
    }()
    private lazy var z_lbtitle: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(15.scale, 5, 300.scale, 25))
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 15
        return z_temp
    }()
    private lazy var z_textfield: ZTextField = {
        let z_temp = ZTextField.init(frame: CGRect.init(17.scale, 30, 342.scale, self.height - 30))
        z_temp.isShowBorder = true
        z_temp.borderNormalColor = "#47474D".color
        z_temp.borderSelectColor = "#7037E9".color
        return z_temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(z_lbtitle)
        self.addSubview(z_textfield)
        
        z_textfield.onTextBeginEdit = {
            self.z_onTextBeginEdit?()
        }
        z_textfield.onTextChanged = { text in
            self.z_onTextChangedEdit?(text)
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    deinit {
        switch self.tag {
        case 6:
            z_viewpicker.delegate = nil
            z_viewpicker.dataSource = nil
        default: break
        }
    }
    @objc private func func_datepickervaluechanged() {
        let text = z_datepicker.date.toFormat("yyyy-MM-dd")
        self.z_textfield.text = text
        self.z_onTextChangedEdit?(text)
    }
}
extension ZUserEditTextField: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.array.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.array[row]
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as? UILabel
        if label == nil {
            label = UILabel.init(frame: CGRect.init(0, 0, pickerView.width, 40))
        }
        label?.boldSize = 18
        label?.text = self.array[row]
        label?.textAlignment = .center
        label?.textColor = "#FFFFFF".color
        label?.backgroundColor = "#1F1824".color
        return label!
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let text = self.array[row]
        self.z_textfield.text = text
        self.z_onTextChangedEdit?(text)
    }
}
