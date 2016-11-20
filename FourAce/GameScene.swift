//
//  GameScene.swift
//  FourAce
//
//  Created by basar cetinkaya on 30/07/14.
//  Copyright (c) 2014 basar cetinkaya. All rights reserved.
//

import SpriteKit


class GameScene: SKScene, FourAceGameDelegate, CardNodeDelegate, ButtonNodeDelegate {
    
    
    var viewController:UIViewController;
    var restartAlertView:AlertView;
    var gameOverAlertView:AlertView;
    var infoAlertView:AlertView;
    
    let deckButton:ButtonNode;
    let restartButton:ButtonNode;
    let infoButton:ButtonNode;
    
    
    let backgroundNode: SKSpriteNode;
    let constantScoreLabel:SKLabelNode;
    let timerLabel:SKLabelNode;
    
    var stackRects:[CGRect]=[CGRect]();
    var trashRect:CGRect = CGRect(x: Constants.trashPosition.x, y: Constants.trashPosition.y, width: Constants.trashWidth, height: Constants.trashHeight);
    
    var cardZpositionInTrash:CGFloat = 5;
    var lastCardNodeInTrash: SKSpriteNode? = nil;
    
    let trashHighlightName = "trash_highlight";
    let stackHighlightName = "stack_highlight";
    
