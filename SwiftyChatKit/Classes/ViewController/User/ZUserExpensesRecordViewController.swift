
import UIKit
import SwiftBasicKit

class ZUserExpensesRecordViewController: ZZBaseViewController {
    
    private var arrayModels: [ZModelExpensesRecord] = [ZModelExpensesRecord]()
    private lazy var z_viewmain: ZBaseTV = {
        let z_temp = ZBaseTV.init(frame: CGRect.mainRemoveTop())
        //z_temp.tableHeaderView = z_searchcontroller.searchBar
        z_temp.addNoDataView()
        z_temp.addRefreshHeader()
        z_temp.addRefreshFooter()
        z_temp.register(ZUserExpensesRecordTVC.classForCoder(), forCellReuseIdentifier: kCellId)
        return z_temp
    }()
    private lazy var z_searchcontroller: UISearchController = {
        let z_temp = UISearchController.init(searchResultsController: nil)
        z_temp.searchResultsUpdater = self as? UISearchResultsUpdating
        z_temp.dimsBackgroundDuringPresentation = false
        z_temp.hidesNavigationBarDuringPresentation = false
        z_temp.definesPresentationContext = false
        z_temp.isActive = false
        z_temp.searchBar.sizeToFit()
        z_temp.searchBar.enablesReturnKeyAutomatically = false
        z_temp.searchBar.barTintColor = "#100D13".color
        z_temp.searchBar.placeholder = ZString.lbExpensesRecordSearchPlaceholder.text
        z_temp.searchBar.textColor = "#2D70DE".color
        z_temp.searchBar.barBackgroundColor = "#100D13".color
        z_temp.searchBar.placeholderColor = "#888888".color
        return z_temp
    }()
    private let z_viewmodel: ZUserExpensesRecordViewModel = ZUserExpensesRecordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        z_viewmodel.vc = self
        self.title = ZString.lbExpensesrecord.text
        self.view.addSubview(z_viewmain)
        
        z_viewmain.delegate = self
        z_viewmain.dataSource = self
        z_viewmodel.delegate = self
        //z_searchcontroller.searchBar.delegate = self
        
        z_viewmain.onRefreshHeader = {
            self.z_viewmodel.func_requestexpensesrecordheader()
        }
        z_viewmain.onRefreshFooter = {
            self.z_viewmodel.func_requestexpensesrecordfooter()
        }
        z_viewmain.startAnimating()
        z_viewmodel.func_requestexpensesrecordlocal()
        z_viewmodel.func_requestexpensesrecordheader()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //z_searchcontroller.view.alpha = 1
        //z_searchcontroller.searchBar.alpha = 1
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //z_searchcontroller.view.alpha = 0
        //z_searchcontroller.searchBar.alpha = 0
        //z_searchcontroller.isActive = false
    }
    deinit {
        z_viewmain.delegate = nil
        z_viewmain.dataSource = nil
        z_viewmodel.delegate = nil
    }
}
extension ZUserExpensesRecordViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayModels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellId, for: indexPath) as! ZUserExpensesRecordTVC
        
        cell.z_model = arrayModels[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = arrayModels[indexPath.row]
        switch model.biz_code {
        case 2: return 145
        default: break
        }
        return 90
    }
}
extension ZUserExpensesRecordViewController: ZUserExpensesRecordViewModelDelegate {
    func func_requestsuccessheader(models: [ZModelExpensesRecord]?) {
        self.arrayModels.removeAll()
        if let array = models {
            self.arrayModels.append(contentsOf: array)
        }
        let count = models?.count ?? 0
        self.z_viewmain.stopAnimating(count: count)
        self.z_viewmain.endRefreshHeader(count)
        self.z_viewmain.reloadData()
    }
    func func_requestsuccessfooter(models: [ZModelExpensesRecord]?) {
        if let array = models {
            self.arrayModels.append(contentsOf: array)
        }
        let count = models?.count ?? 0
        self.z_viewmain.endRefreshFooter(count)
        self.z_viewmain.reloadData()
    }
}
extension ZUserExpensesRecordViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
}
