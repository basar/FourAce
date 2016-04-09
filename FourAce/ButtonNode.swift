//
//  ButtonNode.swift
//  FortuneTeller
//
//  Created by basar cetinkaya on 04/08/15.
//  Copyright (c) 2015 basar cetinkaya. All rights reserved.
//

import SpriteKit


protocol ButtonNodeDelegate {
    
    func buttonNodeDidTapped(deckNode:ButtonNode)
    
}


class ButtonNode : SKSpriteNode {
    
    
    var delegate:ButtonNodeDelegate?
    
    
    init(imageNamed:String,width:CGFloat,height:CGFloat){
        
        let deckTexture = SKTexture(imageNamed: imageNamed)
        super.init(texture:deckTexture,color:UIColor(),size:CGSizeMake(width,height))
        
        userInteractionEnabled=true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch = touches.first as UITouch?;
        let location  = touch!.locationInNode(self.parent!)
        if (self.containsPoint(location)){
            delegate?.buttonNodeDidTapped(self)
        }
        
    }
    
    
}
