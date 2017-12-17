//
//  WalkthroughPageOneViewController.swift
//  FourAce
//
//  Created by Basar Cetinkaya on 10.12.2017.
//  Copyright © 2017 basar cetinkaya. All rights reserved.
//

import UIKit

class WalkthroughPageViewController: BWWalkthroughPageViewController {

    @IBOutlet weak var brief: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if let id = self.restorationIdentifier {
        
            switch id {
            case Constants.walkthroughOneId:
                brief.text = "walkthrough_brief_1".localized
            case Constants.walkthroughTwoId:
                brief.text = "walkthrough_brief_2".localized
            case Constants.walkthroughThreeId:
                brief.text = "walkthrough_brief_3".localized
            default:
                brief.text = ""
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
