//
//  ContactUsVC.swift
//  MyStudySpace
//
//  Created by Xiaohu He on 2020-04-12.
//  Copyright © 2020 Haoquan you. All rights reserved.
//

import UIKit

class ContactUsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func goToAFromCBtn(_ sender: Any) {
       performSegue(withIdentifier: "goToAFromCSeague", sender: self)
    }
    
    @IBAction func goBackToSTCV_Btn(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToSTVC", sender: self)
    }
    
    @IBAction func goToProfessorLinkBtn(_ sender: Any) {
        openUrl(urlStr: "https://www.wlu.ca/academics/faculties/faculty-of-science/faculty-profiles/chinh-t-hoang/index.html")
    }
    
    func openUrl(urlStr:String!) {
        if let url = URL(string:urlStr), !url.absoluteString.isEmpty {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
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
