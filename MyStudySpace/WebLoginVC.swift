//
//  WebLoginVC.swift
//  MyStudySpace
//
//  Created by Aaron You on 4/6/20.
//  Copyright © 2020 Haoquan you. All rights reserved.
//

import UIKit

class WebLoginVC: UIViewController {
    var login_successful = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.performSegue(withIdentifier: "returnToOnboarding", sender: self)
    
        
        
        // Do any additional setup after loading the view.
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
