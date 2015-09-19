//
//  CardNode.swift
//  FortuneTeller
//
//  Created by basar cetinkaya on 12/07/15.
//  Copyright (c) 2015 basar cetinkaya. All rights reserved.
//

import SpriteKit


protocol CardNodeDelegate {
    
    func cardNodeDidDoubleTapped(cardNode:CardNode)
    
    func cardDidDropped(cardNode:CardNode)
    
}

class CardNode : SKSpriteNode {
    
    private var frontTexture:SKTexture;
    
    private var backTexture:SKTexture;
    
    private let backImageName:String="back_blue_v";
    
    var card:Card;
        
    var positionInStack:CGPoint = CGPointMake(0, 0)
    
    var delegate:CardNodeDelegate?
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(imageNamed:String,card:Card,width:CGFloat,height:CGFloat){
        
        self.card = card;
        self.frontTexture=SKTexture(imageNamed: imageNamed)
        self.backTexture = SKTexture(imageNamed: backImageName)
        super.init(texture:frontTexture,color:UIColor(),size:CGSizeMake(width,height))
        
        userInteractionEnabled=true
    }
    
    
    func faceUp() {
        self.texture = frontTexture;
    }
    
    func faceDown(){
        self.texture = backTexture;
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for obj in touches{
            let touch = obj 
            let location  = touch.locationInNode(self.parent!)
            let touchedNode = nodeAtPoint(location);
            touchedNode.position=location
            touchedNode.zPosition=Constants.maxZIndex
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch = touches.first as UITouch!;
        let location  = touch.locationInNode(self)
        let touchedNode = nodeAtPoint(location)
        
        let liftUp = SKAction.scaleTo(1.2, duration: 0.2)
        touchedNode.runAction(liftUp,withKey:"pickup");
        
        
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch = touches.first as UITouch!;
        let location  = touch.locationInNode(self)
        let touchedNode = nodeAtPoint(location)
        if(touch.tapCount>1){
            touchedNode.userInteractionEnabled = false
            delegate?.cardNodeDidDoubleTapped(self)
        } else {
            delegate?.cardDidDropped(self)
        }
        let liftUp = SKAction.scaleTo(1.0, duration: 0.2)
        touchedNode.runAction(liftUp,withKey:"pickup");
        
    }
    
}