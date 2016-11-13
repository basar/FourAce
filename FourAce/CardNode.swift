//
//  CardNode.swift
//  FortuneTeller
//
//  Created by basar cetinkaya on 12/07/15.
//  Copyright (c) 2015 basar cetinkaya. All rights reserved.
//

import SpriteKit


protocol CardNodeDelegate {
    
    func cardNodeDidDoubleTapped(_ cardNode:CardNode)
    
    func cardDidDropped(_ cardNode:CardNode)
    
    func cardMoving(_ cardNode:CardNode)
    
}

class CardNode : SKSpriteNode {
    
    var frontTexture:SKTexture;
    
    var backTexture:SKTexture;
    
    let backImageName:String="back_blue_v";
    
    var card:Card;
        
    var positionInStack:CGPoint = CGPoint(x: 0, y: 0)
    
    var delegate:CardNodeDelegate?
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(imageNamed:String,card:Card,width:CGFloat,height:CGFloat){
        
        self.card = card;
        self.frontTexture=SKTexture(imageNamed: imageNamed)
        self.backTexture = SKTexture(imageNamed: backImageName)
        super.init(texture:frontTexture,color:UIColor(),size:CGSize(width: width,height: height))
        
        isUserInteractionEnabled=true
    }
    
    
    func faceUp() {
        self.texture = frontTexture;
    }
    
    func faceDown(){
        self.texture = backTexture;
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for obj in touches{
            let touch = obj 
            let location  = touch.location(in: self.parent!)
            let touchedNode = atPoint(location);
            touchedNode.position=location
            touchedNode.zPosition=Constants.maxZIndex
            delegate?.cardMoving(self)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first as UITouch!;
        let location  = touch?.location(in: self)
        let touchedNode = atPoint(location!)
        
        let liftUp = SKAction.scale(to: 1.2, duration: 0.2)
        touchedNode.run(liftUp,withKey:"pickup");
        delegate?.cardMoving(self)
        
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first as UITouch!;
        let location  = touch?.location(in: self)
        let touchedNode = atPoint(location!)
        if((touch?.tapCount)!>1){
            touchedNode.isUserInteractionEnabled = false
            delegate?.cardNodeDidDoubleTapped(self)
        } else {
            delegate?.cardDidDropped(self)
        }
        let liftUp = SKAction.scale(to: 1.0, duration: 0.2)
        touchedNode.run(liftUp,withKey:"pickup");
        
    }
    
}
