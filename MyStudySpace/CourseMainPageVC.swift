//
//  CourseMainPageVC.swift
//  MyStudySpace
//
//  Created by Xiaohu He on 2020-04-17.
//  Copyright © 2020 Haoquan you. All rights reserved.
//

import UIKit

class CourseMainPageVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func goBackFromCMPBtn(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToCMP", sender: self)
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
