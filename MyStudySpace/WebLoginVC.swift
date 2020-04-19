//
//  WebLoginVC.swift
//  
//
//  Created by Aaron You on 4/19/20.
//

import UIKit
import WebKit

class WebLoginVC: UIViewController, WKNavigationDelegate {
    var login_successful = false
    
    var url:String?
    var loginState: LoginState!
    
    let webView = WKWebView()
    override func viewDidLoad() {
        super.viewDidLoad()
        loginState = LoginHelper.sharedInstance.loginState
        webView.navigationDelegate = self
        if let url1 = URL(string: url ?? "https://apple.com") {
            let request = URLRequest(url: url1)
            webView.load(request)
        }
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.url), options: .new, context: nil)
        
    }
    
    override func loadView() {
        self.view = webView
    }
    
    
    
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("Error in didFailProvisionalNavigation")
        print(error)
        if error._domain == "NSURLErrorDomain" {
            if let info = error._userInfo as? [String: Any] {
                if let urlString = info["NSErrorFailingURLStringKey"] as? String {
                    if urlString.contains("http://pulse.brightspace.com/android/"){
                        urlString.split(separator: "?")[1].split(separator: "&")
                        loginState.isLoggedIn = true;
                        loginState.userId = String(urlString.split(separator: "?")[1].split(separator: "&")[0])
                        loginState.userKey = String(urlString.split(separator: "?")[1].split(separator: "&")[1])
                        print("Got id: " + loginState.userId)
                        print("Got key: " + loginState.userKey)
                        LoginHelper.sharedInstance.saveLoginState()
                        self.performSegue(withIdentifier: "returnToOnboarding", sender: self)

                    }
                }
            }
        }
    }
    
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "url" {
            if webView.url!.absoluteString.contains( "https://apitesttool.desire2learnvalence.com") {
                loginState.isLoggedIn = true;
                loginState.userId = ""
                loginState.userKey = ""
                
                LoginHelper.sharedInstance.saveLoginState()
                self.performSegue(withIdentifier: "returnToOnboarding", sender: self)
            }
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
