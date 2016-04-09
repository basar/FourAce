//
//  FortuneTellerGame.swift
//  FortuneTeller
//
//  Created by basar cetinkaya on 30/07/14.
//  Copyright (c) 2014 basar cetinkaya. All rights reserved.
//

import Foundation





protocol FourAceGameDelegate {
    
    func cardsWillDealToStacks(cards:[Card],cardStacks:[CardStack])
    
    func cardsDidDealToStacks(cards:[Card],cardStacks:[CardStack])
    
    func cardWillPopToStack(card:Card,cardStack:CardStack)
    
    func cardDidPopToStack(card:Card,cardStack:CardStack)
    
    func cardDidMoveFromStackToOtherStack(card:Card,fromCardStack:CardStack,toCardStack:CardStack)
    
    func gameScoreDidChange()
    
    func deckDidEmpty()
    
    func gameDidOver()
    
}

class FourAceGame:CustomStringConvertible {
    
    static let instance = FourAceGame()
    
    private var deck:Deck = Deck()
    
    private var stacks:[CardStack] = [CardStack(index:0),CardStack(index:1),CardStack(index:2),CardStack(index:3)]
    
    var delegate:FourAceGameDelegate?
    
    private init(){
        
    }

    func startGame(){
        deck.shuffle()
        dealCardsToStacks()
    }
    
    func resetGame(){
        deck = Deck()
        deck.shuffle()
        stacks = [CardStack(index:0),CardStack(index:1),CardStack(index:2),CardStack(index:3)]
    }
    
    func dealCardsToStacks(){
        
        if(deck.currentCount==0){
            print("Deck is empty!")
            return
        }
        
        var dealedCards:[Card] = [Card]()
        for i:Int in 0 ..< 4 {
            dealedCards.insert(deck.dealCard()!, atIndex:i)
        }
        
        delegate?.cardsWillDealToStacks(dealedCards, cardStacks: stacks)
       
        var index = 0
        for cardStack in stacks {
            cardStack.push(dealedCards[index])
            index+=1
        }
        
        delegate?.cardsDidDealToStacks(dealedCards,cardStacks: stacks)
        delegate?.gameScoreDidChange()
        if(deck.currentCount == 0){
            delegate?.deckDidEmpty()
        }
        controlWhetherGameOver()
        
    }
    
    
    func isCardMovableFromStackToOtherStack(stackIndex index:Int, otherStackIndex other:Int)->Bool {
        
        var result = true
        let stack = stacks[index]
        let otherStack=stacks[other]
        
        if stack.isEmpty || !otherStack.isEmpty {
            result = false
        }
        
        return result
    }
    
    
    func moveCardFromStackToOtherStack(stackIndex index:Int, otherStackIndex other:Int)->Card? {
        
        var moved:Card?
        
        if isCardMovableFromStackToOtherStack(stackIndex: index, otherStackIndex: other) {
            
            let fromStack:CardStack = stacks[index];
            let toStack:CardStack = stacks[other];
            moved = fromStack.pop()
            toStack.push(moved!)
            delegate?.cardDidMoveFromStackToOtherStack(moved!, fromCardStack: fromStack, toCardStack: toStack)
            if(moved?.value == .Ace){
                delegate?.gameScoreDidChange()
            }
            controlWhetherGameOver()
            
        }
        
        return moved
    }
    
    
    func isCardRemovableFromStack(stackIndex index:Int)->Bool {
        
        var result = false
        
        let stack = stacks[index]
        
        if stack.isEmpty {
            return result
        }
        
        let removed:Card? = stack.peek()
        
        for i:Int in 0 ..< stacks.count {
            
            if(i != index){
                let otherStack = stacks[i]
                if !otherStack.isEmpty {
                    let otherCard = otherStack.peek()
                    if(otherCard > removed){
                        result = true
                        break
                    }
                }
            }
        }
        
        return result
    }
    
    func removeCardFromStack(stackIndex index:Int) -> Card? {
        
        var removed:Card?
        
        
        if isCardRemovableFromStack(stackIndex:index) {
            let card = stacks[index].peek()
            delegate?.cardWillPopToStack(card!,cardStack:stacks[index])
            removed = stacks[index].pop()
            delegate?.cardDidPopToStack(card!,cardStack:stacks[index])
            delegate?.gameScoreDidChange();
            controlWhetherGameOver()
            
        }
        
        return removed
    }
    
    
    func getStackSize(stackIndex:Int) -> Int {
        return stacks[stackIndex].size();
    }
    
    func isAnyMoveExist() -> Bool {
        
        var result:Bool = true;
        var cardSuits = Set<CardSuit>()
        
        for stack:CardStack in stacks {
            
            let card = stack.peek();
            if(card == nil){
                break
            }
            cardSuits.insert(card!.suit)
        }
        
        if (cardSuits.count == 4) {
            result = false
        }
        
        return result;
    }
    
    private func controlWhetherGameOver() {
        
        if(deck.currentCount==0){
            let result = isAnyMoveExist()
            if (!result){
                delegate?.gameDidOver()
            }
        }
        
    }
    
    
    var description:String {
        get{
            var result:String = String()
            
            for i:Int in 0 ..< stacks.count {
                let stack = stacks[i]
                result = result + stack.description + "\n**************";
                if(i != stacks.count-1){
                    result = result + "\n";
                }
            }
            
            return result
        }
    }
    
    
    var gameScore:Int {
       
        get{
            var score:Int=0;
        
            for stack in stacks {
                var cards:[Card] = stack.cards;
                for i:Int in 0 ..< cards.count {
                    let card:Card=cards[i];
                    if(card.value == .Ace && i==0){
                        score=score+25;
                        continue
                    }
                    score = score - 1;
                }
                
            }
            
            if(score < -1){
                score = 0;
            }
            
            return score;
        }
    }
    
}