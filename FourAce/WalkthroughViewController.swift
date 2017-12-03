//
//  WalkthroughViewController.swift
//  FourAce
//
//  Created by Basar Cetinkaya on 23.11.2017.
//  Copyright © 2017 basar cetinkaya. All rights reserved.
//

import UIKit

class WalkthroughViewController: BWWalkthroughViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollview.bounces=false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent;
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
