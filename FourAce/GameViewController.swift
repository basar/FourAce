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

    

    fileprivate var bannerView:ADBannerView?;
    
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let screenSize:CGSize = UIScreen.main.bounds.size;
        let scene = GameScene(size: screenSize,viewController:self);
        scene.scaleMode = .fill
        
        let skView = view as! SKView
        
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)
        
        bannerView = ADBannerView(frame: CGRect.zero)
        bannerView!.autoresizingMask = UIViewAutoresizing.flexibleWidth;
        bannerView!.delegate = self;
        bannerView!.frame = CGRect(x: 0,y: self.view.frame.height - bannerView!.frame.size.height,width: self.view.frame.size.width,height: bannerView!.frame.size.width);
        
        self.view.addSubview(bannerView!);

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
