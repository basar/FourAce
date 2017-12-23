//
//  GameViewController.swift
//  FortuneTeller
//
//  Created by basar cetinkaya on 30/07/14.
//  Copyright (c) 2014 basar cetinkaya. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, BWWalkthroughViewControllerDelegate, WalkthroughViewControllerDelegate {
    
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
        
        if(!Util.isFirstStartOfGame()){
            self.gameScene.startGame();
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //if game is new installed, walkthrough screen will be showed
        if(Util.isFirstStartOfGame()){
            showWalkthroughScreen();
        }
        
    }
    
    func showWalkthroughScreen () {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        self.walkthroughController = storyBoard.instantiateViewController(withIdentifier: "wtContainer") as! WalkthroughViewController
        let pageOne = storyBoard.instantiateViewController(withIdentifier: Constants.walkthroughOneId)
        let pageTwo = storyBoard.instantiateViewController(withIdentifier: Constants.walkthroughTwoId)
        let pageThree = storyBoard.instantiateViewController(withIdentifier: Constants.walkthroughThreeId)
        
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
    
}


extension GameViewController {
    
    func walkthroughCloseButtonPressed() {
        
        self.dismiss(animated: true, completion: {
            //Do nothing
        })
        
        if(Util.isFirstStartOfGame()){
            Util.changeGameState(true)
            self.gameScene.startGame();
        }
        
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
        self.walkthroughCloseButtonPressed();
    }
}

