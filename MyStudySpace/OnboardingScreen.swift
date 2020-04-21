//
//  OnboardingScreen.swift
//  MyStudySpace
//
//  Created by Aaron You on 4/6/20.
//  Copyright © 2020 Haoquan you. All rights reserved.
//

import UIKit
import paper_onboarding

class OnboardingScreen: UIViewController, UINavigationControllerDelegate {
    var login_successful = false
    var loginState: LoginState!
    var login_url: String!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var onboardingView: onboardingView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        loginBtn.isHidden = true
        loginBtn.isEnabled = false
        loginBtn.setTitle("Please Wait...", for: .disabled)
        self.navigationController?.delegate = self
        //        onboardingView.currentIndex(2, animated: true) // Skip to the login button
        
        _ = LoginHelper()
        LoginHelper.sharedInstance.loginState = LoginState()
        LoginHelper.sharedInstance.loadLoginState()
        LoginHelper.sharedInstance.startMonitorNetworkState()
        loginState = LoginHelper.sharedInstance.loginState
        
        _ = EnrollmentsHelper()
        
        if loginState.isLoggedIn {
            let story = UIStoryboard(name: "Main", bundle:nil)
            let vc = story.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            UIApplication.shared.windows.first?.rootViewController = vc
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        } else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let url = URL(string: "https://aaronyoo.myfirewall.org/getAuthUrl.php?x_a=YhQHxH&x_b=Placeholder") {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data {
                        do {
                            print("Got link!")
                            let res = try JSONDecoder().decode(URLResponse.self, from: data)
                            self.login_url = res.url
                            DispatchQueue.main.async {
                                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                self.loginBtn.isEnabled = true
                            }

                        } catch let error {
                            let alert = UIAlertController(title: "Oops", message: "We can't seem to get the login URL right now. Please restart the app and try again.", preferredStyle: .alert)
                            print(error)
                            
                            self.present(alert, animated: true)
                        }
                    }
                }.resume()
            }
        }
    }
    
    
    @IBAction func webLoginReturned(segue: UIStoryboardSegue){
        print("returned")
        let origVC = segue.source as! WebLoginVC
        if loginState.isLoggedIn {
            let homeVC = self.storyboard?.instantiateViewController(identifier: "HomeVC")
            self.view.window?.rootViewController = homeVC
            self.view.window?.makeKeyAndVisible()
        }
    }
    
    
}

extension OnboardingScreen: PaperOnboardingDataSource {
    func onboardingItemsCount() -> Int {
        3
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return [
            OnboardingItemInfo(informationImage: UIImage(named:"person")!,
                               title: "Welcome to MyStudySpace",
                               description: "An app that let you easily find your lecture notes, view your grades, and more...",
                               pageIcon: UIImage(named:"person")!,
                               color: #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1),
                               titleColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1),
                               descriptionColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1),
                               titleFont: UIFont.systemFont(ofSize: 30),
                               descriptionFont: UIFont.systemFont(ofSize: 20)),
            
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "technical-support"),
                               title: "Help us improve",
                               description: "We are always looking for ways to improve. Share your unique app experience with our team and help us stay in touch. If you encounter any errors or bugs, you can find us through the “contact us” in the settings, and then send us an error report.",
                               pageIcon: #imageLiteral(resourceName: "technical-support"),
                               color: #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1),
                               titleColor: UIColor.black,
                               descriptionColor: UIColor.black,
                               titleFont: UIFont.systemFont(ofSize: 30),
                               descriptionFont: UIFont.systemFont(ofSize: 20)),
            
            OnboardingItemInfo(informationImage: UIImage(named:"search")!,
                               title: "More features",
                               description: "MyStudySpace has some handy links for Laurier Students, such as the commonly used Visual Schedule Builder, Loris, and MylearningSpace.",
                               pageIcon: UIImage(named:"search")!,
                               color: #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1),
                               titleColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
                               descriptionColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
                               titleFont: UIFont.systemFont(ofSize: 30),
                               descriptionFont: UIFont.systemFont(ofSize: 20))
            ][index]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var nav = segue.destination as! UINavigationController
        let dest = nav.viewControllers.first as! WebLoginVC
        dest.url = self.login_url
    }
    
}

extension OnboardingScreen: PaperOnboardingDelegate {
    func onboardingDidTransitonToIndex(_ index: Int) {
        print("onboardingDidTransitonToIndex Called")
        if index == 2 {
            loginBtn.isHidden = false
        } else {
            loginBtn.isHidden = true
        }
    }
    
    
    
    func onboardingConfigurationItem(_: OnboardingContentViewItem, index _: Int) {
        print("onboardingConfigurationItem Called")
    }
}
