//
//  AboutViewController.swift
//  MyStudySpace
//
//  Created by Xiaohu He on 2020-04-12.
//  Copyright © 2020 Haoquan you. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func goBackToSTVC_Btn(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToSTVC", sender: self)
    }
    
    @IBAction func unwindToAVC(segue:UIStoryboardSegue){ }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
