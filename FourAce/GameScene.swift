//
//  GameScene.swift
//  FourAce
//
//  Created by basar cetinkaya on 30/07/14.
//  Copyright (c) 2014 basar cetinkaya. All rights reserved.
//

import SpriteKit



class GameScene: SKScene, FourAceGameDelegate, CardNodeDelegate, ButtonNodeDelegate {
    
    
    private var viewController:UIViewController;
    private var restartAlertView:AlertView;
    private var gameOverAlertView:AlertView;
    private var infoAlertView:AlertView;
    
    private let deckButton:ButtonNode;
    private let restartButton:ButtonNode;
    private let infoButton:ButtonNode;

    
    private let backgroundNode: SKSpriteNode;
    private let constantScoreLabel:SKLabelNode;
    
    private var stackRects:[CGRect]=[CGRect]();
    private var trashRect:CGRect = CGRectMake(Constants.trashPosition.x, Constants.trashPosition.y, Constants.trashWidth, Constants.trashHeight);
    
    private var cardZpositionInTrash:CGFloat = 5;
    
    
    init(size:CGSize,viewController:UIViewController) {
        
        //background
        backgroundNode = SKSpriteNode(imageNamed: "green_background");
        restartButton = ButtonNode(imageNamed: "restart_button", width:Constants.restartButtonWidth, height: Constants.restartButtonHeight)
        infoButton = ButtonNode(imageNamed: "info_button", width:Constants.infoButtonWidth, height: Constants.infoButtonHeight)
        deckButton = ButtonNode(imageNamed: "red_deck", width: Constants.deckWidth, height: Constants.cardHeight)
        
        constantScoreLabel = SKLabelNode();
    
        
        self.viewController = viewController;
        
        self.restartAlertView = AlertView(title:"Warning".localized,message:"Restart game?".localized,viewController:self.viewController);
        self.gameOverAlertView = AlertView(title:"Game Over!".localized,message:"".localized,viewController:self.viewController);
        self.infoAlertView = AlertView(title:"how_to_play".localized,message:"how_to_play_instructions".localized,viewController:self.viewController);


        super.init(size: size)
        
        for var i:Int=0;i<4;i++ {
            stackRects.insert(CGRectMake(Constants.stacksXPositions[i], Constants.stacksY, Constants.cardWidth, Constants.cardHeight), atIndex: i)
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        
        backgroundNode.position=CGPointMake(self.size.width/2, self.size.height/2);
        addChild(backgroundNode)
    
        constantScoreLabel.position = Constants.scoreLabelPosition;
        constantScoreLabel.fontName = "Arial";
        constantScoreLabel.fontSize = 14;
        constantScoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center;
        constantScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left;
        constantScoreLabel.alpha = 0.5;
        
        addChild(constantScoreLabel)
        
        
        var deckNodePlaceHolder = SKSpriteNode(imageNamed: "card_place_holder");
        deckNodePlaceHolder.size = CGSize(width: Constants.deckWidth + Constants.placeHolderMargin,
            height: Constants.deckHeight + Constants.placeHolderMargin)
        deckNodePlaceHolder.position = Constants.constantDeckPosition;
        addChild(deckNodePlaceHolder);
        
        var trashNode = SKSpriteNode(imageNamed: "card_place_holder");
        trashNode.size = CGSize(width: Constants.trashWidth + Constants.placeHolderMargin,
            height: Constants.trashHeight + Constants.placeHolderMargin);
        
        trashNode.position = Constants.trashPosition;
        addChild(trashNode)
        
        deckButton.position = Constants.constantDeckPosition
        deckButton.delegate = self
        addChild(deckButton)
        
        restartButton.position = Constants.restartButtonPosition
        restartButton.delegate = self
        addChild(restartButton)
        
        
        infoButton.position = Constants.infoButtonPosition
        infoButton.delegate = self
        addChild(infoButton)
        
        for var i:Int=0;i<4;i++ {
            var placeHolder = SKSpriteNode(imageNamed: "card_place_holder");
            placeHolder.position = CGPointMake(Constants.stacksXPositions[i], Constants.stacksY)
            placeHolder.size = CGSize(width:Constants.cardWidth + Constants.placeHolderMargin,
                height:Constants.cardHeight + Constants.placeHolderMargin);
            self.addChild(placeHolder)
        }
        
        //Start game
        FourAceGame.instance.delegate = self;
        FourAceGame.instance.startGame()
        
    }
    
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        self.constantScoreLabel.text = "Score".localized+" \(FourAceGame.instance.gameScore) (%)"
    }
    
    
    func cardsWillDealToStacks(cards: [Card], cardStacks: [CardStack]) {
        
        for stack in cardStacks {
            if(stack.size()>0){
                var cardTop = stack.peek()
                var cardTopNode:CardNode? = getCardNode(cardTop!)
                cardTopNode?.userInteractionEnabled = false
            }
        }
        
    }
    
    
    func cardsDidDealToStacks(cards: [Card],cardStacks:[CardStack]) {
        
        
        for card in cards {
            
            var cardNode:CardNode = CardNode(imageNamed: "\(card.suit)_\(card.value)",card: card,
                width:Constants.cardWidth,height:Constants.cardHeight);
            
            cardNode.delegate = self
            cardNode.position = Constants.constantDeckPosition
            cardNode.zPosition = Constants.maxZIndex
            cardNode.userInteractionEnabled = false
            addChild(cardNode)
            
            //except last one
            let cardSizeInStack:CGFloat = CGFloat(cardStacks[card.stackIndex].size()-1);
            let cardYPosition:CGFloat = Constants.stacksY - cardSizeInStack * Constants.cardHeight / 3;
            var destinationPosition:CGPoint = CGPointMake(Constants.stacksXPositions[card.stackIndex],cardYPosition)
            
            let actionMove = SKAction.moveTo(destinationPosition,duration:0.70);
            
            cardNode.runAction(actionMove, completion: { () -> Void in
                
                cardNode.userInteractionEnabled = true
                cardNode.zPosition = cardSizeInStack+Constants.cardStartZIndex
                cardNode.positionInStack = destinationPosition;
                
                self.deckButton.userInteractionEnabled = true;
            })
        }
        
    }
    
    
    func cardDidMoveFromStackToOtherStack(card: Card, fromCardStack: CardStack, toCardStack: CardStack) {
        
        if(fromCardStack.size()>0){
            var cardTop = fromCardStack.peek();
            var cardTopNode:CardNode? = getCardNode(cardTop!)
            cardTopNode?.userInteractionEnabled = true
        }
        
    }
    
    
    func cardWillPopToStack(card: Card, cardStack: CardStack) {
        
    }
    
