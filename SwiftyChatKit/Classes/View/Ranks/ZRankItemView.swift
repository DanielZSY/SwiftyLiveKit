
import UIKit
import SwiftBasicKit

class ZRankItemView: UIView {

    var z_onbuttonphotoclick: ((_ model: ZModelUserInfo?) -> Void)?
    var z_type: kEnumRankType = .Anchor {
        didSet {
            switch self.z_type {
            case .Gold:
                z_imagebg.image = Asset.rankGoldHead.image
            case .Lover:
                z_imagebg.image = Asset.rankLoverHead.image
            default: break
            }
        }
    }
    var scrollsToTop: Bool = false {
        didSet {
            self.isHidden = !self.scrollsToTop
            if self.scrollsToTop {
                switch self.z_currentpage {
                case 0:
                    self.z_viewday.scrollsToTop = true
                    self.z_viewweek.scrollsToTop = false
                    self.z_viewmonth.scrollsToTop = false
                case 1:
                    self.z_viewday.scrollsToTop = false
                    self.z_viewweek.scrollsToTop = true
                    self.z_viewmonth.scrollsToTop = false
                case 2:
                    self.z_viewday.scrollsToTop = false
                    self.z_viewweek.scrollsToTop = false
                    self.z_viewmonth.scrollsToTop = true
                default: break
                }
            } else {
                self.z_viewday.scrollsToTop = false
                self.z_viewweek.scrollsToTop = false
                self.z_viewmonth.scrollsToTop = false
            }
        }
    }
    private var z_currentpage: Int = 1
    private let topcount: Int = 3
    private var arrayDayTop: [ZModelUserInfo]?
    private var arrayWeekTop: [ZModelUserInfo]?
    private var arrayMonthTop: [ZModelUserInfo]?
    private var arrayDay: [ZModelUserInfo] = [ZModelUserInfo]()
    private var arrayWeek: [ZModelUserInfo] = [ZModelUserInfo]()
    private var arrayMonth: [ZModelUserInfo] = [ZModelUserInfo]()
    private lazy var z_imagebg: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(0, 0, self.width, kIsIPhoneX ? (kStatusHeight + 320) : 320))
        return z_temp
    }()
    private lazy var z_viewtime: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(60.scale, kTopNavHeight + 15, 255.scale, 26))
        z_temp.backgroundColor = "#2D2538".color
        z_temp.border(color: .clear, radius: z_temp.height/2, width: 0)
        return z_temp
    }()
    private let btnitemw = 255.scale/3
    private lazy var z_btnday: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(0, 0, btnitemw, z_viewtime.height))
        z_temp.tag = kEnumRankTime.Day.rawValue
        z_temp.isSelected = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setTitle(ZString.lbDay.text, for: .normal)
        z_temp.setTitle(ZString.lbDay.text, for: .selected)
        z_temp.setTitleColor("#493443".color, for: .normal)
        z_temp.setTitleColor("#FFFFFF".color, for: .selected)
        z_temp.setBackgroundImage(UIImage.init(color: "#2D2538".color), for: .normal)
        z_temp.setBackgroundImage(UIImage.init(color: "#7037E9".color), for: .selected)
        z_temp.border(color: .clear, radius: z_temp.height/2, width: 0)
        return z_temp
    }()
    private lazy var z_btnweek: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(btnitemw, 0, btnitemw, z_viewtime.height))
        z_temp.tag = kEnumRankTime.Week.rawValue
        z_temp.isSelected = true
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setTitle(ZString.lbWeek.text, for: .normal)
        z_temp.setTitle(ZString.lbWeek.text, for: .selected)
        z_temp.setTitleColor("#493443".color, for: .normal)
        z_temp.setTitleColor("#FFFFFF".color, for: .selected)
        z_temp.setBackgroundImage(UIImage.init(color: "#2D2538".color), for: .normal)
        z_temp.setBackgroundImage(UIImage.init(color: "#7037E9".color), for: .selected)
        z_temp.border(color: .clear, radius: z_temp.height/2, width: 0)
        return z_temp
    }()
    private lazy var z_btnmonth: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(btnitemw*2, 0, btnitemw, z_viewtime.height))
        z_temp.tag = kEnumRankTime.Month.rawValue
        z_temp.isSelected = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setTitle(ZString.lbMonth.text, for: .normal)
        z_temp.setTitle(ZString.lbMonth.text, for: .selected)
        z_temp.setTitleColor("#493443".color, for: .normal)
        z_temp.setTitleColor("#FFFFFF".color, for: .selected)
        z_temp.setBackgroundImage(UIImage.init(color: "#2D2538".color), for: .normal)
        z_temp.setBackgroundImage(UIImage.init(color: "#7037E9".color), for: .selected)
        z_temp.border(color: .clear, radius: z_temp.height/2, width: 0)
        return z_temp
    }()
    private lazy var z_viewmain: ZBaseSV = {
        let z_tempy = z_viewtime.y + z_viewtime.height + 10.scale
        let z_temp = ZBaseSV.init(frame: CGRect.init(0, z_tempy, self.width, self.height - z_tempy))
        z_temp.tag = 10
        z_temp.bounces = false
        z_temp.scrollsToTop = false
        z_temp.isPagingEnabled = true
        z_temp.backgroundColor = .clear
        z_temp.showsVerticalScrollIndicator = false
        z_temp.showsHorizontalScrollIndicator = false
        z_temp.contentSize = CGSize.init(width: z_temp.width*3, height: z_temp.height)
        z_temp.contentOffset = CGPoint.init(x: z_temp.width, y: 0)
        return z_temp
    }()
    private lazy var z_viewday: ZBaseCV = {
        let z_templayout = UICollectionViewFlowLayout.init()
        z_templayout.itemSize = CGSize.init(width: z_viewmain.width, height: 95.scale)
        z_templayout.minimumLineSpacing = 0
        z_templayout.minimumInteritemSpacing = 0
        z_templayout.scrollDirection = .vertical
        z_templayout.sectionHeadersPinToVisibleBounds = false
        z_templayout.sectionFootersPinToVisibleBounds = false
        
        let z_temp = ZBaseCV.init(frame: CGRect.init(0, 0, z_viewmain.width, z_viewmain.height), collectionViewLayout: z_templayout)
        z_temp.tag = kEnumRankTime.Day.rawValue
        z_temp.scrollsToTop = true
        z_temp.alwaysBounceVertical = true
        z_temp.backgroundColor = .clear
        z_temp.addNoDataView()
        z_temp.register(ZRankItemCVC.classForCoder(), forCellWithReuseIdentifier: kCellId)
        z_temp.register(ZRankLoveItemCVC.classForCoder(), forCellWithReuseIdentifier: "kCellLoveId")
        z_temp.register(ZRankSpaceHeadView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "kCellHeaderSpaceId")
        z_temp.register(ZRankItemHeadView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kCellHeaderId)
        z_temp.register(ZRankLoveItemHeadView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "kCellHeaderLoveId")
        return z_temp
    }()
    private lazy var z_viewweek: ZBaseCV = {
        let z_templayout = UICollectionViewFlowLayout.init()
        z_templayout.itemSize = CGSize.init(width: z_viewmain.width, height: 95.scale)
        z_templayout.minimumLineSpacing = 0
        z_templayout.minimumInteritemSpacing = 0
        z_templayout.scrollDirection = .vertical
        z_templayout.sectionHeadersPinToVisibleBounds = false
        z_templayout.sectionFootersPinToVisibleBounds = false
        
        let z_temp = ZBaseCV.init(frame: CGRect.init(z_viewmain.width, 0, z_viewmain.width, z_viewmain.height), collectionViewLayout: z_templayout)
        z_temp.tag = kEnumRankTime.Week.rawValue
        z_temp.scrollsToTop = false
        z_temp.alwaysBounceVertical = true
        z_temp.backgroundColor = .clear
        z_temp.addNoDataView()
        z_temp.register(ZRankItemCVC.classForCoder(), forCellWithReuseIdentifier: kCellId)
        z_temp.register(ZRankLoveItemCVC.classForCoder(), forCellWithReuseIdentifier: "kCellLoveId")
        z_temp.register(ZRankSpaceHeadView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "kCellHeaderSpaceId")
        z_temp.register(ZRankItemHeadView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kCellHeaderId)
        z_temp.register(ZRankLoveItemHeadView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "kCellHeaderLoveId")
        return z_temp
    }()
    private lazy var z_viewmonth: ZBaseCV = {
        let z_templayout = UICollectionViewFlowLayout.init()
        z_templayout.itemSize = CGSize.init(width: z_viewmain.width, height: 95.scale)
        z_templayout.minimumLineSpacing = 0
        z_templayout.minimumInteritemSpacing = 0
        z_templayout.scrollDirection = .vertical
        z_templayout.sectionHeadersPinToVisibleBounds = false
        z_templayout.sectionFootersPinToVisibleBounds = false
        
        let z_temp = ZBaseCV.init(frame: CGRect.init(z_viewmain.width*2, 0, z_viewmain.width, z_viewmain.height), collectionViewLayout: z_templayout)
        z_temp.tag = kEnumRankTime.Month.rawValue
        z_temp.scrollsToTop = false
        z_temp.alwaysBounceVertical = true
        z_temp.backgroundColor = .clear
        z_temp.addNoDataView()
        z_temp.register(ZRankItemCVC.classForCoder(), forCellWithReuseIdentifier: kCellId)
        z_temp.register(ZRankLoveItemCVC.classForCoder(), forCellWithReuseIdentifier: "kCellLoveId")
        z_temp.register(ZRankSpaceHeadView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "kCellHeaderSpaceId")
        z_temp.register(ZRankItemHeadView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kCellHeaderId)
        z_temp.register(ZRankLoveItemHeadView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "kCellHeaderLoveId")
        return z_temp
    }()
    private let z_viewmodel: ZRankViewModel = ZRankViewModel()
    
    required init(vc: ZZBaseViewController, frame: CGRect) {
        super.init(frame: frame)
        
        z_viewmodel.vc = vc
        
        self.backgroundColor = .clear
        self.addSubview(z_imagebg)
        self.addSubview(z_viewtime)
        z_viewtime.addSubview(z_btnday)
        z_viewtime.addSubview(z_btnweek)
        z_viewtime.addSubview(z_btnmonth)
        
        self.addSubview(z_viewmain)
        z_viewmain.addSubview(z_viewday)
        z_viewmain.addSubview(z_viewweek)
        z_viewmain.addSubview(z_viewmonth)
        self.sendSubviewToBack(z_imagebg)
        
        self.z_btnday.addTarget(self, action: "func_btntimeclick:", for: .touchUpInside)
        self.z_btnweek.addTarget(self, action: "func_btntimeclick:", for: .touchUpInside)
        self.z_btnmonth.addTarget(self, action: "func_btntimeclick:", for: .touchUpInside)
        
        func_setupevent()
        z_viewmodel.delegate = self
        z_viewday.delegate = self
        z_viewday.dataSource = self
        z_viewweek.delegate = self
        z_viewweek.dataSource = self
        z_viewmonth.delegate = self
        z_viewmonth.dataSource = self
        z_viewmain.delegate = self
    }
    deinit {
        z_viewmodel.delegate = nil
        z_viewday.delegate = nil
        z_viewday.dataSource = nil
        z_viewweek.delegate = nil
        z_viewweek.dataSource = nil
        z_viewmonth.delegate = nil
        z_viewmonth.dataSource = nil
        z_viewmain.delegate = nil
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    final func func_reloadheader() {
        switch self.z_currentpage {
        case 0:
            if self.arrayDay.count == 0 {
                z_viewday.startAnimating()
                z_viewmodel.func_requestranklocal(type: self.z_type, time: .Day)
            }
        case 1:
            if self.arrayWeek.count == 0 {
                z_viewweek.startAnimating()
                z_viewmodel.func_requestranklocal(type: self.z_type, time: .Week)
            }
        case 2:
            if self.arrayMonth.count == 0 {
                z_viewmonth.startAnimating()
                z_viewmodel.func_requestranklocal(type: self.z_type, time: .Month)
            }
        default: break
        }
    }
    private func func_setupevent() {
        z_viewday.addRefreshHeader()
        z_viewday.addRefreshFooter()
        z_viewday.onRefreshHeader = {
            self.z_viewmodel.func_requestrankheader(type: self.z_type, time: .Day)
        }
        z_viewday.onRefreshFooter = {
            self.z_viewmodel.func_requestrankfooter(type: self.z_type, time: .Day)
        }
        z_viewweek.addRefreshHeader()
        z_viewweek.addRefreshFooter()
        z_viewweek.onRefreshHeader = {
            self.z_viewmodel.func_requestrankheader(type: self.z_type, time: .Week)
        }
        z_viewweek.onRefreshFooter = {
            self.z_viewmodel.func_requestrankfooter(type: self.z_type, time: .Week)
        }
        z_viewmonth.addRefreshHeader()
        z_viewmonth.addRefreshFooter()
        z_viewmonth.onRefreshHeader = {
            self.z_viewmodel.func_requestrankheader(type: self.z_type, time: .Month)
        }
        z_viewmonth.onRefreshFooter = {
            self.z_viewmodel.func_requestrankfooter(type: self.z_type, time: .Month)
        }
    }
    @objc private func func_btntimeclick(_ sender: UIButton) {
        switch sender.tag {
        case kEnumRankTime.Day.rawValue:
            z_viewday.scrollsToTop = true
            z_viewweek.scrollsToTop = false
            z_viewmonth.scrollsToTop = false
            if self.z_currentpage == 0 { return }
            z_viewmain.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        case kEnumRankTime.Week.rawValue:
            z_viewday.scrollsToTop = false
            z_viewweek.scrollsToTop = true
            z_viewmonth.scrollsToTop = false
            if self.z_currentpage == 1 { return }
            z_viewmain.setContentOffset(CGPoint.init(x: z_viewmain.width, y: 0), animated: true)
        case kEnumRankTime.Month.rawValue:
            z_viewday.scrollsToTop = false
            z_viewweek.scrollsToTop = false
            z_viewmonth.scrollsToTop = true
            if self.z_currentpage == 2 { return }
            z_viewmain.setContentOffset(CGPoint.init(x: z_viewmain.width*2, y: 0), animated: true)
        default: break
        }
    }
    private func func_itemchange(page: Int) {
        if self.z_currentpage != page {
            switch page {
            case 0:
                self.z_btnday.isSelected = true
                self.z_btnweek.isSelected = false
                self.z_btnmonth.isSelected = false
            case 1:
                self.z_btnday.isSelected = false
                self.z_btnweek.isSelected = true
                self.z_btnmonth.isSelected = false
            case 2:
                self.z_btnday.isSelected = false
                self.z_btnweek.isSelected = false
                self.z_btnmonth.isSelected = true
            default: break
            }
            self.z_currentpage = page
            self.func_reloadheader()
        }
    }
}
extension ZRankItemView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 10 {
            let currentIndex = Int(floor(scrollView.contentOffset.x/(scrollView.frame.size.width/3*2)))
            self.func_itemchange(page: currentIndex)
        }
    }
}
extension ZRankItemView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch collectionView.tag {
        case kEnumRankTime.Day.rawValue:
            if let array = arrayDayTop, array.count > 0 {
                return CGSize.init(width: collectionView.width, height: kIsIPhoneX ? 220 : 210)
            }
        case kEnumRankTime.Week.rawValue:
            if let array = arrayWeekTop, array.count > 0 {
                return CGSize.init(width: collectionView.width, height: kIsIPhoneX ? 220 : 210)
            }
        case kEnumRankTime.Month.rawValue:
            if let array = arrayMonthTop, array.count > 0 {
                return CGSize.init(width: collectionView.width, height: kIsIPhoneX ? 220 : 210)
            }
        default: break
        }
        return CGSize.init(width: collectionView.width, height: 1)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch self.z_type {
        case .Lover:
            switch collectionView.tag {
            case kEnumRankTime.Day.rawValue:
                if let array = arrayDayTop, array.count > 0 {
                    let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "kCellHeaderLoveId", for: indexPath) as! ZRankLoveItemHeadView
                    view.z_arrayUser = array
                    view.z_type = self.z_type
                    view.z_onbuttonphotoclick = { user in
                        self.z_onbuttonphotoclick?(user)
                    }
                    return view
                }
            case kEnumRankTime.Week.rawValue:
                if let array = arrayWeekTop, array.count > 0 {
                    let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "kCellHeaderLoveId", for: indexPath) as! ZRankLoveItemHeadView
                    view.z_arrayUser = array
                    view.z_type = self.z_type
                    view.z_onbuttonphotoclick = { user in
                        self.z_onbuttonphotoclick?(user)
                    }
                    return view
                }
            case kEnumRankTime.Month.rawValue:
                if let array = arrayMonthTop, array.count > 0 {
                    let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "kCellHeaderLoveId", for: indexPath) as! ZRankLoveItemHeadView
                    view.z_arrayUser = array
                    view.z_type = self.z_type
                    view.z_onbuttonphotoclick = { user in
                        self.z_onbuttonphotoclick?(user)
                    }
                    return view
                }
            default: break
            }
        default: break
        }
        switch collectionView.tag {
        case kEnumRankTime.Day.rawValue:
            if let array = arrayDayTop, array.count > 0 {
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kCellHeaderId, for: indexPath) as! ZRankItemHeadView
                view.z_arrayUser = array
                view.z_type = self.z_type
                view.z_onbuttonphotoclick = { user in
                    self.z_onbuttonphotoclick?(user)
                }
                return view
            }
        case kEnumRankTime.Week.rawValue:
            if let array = arrayWeekTop, array.count > 0 {
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kCellHeaderId, for: indexPath) as! ZRankItemHeadView
                view.z_arrayUser = array
                view.z_type = self.z_type
                view.z_onbuttonphotoclick = { user in
                    self.z_onbuttonphotoclick?(user)
                }
                return view
            }
        case kEnumRankTime.Month.rawValue:
            if let array = arrayMonthTop, array.count > 0 {
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kCellHeaderId, for: indexPath) as! ZRankItemHeadView
                view.z_arrayUser = array
                view.z_type = self.z_type
                view.z_onbuttonphotoclick = { user in
                    self.z_onbuttonphotoclick?(user)
                }
                return view
            }
        default: break
        }
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "kCellHeaderSpaceId", for: indexPath)
        return view
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case kEnumRankTime.Week.rawValue: return arrayWeek.count <= topcount ? 0 : arrayWeek.count - topcount
        case kEnumRankTime.Month.rawValue: return arrayMonth.count <= topcount ? 0 : arrayMonth.count - topcount
        default: break
        }
        return arrayDay.count <= topcount ? 0 : arrayDay.count - topcount
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch self.z_type {
        case .Lover:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kCellLoveId", for: indexPath) as! ZRankLoveItemCVC
            switch collectionView.tag {
            case kEnumRankTime.Day.rawValue:
                cell.z_model = ZModelUserInfo.init(instance: arrayDay[indexPath.row + topcount])
            case kEnumRankTime.Week.rawValue:
                cell.z_model = ZModelUserInfo.init(instance: arrayWeek[indexPath.row + topcount])
            case kEnumRankTime.Month.rawValue:
                cell.z_model = ZModelUserInfo.init(instance: arrayMonth[indexPath.row + topcount])
            default: break
            }
            cell.z_type = self.z_type
            cell.z_row = indexPath.row + topcount
            cell.tag = collectionView.tag
            
            return cell
        default: break
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellId, for: indexPath) as! ZRankItemCVC
        switch collectionView.tag {
        case kEnumRankTime.Day.rawValue:
            cell.z_model = ZModelUserInfo.init(instance: arrayDay[indexPath.row + topcount])
        case kEnumRankTime.Week.rawValue:
            cell.z_model = ZModelUserInfo.init(instance: arrayWeek[indexPath.row + topcount])
        case kEnumRankTime.Month.rawValue:
            cell.z_model = ZModelUserInfo.init(instance: arrayMonth[indexPath.row + topcount])
        default: break
        }
        cell.z_type = self.z_type
        cell.z_row = indexPath.row + topcount
        cell.tag = collectionView.tag
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case kEnumRankTime.Day.rawValue:
            let model = arrayDay[indexPath.row + topcount]
            self.z_onbuttonphotoclick?(model)
        case kEnumRankTime.Week.rawValue:
            let model = arrayWeek[indexPath.row + topcount]
            self.z_onbuttonphotoclick?(model)
        case kEnumRankTime.Month.rawValue:
            let model = arrayMonth[indexPath.row + topcount]
            self.z_onbuttonphotoclick?(model)
        default: break
        }
    }
    private func func_reloaddata(models: [ZModelUserInfo]?, type: kEnumRankType, time: kEnumRankTime) {
        let count = models?.count ?? 0
        switch time {
        case .Day:
            if count > 3 {
                self.arrayDayTop = [models![0], models![1], models![2]]
            } else {
                switch count {
                case 0:
                    self.arrayDayTop = nil
                case 1:
                    self.arrayDayTop = [models![0]]
                case 2:
                    self.arrayDayTop = [models![0], models![1]]
                case 3:
                    self.arrayDayTop = [models![0], models![1], models![2]]
                default: break
                }
            }
            self.arrayDay.removeAll()
            if let array = models {
                self.arrayDay.append(contentsOf: array)
            }
            DispatchQueue.DispatchAfter(after: 0.45, handler: { [weak self] in
                guard let `self` = self else { return }
                self.z_viewday.stopAnimating(count: count)
                self.z_viewday.endRefreshHeader()
                self.z_viewday.reloadData()
            })
        case .Week:
            if count > 3 {
                self.arrayWeekTop = [models![0], models![1], models![2]]
            } else {
                switch count {
                case 0:
                    self.arrayWeekTop = nil
                case 1:
                    self.arrayWeekTop = [models![0]]
                case 2:
                    self.arrayWeekTop = [models![0], models![1]]
                case 3:
                    self.arrayWeekTop = [models![0], models![1], models![2]]
                default: break
                }
            }
            self.arrayWeek.removeAll()
            if let array = models {
                self.arrayWeek.append(contentsOf: array)
            }
            DispatchQueue.DispatchAfter(after: 0.45, handler: { [weak self] in
                guard let `self` = self else { return }
                self.z_viewweek.stopAnimating(count: count)
                self.z_viewweek.endRefreshHeader()
                self.z_viewweek.reloadData()
            })
            
        case .Month:
            if count > 3 {
                self.arrayMonthTop = [models![0], models![1], models![2]]
            } else {
                switch count {
                case 0:
                    self.arrayMonthTop = nil
                case 1:
                    self.arrayMonthTop = [models![0]]
                case 2:
                    self.arrayMonthTop = [models![0], models![1]]
                case 3:
                    self.arrayMonthTop = [models![0], models![1], models![2]]
                default: break
                }
            }
            self.arrayMonth.removeAll()
            if let array = models {
                self.arrayMonth.append(contentsOf: array)
            }
            DispatchQueue.DispatchAfter(after: 0.45, handler: { [weak self] in
                guard let `self` = self else { return }
                self.z_viewmonth.stopAnimating(count: count)
                self.z_viewmonth.endRefreshHeader()
                self.z_viewmonth.reloadData()
            })
        default: break
        }
    }
}
extension ZRankItemView: ZRankViewModelDelegate {
    func func_requestranklocalsuccess(models: [ZModelUserInfo]?, type: kEnumRankType, time: kEnumRankTime) {
        let count = models?.count ?? 0
        if count == 0 {
            switch time {
            case .Day:
                if self.arrayDay.count == 0 {
                    self.z_viewmodel.func_requestrankheader(type: type, time: time)
                }
            case .Week:
                if self.arrayWeek.count == 0 {
                    self.z_viewmodel.func_requestrankheader(type: type, time: time)
                }
            case .Month:
                if self.arrayMonth.count == 0 {
                    self.z_viewmodel.func_requestrankheader(type: type, time: time)
                }
            default: break
            }
        } else {
            self.func_reloaddata(models: models, type: type, time: time)
            DispatchQueue.DispatchAfter(after: 0.35, handler: { [weak self] in
                guard let `self` = self else { return }
                switch time {
                case .Day:
                    if self.arrayDay.count == 0 {
                        self.z_viewmodel.func_requestrankheader(type: type, time: time)
                    }
                case .Week:
                    if self.arrayWeek.count == 0 {
                        self.z_viewmodel.func_requestrankheader(type: type, time: time)
                    }
                case .Month:
                    if self.arrayMonth.count == 0 {
                        self.z_viewmodel.func_requestrankheader(type: type, time: time)
                    }
                default: break
                }
            })
        }
    }
    func func_requestrankheadersuccess(models: [ZModelUserInfo]?, type: kEnumRankType, time: kEnumRankTime) {
        self.func_reloaddata(models: models, type: type, time: time)
    }
    func func_requestrankfootersuccess(models: [ZModelUserInfo]?, type: kEnumRankType, time: kEnumRankTime) {
        switch time {
        case .Day:
            if let array = models {
                self.arrayDay.append(contentsOf: array)
            }
            self.z_viewday.endRefreshFooter(models?.count ?? 0)
            self.z_viewday.reloadData()
        case .Week:
            if let array = models {
                self.arrayWeek.append(contentsOf: array)
            }
            self.z_viewweek.endRefreshFooter(models?.count ?? 0)
            self.z_viewweek.reloadData()
        case .Month:
            if let array = models {
                self.arrayMonth.append(contentsOf: array)
            }
            self.z_viewmonth.endRefreshFooter(models?.count ?? 0)
            self.z_viewmonth.reloadData()
        default: break
        }
    }
}

