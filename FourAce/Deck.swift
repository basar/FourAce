//
//  Deck.swift
//  FortuneTeller
//
//  Created by basar cetinkaya on 30/07/14.
//  Copyright (c) 2014 basar cetinkaya. All rights reserved.
//

import Foundation



protocol DeckProtocol {
    
    func shuffle()
    
    func dealCard()->Card?
    
    func dealCards(count:Int)->[Card]?
    
    func cardsLeft()->Int
    
}


class Deck:DeckProtocol,CustomStringConvertible {
    
    var cards:[Card]
    
    init(){
        
        self.cards = [Card]()
        
        for suit in CardSuit.allValues {
            for value in CardValue.allValues {
                let card:Card = Card(value: value, suit: suit)
                cards.append(card)
            }
        }
    }
    
    var description:String {
        get {
            var desc:String = String()
            desc = "["
            for card in self.cards {
                desc = desc + card.description;
            }
            desc = desc + "]"
            return desc
        }
    }
    
    
    func shuffle()  {
        self.cards.shuffle()
    }
    
    func dealCard() -> Card? {
        if(cards.isEmpty){
            return nil
        }
        return cards.removeAtIndex(0)
    }
    
    func dealCards(count: Int) -> [Card]? {
        
        if(count>cards.count){
            return nil
        }
        
        var result=[Card]()
        for var i=0;i<count;i++ {
            result.append(dealCard()!)
        }
        return result
    }
        
    
    func cardsLeft() -> Int {
        return self.cards.count
    }
    
    var currentCount:Int {
        get {
            return cards.count
        }
    }
    
    
}