    var gameTimer = Timer()
    var gameTimeCounter = 0;
    
    
    init(size:CGSize,viewController:UIViewController) {
        
        //background
        backgroundNode = SKSpriteNode(imageNamed: "green_background");
        restartButton = ButtonNode(imageNamed: "restart_button", width:Constants.restartButtonWidth, height: Constants.restartButtonHeight)
        infoButton = ButtonNode(imageNamed: "info_button", width:Constants.infoButtonWidth, height: Constants.infoButtonHeight)
        deckButton = ButtonNode(imageNamed: "red_deck", width: Constants.deckWidth, height: Constants.cardHeight)
        
        constantScoreLabel = SKLabelNode();
        timerLabel = SKLabelNode();
        
        self.viewController = viewController;
        
        self.restartAlertView = AlertView(title:"Warning".localized,message:"Restart game?".localized,viewController:self.viewController);
        self.gameOverAlertView = AlertView(title:"Game Over!".localized,message:"".localized,viewController:self.viewController);
        self.infoAlertView = AlertView(title:"how_to_play".localized,message:"how_to_play_instructions".localized,viewController:self.viewController);
        
    
        super.init(size: size)
        
        for i:Int in 0 ..< 4 {
            stackRects.insert(CGRect(x: Constants.stacksXPositions[i], y: Constants.stacksY, width: Constants.cardWidth, height: Constants.cardHeight), at: i)
        }
    
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        backgroundNode.position=CGPoint(x: self.size.width/2, y: self.size.height/2);
        backgroundNode.zPosition = -1;
        addChild(backgroundNode)
        
        constantScoreLabel.position = Constants.scoreLabelPosition;
        constantScoreLabel.fontName = "Chalkduster";
        constantScoreLabel.fontSize = 14;
        constantScoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center;
        constantScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left;
        constantScoreLabel.alpha = 0.5;
        
        addChild(constantScoreLabel)
        
        timerLabel.position = Constants.timerLabelPosition;
        timerLabel.fontName = "Arial";
        timerLabel.fontSize = 14;
        timerLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center;
        timerLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left;
        timerLabel.alpha = 0.5;
        
        addChild(timerLabel)
        
        let deckNodePlaceHolder = SKSpriteNode(imageNamed: "card_place_holder");
        deckNodePlaceHolder.size = CGSize(width: Constants.deckWidth + Constants.placeHolderMargin,
                                          height: Constants.deckHeight + Constants.placeHolderMargin)
        deckNodePlaceHolder.position = Constants.constantDeckPosition;
        deckNodePlaceHolder.zPosition = 0;
        addChild(deckNodePlaceHolder);
        
        let trashNode = SKSpriteNode(imageNamed: "card_place_holder");
        trashNode.size = CGSize(width: Constants.trashWidth + Constants.placeHolderMargin,
                                height: Constants.trashHeight + Constants.placeHolderMargin);
        trashNode.zPosition = 0;
        trashNode.position = Constants.trashPosition;
        addChild(trashNode)
        
        deckButton.position = Constants.constantDeckPosition
        deckButton.delegate = self
        deckButton.zPosition = 1;
        addChild(deckButton)
        
        restartButton.position = Constants.restartButtonPosition
        restartButton.delegate = self
        restartButton.zPosition = 0;
        addChild(restartButton)
        
        
        infoButton.position = Constants.infoButtonPosition
        infoButton.delegate = self
        infoButton.zPosition = 0;
        addChild(infoButton)
        
        for i:Int in 0 ..< 4 {
            let placeHolder = SKSpriteNode(imageNamed: "card_place_holder");
            placeHolder.position = CGPoint(x: Constants.stacksXPositions[i], y: Constants.stacksY)
            placeHolder.size = CGSize(width:Constants.cardWidth + Constants.placeHolderMargin,
                                      height:Constants.cardHeight + Constants.placeHolderMargin);
            self.addChild(placeHolder)
        }
        
        //Start game
        FourAceGame.instance.delegate = self;
        FourAceGame.instance.startGame()
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        showMakeWishMessage()
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        self.constantScoreLabel.text = "Score".localized+" \(FourAceGame.instance.gameScore) (%)"
    }
    
    
    func timerAction(){
        
        gameTimeCounter = gameTimeCounter + 1;
        let minutes = Int(gameTimeCounter)/60 % 60
        let seconds = Int(gameTimeCounter) % 60
        let formattedTime = String(format:"%02i:%02i",minutes,seconds)
        self.timerLabel.text = formattedTime
        
    }
    
    
    func cardsWillDealToStacks(_ cards: [Card], cardStacks: [CardStack]) {
        
        for stack in cardStacks {
            if(stack.size()>0){
                let cardTop = stack.peek()
                let cardTopNode:CardNode? = getCardNode(cardTop!)
                cardTopNode?.isUserInteractionEnabled = false
            }
        }
        
    }
    
    
    func cardsDidDealToStacks(_ cards: [Card],cardStacks:[CardStack]) {
        
        
        for card in cards {
            
            let cardNode:CardNode = CardNode(imageNamed: "\(card.suit)_\(card.value)",card: card,
                                             width:Constants.cardWidth,height:Constants.cardHeight);
            
            cardNode.delegate = self
            cardNode.position = Constants.constantDeckPosition
            cardNode.zPosition = Constants.maxZIndex
            cardNode.isUserInteractionEnabled = false
            addChild(cardNode)
            
            //except last one
            let cardSizeInStack:CGFloat = CGFloat(cardStacks[card.stackIndex].size()-1);
            let cardYPosition:CGFloat = Constants.stacksY - cardSizeInStack * Constants.cardHeight / 3;
            let destinationPosition:CGPoint = CGPoint(x: Constants.stacksXPositions[card.stackIndex],y: cardYPosition)
            
            let actionMove = SKAction.move(to: destinationPosition,duration:0.70);
            
            cardNode.run(actionMove, completion: { () -> Void in
                
                cardNode.isUserInteractionEnabled = true
                cardNode.zPosition = cardSizeInStack+Constants.cardStartZIndex
                cardNode.positionInStack = destinationPosition;
                
                self.deckButton.isUserInteractionEnabled = true;
            })
        }
        
    }
    
    
    func cardDidMoveFromStackToOtherStack(_ card: Card, fromCardStack: CardStack, toCardStack: CardStack) {
        
        if(fromCardStack.size()>0){
            let cardTop = fromCardStack.peek();
            let cardTopNode:CardNode? = getCardNode(cardTop!)
            cardTopNode?.isUserInteractionEnabled = true
        }
        
    }
    
    
    func cardWillPopToStack(_ card: Card, cardStack: CardStack) {
        
    }
    
