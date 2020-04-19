//
//  WebLoginVC.swift
//  MyStudySpace
//
//  Created by Aaron You on 4/6/20.
//  Copyright © 2020 Haoquan you. All rights reserved.
//

import UIKit
import WebKit

class WebLoginVC: UIViewController, WKNavigationDelegate {
    let kHEADERHEIGHT : CGFloat = 0.0
    let kFOOTERHEIGHT : CGFloat = 0.0
    
    var login_successful = false
    
    var webView : WKWebView = WKWebView()
    
    
    var url: NSURL?
    

    var loginState: LoginState!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginState = LoginHelper.sharedInstance.loginState
        ///wkwebview setup
        webView.allowsBackForwardNavigationGestures = true
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.webView)
        
        self.webView.navigationDelegate = self
        self.webView.load(URLRequest(url: (url ?? NSURL(string: "https://devcop.brightspace.com/d2l/login?sessionExpired=0&target=%2fd2l%2fauth%2fapi%2ftoken%3fx_a%3d31brpbcCLsVim_K4jJ8vzw%26x_b%3da0i3WTMoHVL2chM31iCmK1UeCIUB4W7rVH4sIfDwz8E%26x_target%3dhttps%253A%252F%252Fapitesttool.desire2learnvalence.com%252F"))! as URL))
    }
    
    
    override func viewWillLayoutSubviews() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        self.webView.frame = CGRect(origin: CGPoint(x:0, y:statusBarHeight), size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height - statusBarHeight))
        
    }
    
    // MARK: WKNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        NSLog("Start navigating to " + webView.url!.absoluteString)
        
        if webView.url!.absoluteString.contains( "https://apitesttool.desire2learnvalence.com") {
            print("True!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
            loginState.isLoggedIn = true;
            loginState.userId = ""
            loginState.userKey = ""

            LoginHelper.sharedInstance.saveLoginState()
            self.performSegue(withIdentifier: "returnToOnboarding", sender: self)
            
        }
        

    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        NSLog("Failed Navigation %@", error.localizedDescription)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Finish navigation
        print("Finish Navigation")
        print("Title:%@ URL:%@", webView.title!, webView.url!)
        if webView.url!.absoluteString.contains( "https://apitesttool.desire2learnvalence.com") {
            print("True!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
            loginState.isLoggedIn = true;
            loginState.userId = ""
            loginState.userKey = ""
            
            LoginHelper.sharedInstance.saveLoginState()
            self.performSegue(withIdentifier: "returnToOnboarding", sender: self)
        }

    }
    
    
    

    
    // MARK: - Navigation

    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
}

       


//
