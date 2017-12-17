//
//  GameViewController.swift
//  FortuneTeller
//
//  Created by basar cetinkaya on 30/07/14.
//  Copyright (c) 2014 basar cetinkaya. All rights reserved.
//

import UIKit
import SpriteKit
import iAd


class GameViewController: UIViewController, ADBannerViewDelegate, BWWalkthroughViewControllerDelegate,WalkthroughViewControllerDelegate {

    fileprivate var bannerView:ADBannerView?;
    
    var walkthroughController:WalkthroughViewController!;
    
    var gameScene:GameScene!;
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let screenSize:CGSize = Util.isIPhone4OrLess() ? UIScreen.main.bounds.size : CGSize(width: 320, height: 568);
     
        self.gameScene = GameScene(size: screenSize,viewController:self);
        self.gameScene.scaleMode = .aspectFill
        
        let skView = view as! SKView
        
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        
        skView.presentScene(self.gameScene)
        
        bannerView = ADBannerView(frame: CGRect.zero)
        bannerView!.autoresizingMask = UIViewAutoresizing.flexibleWidth;
        bannerView!.delegate = self;
        bannerView!.frame = CGRect(x: 0,y: self.view.frame.height - bannerView!.frame.size.height,width: self.view.frame.size.width,height: bannerView!.frame.size.width);
        
        self.view.addSubview(bannerView!);
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                
    }
    
    func showWalkthroughScreen () {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        self.walkthroughController = storyBoard.instantiateViewController(withIdentifier: "wtContainer") as! WalkthroughViewController
        let pageOne = storyBoard.instantiateViewController(withIdentifier: "wtPage1")
        let pageTwo = storyBoard.instantiateViewController(withIdentifier: "wtPage2")
        let pageThree = storyBoard.instantiateViewController(withIdentifier: "wtPage3")

        self.walkthroughController.delegate = self
        self.walkthroughController.delegateWalkthrough = self;
        self.walkthroughController.add(viewController:pageOne)
        self.walkthroughController.add(viewController:pageTwo)
        self.walkthroughController.add(viewController:pageThree)
        
        self.present(self.walkthroughController, animated: true) {
            ()->() in
            //Do nothing
        }
        
        //let pageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pageViewControllerId");
        //self.viewController.present(pageViewController, animated: true, completion: nil)
    }
    
    /**
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    **/
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent;
    }


    override func viewWillLayoutSubviews() {
    }
    
    func bannerViewDidLoadAd(_ banner: ADBannerView!) {
        bannerView!.isHidden = false;
    }
    
    func bannerView(_ banner: ADBannerView!, didFailToReceiveAdWithError error: Error!) {
        bannerView!.isHidden = true;
    }
    
    func bannerViewActionShouldBegin(_ banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        return true;
    }
    
    func bannerViewActionDidFinish(_ banner: ADBannerView!) {
        
    }

}


extension GameViewController {
    
    func walkthroughCloseButtonPressed() {
        self.dismiss(animated: true, completion: nil)
        self.gameScene.doUnpauseTimer();
    }
    
    
    func walkthroughPageDidChange(_ pageNumber:Int) {
        
        if(pageNumber == 2){
            self.walkthroughController.startButton.isHidden = false;
        }else {
            self.walkthroughController.startButton.isHidden = true;
        }
    }
    
    func walkthroughStartButtonPressed() {
        self.dismiss(animated: true, completion: nil)
        self.gameScene.doUnpauseTimer();
    }
    
}
