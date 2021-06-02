
import UIKit
import BFKit
import WebKit
import SwiftBasicKit

class ZRechargeWebViewController: ZZBaseViewController {
    
    var z_title: String?
    var z_success: String?
    var z_failed: String?
    var z_link: String? {
        didSet {
            guard let str = self.z_link else { return }
            guard let url = URL.init(string: str)  else { return }
            let req = URLRequest.init(url: url)
            self.wkwebView.load(req)
            self.wkwebView.reload()
        }
    }
    private var estimatedProgress: Float = 0.0
    private var currentRequest: URLRequest?
    private lazy var viewmain: UIView = {
        let temp = UIView.init(frame: CGRect.main())
        temp.backgroundColor = "#000000".color.withAlphaComponent(0.6)
        return temp
    }()
    private lazy var viewcontent: UIView = {
        let temph = 510*(kScreenHeight/667)
        let temp = UIView.init(frame: CGRect.init(15.scale, kScreenHeight/2 - temph/2, 345.scale, temph))
        temp.backgroundColor = "#1E1925".color
        temp.border(color: .clear, radius: 15, width: 0)
        return temp
    }()
    private lazy var btnreload: UIButton = {
        let temp = UIButton.init(frame: CGRect.init(0, 0, 40, 40))
        temp.isHidden = true
        temp.isHighlighted = false
        temp.adjustsImageWhenHighlighted = false
        temp.setImage(Asset.comReload.image.withRenderingMode(.alwaysTemplate), for: .normal)
        temp.imageView?.tintColor = "#493443".color
        temp.imageEdgeInsets = UIEdgeInsets.init(12)
        return temp
    }()
    private lazy var btnclose: UIButton = {
        let temp = UIButton.init(frame: CGRect.init(viewcontent.width - 40, 0, 40, 40))
        temp.isHighlighted = false
        temp.adjustsImageWhenHighlighted = false
        temp.setImage(Asset.btnCloseW.image.withRenderingMode(.alwaysTemplate), for: .normal)
        temp.imageView?.tintColor = "#493443".color
        temp.imageEdgeInsets = UIEdgeInsets.init(13)
        return temp
    }()
    private lazy var lbtitle: UILabel = {
        let temp = UILabel.init(frame: CGRect.init(0, 10, viewcontent.width, 20))
        temp.textAlignment = .center
        temp.boldSize = 14
        temp.textColor = "#FFFFFF".color
        temp.text = (self.z_title ?? "") + " " + ZString.lbRecharge.text
        return temp
    }()
    private lazy var wkwebView: WKWebView = {
        let wkConfig = WKWebViewConfiguration()
        let preferences = WKPreferences()
        preferences.minimumFontSize = 20
        preferences.javaScriptCanOpenWindowsAutomatically = true
        wkConfig.preferences = preferences
        let userContentController = WKUserContentController()
        let source = "document.cookie = 'userid=1';"
        let userScript = WKUserScript.init(source: source, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
        userContentController.addUserScript(userScript)
        wkConfig.userContentController = userContentController
        let wkView = WKWebView.init(frame: CGRect.init(0, 45, viewcontent.width, viewcontent.height - 45), configuration: wkConfig)
        wkView.uiDelegate = self
        wkView.navigationDelegate = self
        wkView.backgroundColor = "#100D13".color
        wkView.scrollView.isScrollEnabled = true
        wkView.scrollView.showsVerticalScrollIndicator = true
        wkView.scrollView.showsHorizontalScrollIndicator = false
        wkView.addObserver(self, forKeyPath: "title", options: NSKeyValueObservingOptions.new, context: nil)
        wkView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil)
        return wkView
    }()
    private lazy var progressView: UIProgressView = {
        let temp = UIProgressView.init(frame: CGRect.init(0, wkwebView.y - 2, wkwebView.width, 2))
        temp.progressViewStyle = .default
        temp.transform = temp.transform.scaledBy(x: 1, y: 2)
        temp.progressTintColor = "#493443".color
        return temp
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showType = 2
        self.view.backgroundColor = .clear
        self.view.addSubview(viewmain)
        self.view.addSubview(viewcontent)
        self.view.sendSubviewToBack(viewmain)
        self.viewcontent.addSubview(lbtitle)
        self.viewcontent.addSubview(btnreload)
        self.viewcontent.addSubview(btnclose)
        self.viewcontent.addSubview(wkwebView)
        self.viewcontent.addSubview(progressView)
        btnreload.addTarget(self, action: "func_btnreloadclick", for: .touchUpInside)
        btnclose.addTarget(self, action: "func_btncloseclick", for: .touchUpInside)
    }
    deinit {
        self.wkwebView.stopLoading()
        self.wkwebView.uiDelegate = nil
        self.wkwebView.navigationDelegate = nil
        self.wkwebView.removeObserver(self, forKeyPath: "title", context: nil)
        self.wkwebView.removeObserver(self, forKeyPath: "estimatedProgress", context: nil)
    }
    @objc private func func_btnreloadclick() {
        guard let req = self.currentRequest else { return }
        self.wkwebView.load(req)
        self.wkwebView.reload()
    }
    @objc private func func_btncloseclick() {
        ZRouterKit.dismiss(fromVC: self, animated: true, completion: nil)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case "estimatedProgress":
            self.estimatedProgress = ((change?[NSKeyValueChangeKey.newKey] as? String)?.floatValue) ?? 0
            self.progressView.progress = Float(wkwebView.estimatedProgress)
        case "title":
            self.title = (change?[NSKeyValueChangeKey.newKey] as? String)
        default: break
        }
    }
}
extension ZRechargeWebViewController: WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    
    // MARK: - WKNavigationDelegate
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        self.btnreload.isHidden = false
        self.currentRequest = navigationAction.request
        BFLog.debug("currentRequest: \(navigationAction.request.url?.absoluteString ?? "")")
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        if let url = navigationAction.request.url?.absoluteString, let success = self.z_success, let failed = self.z_failed {
            switch url {
            case success:
                ZRouterKit.dismiss(fromVC: self, animated: true, completion: {
                    ZProgressHUD.showMessage(vc: nil, text: ZString.successRecharge.text)
                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "PayRechargeSuccess"), object: nil)
                })
            case failed:
                ZRouterKit.dismiss(fromVC: self, animated: true, completion: {
                    ZProgressHUD.showMessage(vc: nil, text: ZString.faildRecharge.text)
                })
            default: break
            }
        }
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(WKNavigationResponsePolicy.allow)
    }
    public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        BFLog.debug("didFinish: ")
        webView.evaluateJavaScript("document.body.scrollHeight") { (result, error) in
            BFLog.debug("document.body.scrollHeight: \(String(describing: result))")
        }
    }
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        BFLog.debug("didFail: \(error.localizedDescription)")
    }
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        BFLog.debug("didFailProvisionalNavigation: \(error.localizedDescription)")
    }
    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let credential = URLCredential.init(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
        }
    }
    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        
    }
    
    // MARK: - WKScriptMessageHandler
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        BFLog.debug("body: \(message.body)")
    }
    
    // MARK: - WKUIDelegate
    
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let itemVC = ZAlertSystemViewController.init(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        let actionDetermine = UIAlertAction.init(title: ZString.btnContinue.text, style: UIAlertAction.Style.default) { (action) in
            completionHandler()
        }
        itemVC.addAction(actionDetermine)
        ZRouterKit.present(toVC: itemVC)
    }
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        let itemVC = ZAlertSystemViewController.init(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        let actionDetermine = UIAlertAction.init(title: ZString.btnContinue.text, style: UIAlertAction.Style.default) { (action) in
            completionHandler(true)
        }
        itemVC.addAction(actionDetermine)
        let actionCancel = UIAlertAction.init(title: ZString.btnCancel.text, style: UIAlertAction.Style.default) { (action) in
            completionHandler(false)
        }
        itemVC.addAction(actionCancel)
        ZRouterKit.present(toVC: itemVC)
    }
    public func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let itemVC = ZAlertSystemViewController.init(title: nil, message: prompt, preferredStyle: UIAlertController.Style.alert)
        itemVC.addTextField { (textField) in
            textField.placeholder = defaultText
        }
        let actionDetermine = UIAlertAction.init(title: ZString.btnContinue.text, style: UIAlertAction.Style.default) { (action) in
            completionHandler(itemVC.textFields?.last?.text)
        }
        itemVC.addAction(actionDetermine)
        ZRouterKit.present(toVC: itemVC)
    }
}
