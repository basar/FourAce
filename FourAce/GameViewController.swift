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


class GameViewController: UIViewController, ADBannerViewDelegate {

    

    private var bannerView:ADBannerView?;
    
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let screenSize:CGSize = UIScreen.mainScreen().bounds.size;
        let scene = GameScene(size: screenSize,viewController:self);
        scene.scaleMode = .Fill
        
        let skView = view as! SKView
        
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)
        
        bannerView = ADBannerView(frame: CGRectZero)
        bannerView!.autoresizingMask = UIViewAutoresizing.FlexibleWidth;
        bannerView!.delegate = self;
        bannerView!.frame = CGRectMake(0,self.view.frame.height - bannerView!.frame.size.height,self.view.frame.size.width,bannerView!.frame.size.width);
        
        self.view.addSubview(bannerView!);

    }

    
    /**
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    **/
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }


    override func viewWillLayoutSubviews() {
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        bannerView!.hidden = false;
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        bannerView!.hidden = true;
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        return true;
    }
    
    func bannerViewActionDidFinish(banner: ADBannerView!) {
        
    }

    
    


}