    func cardDidPopToStack(card: Card, cardStack: CardStack) {
        
        
        if let unlockedCard = cardStack.peek() {
            var unlockedCardNode = getCardNode(unlockedCard)
            unlockedCardNode?.userInteractionEnabled = true
        }
        
    }
    
    func gameScoreDidChange() {
        
        //println("Current game score:\(FourAceGame.instance.gameScore)")
        
    }
    
    func deckDidEmpty() {
        
        deckButton.userInteractionEnabled = false;
        deckButton.alpha = 0;
        
    }
    
    func gameDidOver() {
    
        println("Game over!");
        // Delay 1 seconds
        
        performAfterDelay(afterDelay: 1, {
            self.gameOverAlertView.message = String(format:"game_over_message".localized,"\(FourAceGame.instance.gameScore)");
            self.gameOverAlertView.show({
                self.resetGame()
            },cancelCallback:{});
        })
      

        
    }
    
    func cardNodeDidDoubleTapped(cardNode: CardNode) {
        
        var selectedCard=cardNode.card;
        var result = FourAceGame.instance.isCardRemovableFromStack(stackIndex: selectedCard.stackIndex)
        
        if result {
            
            FourAceGame.instance.removeCardFromStack(stackIndex: selectedCard.stackIndex)
            
            cardNode.zPosition = Constants.maxZIndex;
            let moveTo = SKAction.moveTo(Constants.trashPosition, duration: 0.4);
            //let fadeOut=SKAction.fadeOutWithDuration(0.5);
            let sequenceAction = SKAction.sequence([moveTo]);
            cardNode.runAction(sequenceAction,completion: {()-> Void in
                //cardNode.removeFromParent()
                cardNode.zPosition = self.cardZpositionInTrash++;
            })
            
        } else {
            
            cardNode.userInteractionEnabled = true
            
            let moveTo = SKAction.moveTo(cardNode.positionInStack, duration:0.2)
            let dropDown = SKAction.scaleTo(1.0, duration: 0.2)
            let groupAction = SKAction.group([dropDown,moveTo])
            
            cardNode.runAction(groupAction,completion:{ () -> Void in
                if(cardNode.card.stackIndex != -1){
                    let cardSizeInStack:CGFloat=CGFloat(FourAceGame.instance.getStackSize(cardNode.card.stackIndex)-1);
                    cardNode.zPosition=Constants.cardStartZIndex + cardSizeInStack;
                }
            })
        }
        
    }
    