    func cardDidPopToStack(_ card: Card, cardStack: CardStack) {
        
        
        if let unlockedCard = cardStack.peek() {
            let unlockedCardNode = getCardNode(unlockedCard)
            unlockedCardNode?.isUserInteractionEnabled = true
        }
        
    }
    
    func gameScoreDidChange() {
        
        //println("Current game score:\(FourAceGame.instance.gameScore)")
        
    }
    
    func deckDidEmpty() {
        
        deckButton.isUserInteractionEnabled = false;
        deckButton.alpha = 0;
        
    }
    
    func gameDidOver() {
        
        // Delay 1 seconds
        performAfterDelay(afterDelay: 1, block: {
            self.gameTimer.invalidate()
            self.gameOverAlertView.message = String(format:"game_over_message".localized,"\(FourAceGame.instance.gameScore)");
            self.gameOverAlertView.show({
                self.resetGame()
            },cancelCallback:{});
        })
        
        
        
    }
    
    
    func showTrashHiglight() {
        
 
        if(self.childNode(withName: trashHighlightName) == nil){
            
            let highlightFrameNode = SKSpriteNode(imageNamed: "highlight_frame");
            highlightFrameNode.size = CGSize(width: Constants.trashWidth + Constants.placeHolderMargin + 10,
                                             height: Constants.trashHeight + Constants.placeHolderMargin + 10)
            highlightFrameNode.zPosition = 0;
            highlightFrameNode.position = Constants.trashPosition;
            highlightFrameNode.name = trashHighlightName
            highlightFrameNode.alpha = 0;
            addChild(highlightFrameNode);
            
            let groupAction = SKAction.repeatForever(SKAction.sequence([SKAction.fadeIn(withDuration: 0.5),SKAction.fadeOut(withDuration: 0.5),SKAction.wait(forDuration: 0.25)]));
            highlightFrameNode.run(groupAction)
        }
        
    }
    
    func hideTrashHighlight() {
          self.childNode(withName: trashHighlightName)?.removeFromParent()
    }
    
    
    func showStackHighlight(_ index:Int) {
        
        if(self.childNode(withName: stackHighlightName + "_\(index)") == nil){
            
            let highlightFrameNode = SKSpriteNode(imageNamed: "highlight_frame");
            highlightFrameNode.position = CGPoint(x: Constants.stacksXPositions[index], y: Constants.stacksY)
            highlightFrameNode.size = CGSize(width:Constants.cardWidth + Constants.placeHolderMargin + 10,
                                             height:Constants.cardHeight + Constants.placeHolderMargin + 10);
            highlightFrameNode.zPosition = 0;
            highlightFrameNode.name = stackHighlightName + "_\(index)";
            highlightFrameNode.alpha = 0;
            addChild(highlightFrameNode);
            
            let groupAction = SKAction.repeatForever(SKAction.sequence([SKAction.fadeIn(withDuration: 0.5),SKAction.fadeOut(withDuration: 0.5),SKAction.wait(forDuration: 0.25)]));
            highlightFrameNode.run(groupAction)
        }
    }
    
    func hideStackHightLight() {
        
        for i:Int in 0 ..< stackRects.count {
            self.childNode(withName: stackHighlightName + "_\(i)")?.removeFromParent()
        }
        
    }

    
    func showMakeWishMessage() {
        
        
        let wishMessage = SKLabelNode()
        wishMessage.text = "make_a_wish".localized
        wishMessage.fontColor = UIColor.white
        wishMessage.position = CGPoint(x:self.middlePoint.x,y:-100)
        wishMessage.fontName = "Chalkduster"
        
        let moveTo = SKAction.moveTo(y: self.middlePoint.y, duration: 1)
        let fadeOut=SKAction.fadeOut(withDuration:2.5)
        let groupAction=SKAction.group([moveTo,fadeOut]);
        
        self.addChild(wishMessage)
        
        wishMessage.run(groupAction,completion: {()-> Void in
          wishMessage.removeFromParent()
        })
        
        
    }
    
