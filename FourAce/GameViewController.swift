//
//  GameViewController.swift
//  FortuneTeller
//
//  Created by basar cetinkaya on 30/07/14.
//  Copyright (c) 2014 basar cetinkaya. All rights reserved.
//

import UIKit
import SpriteKit


class GameViewController: UIViewController {

    
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let scene = GameScene(size: view.bounds.size,viewController:self);
        scene.scaleMode = .ResizeFill
        
        let skView = view as! SKView
        
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)
    }

    
    /**
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    **/
    

}