    /*
    *
    * Called when a card dropped
    *
    */
    func cardDidDropped(cardNode: CardNode) {
        
        var removable:Bool = false;
        
        if(isCardNodeIntersectWithRect(cardNode, rect: trashRect)){
            
            removable=FourAceGame.instance.isCardRemovableFromStack(stackIndex: cardNode.card.stackIndex)
           
            if removable {
                
                cardNode.userInteractionEnabled = false;
                FourAceGame.instance.removeCardFromStack(stackIndex: cardNode.card.stackIndex)
            
                let moveTo = SKAction.moveTo(Constants.trashPosition,duration:0.2);
                let dropDown = SKAction.scaleTo(1.0, duration: 0.2)
                //let fadeOut=SKAction.fadeOutWithDuration(1)
                let groupAction=SKAction.group([moveTo,dropDown]);
                
                cardNode.runAction(groupAction,completion: {()-> Void in
                    //cardNode.removeFromParent()
                    cardNode.zPosition = self.cardZpositionInTrash++;
                })
                
            } else {
                
                let moveTo = SKAction.moveTo(cardNode.positionInStack, duration:0.2)
                let dropDown = SKAction.scaleTo(1.0, duration: 0.2)
                let groupAction = SKAction.group([dropDown,moveTo])
                
                cardNode.runAction(groupAction,completion:{ () -> Void in
                    if(cardNode.card.stackIndex != -1){
                        let cardSizeInStack:CGFloat=CGFloat(FourAceGame.instance.getStackSize(cardNode.card.stackIndex)-1);
                        cardNode.zPosition=Constants.cardStartZIndex + cardSizeInStack;
                    }
                })
            }
            
        } else {
            
            var movable:Bool=false;
            
            for var i:Int=0;i<stackRects.count;i++ {
                
                if(isCardNodeIntersectWithRect(cardNode, rect: stackRects[i])){
                    var stackIndex = cardNode.card.stackIndex;
                    if(stackIndex != -1){
                        movable=FourAceGame.instance.isCardMovableFromStackToOtherStack(stackIndex: stackIndex, otherStackIndex: i);
                        if(movable){
                            FourAceGame.instance.moveCardFromStackToOtherStack(stackIndex: stackIndex, otherStackIndex: i)
                            cardNode.positionInStack=CGPointMake(Constants.stacksXPositions[i],Constants.stacksY)
                            //card size in stack except last one
                            let cardSizeInStack:CGFloat=CGFloat(FourAceGame.instance.getStackSize(i)-1);
                            cardNode.zPosition=Constants.cardStartZIndex + cardSizeInStack;
                        }
                    }
                    break
                }
            }
            let moveTo = SKAction.moveTo(cardNode.positionInStack, duration:0.2)
            let dropDown = SKAction.scaleTo(1.0, duration: 0.2)
            let groupAction = SKAction.group([dropDown,moveTo])
            
            cardNode.runAction(groupAction,completion:{ () -> Void in
                if(!movable){
                    if(cardNode.card.stackIndex != -1){
                        let cardSizeInStack:CGFloat=CGFloat(FourAceGame.instance.getStackSize(cardNode.card.stackIndex)-1);
                        cardNode.zPosition=Constants.cardStartZIndex + cardSizeInStack;
                    }
                }
            })
            
        }
        
    }
    
    

    func buttonNodeDidTapped(buttonNode: ButtonNode) {
        
        if(buttonNode===deckButton){
            FourAceGame.instance.dealCardsToStacks()
            deckButton.userInteractionEnabled = false
        }
        
        if(buttonNode==restartButton){
            
            self.restartAlertView.show({
                self.resetGame();
                },
                cancelCallback:{});
            
        }
        
        if(buttonNode==infoButton){
            self.infoAlertView.show({},cancelCallback:nil);
        }
        
    }
    
    
    private func getCardNode(card:Card)->CardNode? {
        
        var onlyCardNodes = self.children.filter{$0 is CardNode} as! Array<CardNode>;
        var resultCardNode:CardNode?;
        
        for cardNode in onlyCardNodes {
            if(card == cardNode.card){
                resultCardNode = cardNode
                break
            }
            
        }
        return resultCardNode
    }
    
    
    private func resetGame() {
        
        var cardNodes = self.children.filter{$0 is CardNode} as! Array<CardNode>;
        
        for cardNode in cardNodes {
            cardNode.removeFromParent();
        }
        
        FourAceGame.instance.resetGame();
        FourAceGame.instance.startGame();
        
        deckButton.alpha = 100;
        
    }
    
    
    
    private func isCardNodeIntersectWithRect(cardNode:CardNode,rect:CGRect)->Bool {
        
        var result = false;
        var centerPosition = CGPointMake(cardNode.position.x + Constants.cardWidth/2,cardNode.position.y + Constants.cardHeight/2);
        result = rect.contains(centerPosition)
        return result;
        
    }
    
}












