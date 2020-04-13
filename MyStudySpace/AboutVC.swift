//
//  AboutViewController.swift
//  MyStudySpace
//
//  Created by Xiaohu He on 2020-04-12.
//  Copyright © 2020 Haoquan you. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func goToCFromABtn(_ sender: Any) {
        performSegue(withIdentifier: "goToCFromASeague", sender: self)
    }
    @IBAction func goldenHawkLinkBtn(_ sender: Any) {
        openUrl(urlStr: "http://wlu.ca")
    }
    
    func openUrl(urlStr:String!) {
        
        if let url = URL(string:urlStr), !url.absoluteString.isEmpty {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func goBackToSTVC_Btn(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToSTVC", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