    func cardMoving(_ cardNode: CardNode) {
        
        let removable=FourAceGame.instance.isCardRemovableFromStack(stackIndex: cardNode.card.stackIndex)
        if removable {
            showTrashHiglight()
            return
        }
        
        
        for i:Int in 0 ..< stackRects.count {
            if i == cardNode.card.stackIndex{
                continue
            }
            let movable = FourAceGame.instance.isCardMovableFromStackToOtherStack(stackIndex: cardNode.card.stackIndex, otherStackIndex: i)
            if movable {
                showStackHighlight(i)
            }
        }
    }
    
    func cardNodeDidDoubleTapped(_ cardNode: CardNode) {

    
        let selectedCard=cardNode.card;
        let result = FourAceGame.instance.isCardRemovableFromStack(stackIndex: selectedCard.stackIndex)
        
        if result {
            
            let _ = FourAceGame.instance.removeCardFromStack(stackIndex: selectedCard.stackIndex)
            
            cardNode.zPosition = Constants.maxZIndex;
            let moveTo = SKAction.move(to: Constants.trashPosition, duration: 0.4);
            //let fadeOut=SKAction.fadeOutWithDuration(0.5);
            let sequenceAction = SKAction.sequence([moveTo]);
            cardNode.run(sequenceAction,completion: {()-> Void in
                
                self.lastCardNodeInTrash?.removeFromParent();
                self.lastCardNodeInTrash = cardNode;
                self.cardZpositionInTrash += 1;
                cardNode.zPosition = self.cardZpositionInTrash
                cardNode.alpha = 0.5
            })
            
        } else {
            
            cardNode.isUserInteractionEnabled = true
            
            let moveTo = SKAction.move(to: cardNode.positionInStack, duration:0.2)
            let dropDown = SKAction.scale(to: 1.0, duration: 0.2)
            let groupAction = SKAction.group([dropDown,moveTo])
            
            cardNode.run(groupAction,completion:{ () -> Void in
                if(cardNode.card.stackIndex != -1){
                    let cardSizeInStack:CGFloat=CGFloat(FourAceGame.instance.getStackSize(cardNode.card.stackIndex)-1);
                    cardNode.zPosition=Constants.cardStartZIndex + cardSizeInStack;
                }
            })
        }
        
        hideTrashHighlight()
        hideStackHightLight()
    }
    
    /*
     *
     * Called when a card dropped
     *
     */
    func cardDidDropped(_ cardNode: CardNode) {
    
        var removable:Bool = false;
        
        if(isCardNodeIntersectWithRect(cardNode, rect: trashRect)){
            
            removable=FourAceGame.instance.isCardRemovableFromStack(stackIndex: cardNode.card.stackIndex)
            
            if removable {
                
                cardNode.isUserInteractionEnabled = false;
                let _ = FourAceGame.instance.removeCardFromStack(stackIndex: cardNode.card.stackIndex)
                
                let moveTo = SKAction.move(to: Constants.trashPosition,duration:0.2);
                let dropDown = SKAction.scale(to: 1.0, duration: 0.2)
                //let fadeOut=SKAction.fadeOutWithDuration(1)
                let groupAction=SKAction.group([moveTo,dropDown]);
                
                cardNode.run(groupAction,completion: {()-> Void in
                    
                    self.lastCardNodeInTrash?.removeFromParent();
                    self.lastCardNodeInTrash = cardNode;
                    self.cardZpositionInTrash += 1
                    cardNode.zPosition = self.cardZpositionInTrash
                    cardNode.alpha = 0.5;
                })
                
            } else {
                
                let moveTo = SKAction.move(to: cardNode.positionInStack, duration:0.2)
                let dropDown = SKAction.scale(to: 1.0, duration: 0.2)
                let groupAction = SKAction.group([dropDown,moveTo])
                
                cardNode.run(groupAction,completion:{ () -> Void in
                    if(cardNode.card.stackIndex != -1){
                        let cardSizeInStack:CGFloat=CGFloat(FourAceGame.instance.getStackSize(cardNode.card.stackIndex)-1);
                        cardNode.zPosition=Constants.cardStartZIndex + cardSizeInStack;
                    }
                })
            }
            
        } else {
            
            var movable:Bool=false;
            
            for i:Int in 0 ..< stackRects.count {
                
                if(isCardNodeIntersectWithRect(cardNode, rect: stackRects[i])){
                    let stackIndex = cardNode.card.stackIndex;
                    if(stackIndex != -1){
                        movable=FourAceGame.instance.isCardMovableFromStackToOtherStack(stackIndex: stackIndex, otherStackIndex: i);
                        if(movable){
                            let _ = FourAceGame.instance.moveCardFromStackToOtherStack(stackIndex: stackIndex, otherStackIndex: i)
                            cardNode.positionInStack=CGPoint(x: Constants.stacksXPositions[i],y: Constants.stacksY)
                            //card size in stack except last one
                            let cardSizeInStack:CGFloat=CGFloat(FourAceGame.instance.getStackSize(i)-1);
                            cardNode.zPosition=Constants.cardStartZIndex + cardSizeInStack;
                        }
                    }
                    break
                }
            }
            let moveTo = SKAction.move(to: cardNode.positionInStack, duration:0.2)
            let dropDown = SKAction.scale(to: 1.0, duration: 0.2)
            let groupAction = SKAction.group([dropDown,moveTo])
            
            cardNode.run(groupAction,completion:{ () -> Void in
                if(!movable){
                    if(cardNode.card.stackIndex != -1){
                        let cardSizeInStack:CGFloat=CGFloat(FourAceGame.instance.getStackSize(cardNode.card.stackIndex)-1);
                        cardNode.zPosition=Constants.cardStartZIndex + cardSizeInStack;
                    }
                }
            })
            
        }
        
        hideTrashHighlight()
        hideStackHightLight()
    }
    
  

    
    func buttonNodeDidTapped(_ buttonNode: ButtonNode) {
        
   
        if(buttonNode===deckButton){
            FourAceGame.instance.dealCardsToStacks()
            deckButton.isUserInteractionEnabled = false
        }
        
        if(buttonNode==restartButton){
            
            self.restartAlertView.show({
                self.resetGame()
            },cancelCallback:{
            });
            
        }
        
        if(buttonNode==infoButton){
            self.infoAlertView.show({},cancelCallback:nil);
        }
        
    }
    
    
    fileprivate func getCardNode(_ card:Card)->CardNode? {
        
        let onlyCardNodes = self.children.filter{$0 is CardNode} as! Array<CardNode>;
        var resultCardNode:CardNode?;
        
        for cardNode in onlyCardNodes {
            if(card == cardNode.card){
                resultCardNode = cardNode
                break
            }
            
        }
        return resultCardNode
    }
    
    
    fileprivate func resetGame() {
        
        let cardNodes = self.children.filter{$0 is CardNode} as! Array<CardNode>;
        
        for cardNode in cardNodes {
            cardNode.removeFromParent();
        }
    
        deckButton.alpha = 100;
        timerLabel.text = String("00:00")
        gameTimeCounter = 0;
        gameTimer.invalidate()
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        FourAceGame.instance.resetGame();
        FourAceGame.instance.startGame();
        
        showMakeWishMessage()
        
    }
    
    
    
    fileprivate func isCardNodeIntersectWithRect(_ cardNode:CardNode,rect:CGRect)->Bool {
        
        var result = false;
        let centerPosition = CGPoint(x: cardNode.position.x + Constants.cardWidth/2,y: cardNode.position.y + Constants.cardHeight/2);
        result = rect.contains(centerPosition)
        return result;
        
    }
    
}












