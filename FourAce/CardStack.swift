//
//  CardStack.swift
//  FortuneTeller
//
//  Created by basar cetinkaya on 12/07/15.
//  Copyright (c) 2015 basar cetinkaya. All rights reserved.
//

import Foundation


class CardStack:CustomStringConvertible {
    
    var cards:[Card]
    
    var index:Int
    
    init(index:Int){
        cards = [Card]()
        self.index = index;
    }
    
    func push(card:Card) {
        card.stackIndex = index
        cards.append(card)
    }
    
    var description:String {
        get {
            var desc = String()
            
            for var i=size()-1;i>=0;i-- {
                let card = cards[i]
                desc = desc + card.description
                if i != 0 {
                    desc = desc + "\n"
                }
            }
            
            return desc
        }
    }
    
    var isEmpty:Bool {
        get{
            return cards.isEmpty
        }
    }
    
    func pop()->Card {
        let card = cards.removeLast()
        card.stackIndex = -1
        return card
    }
    
    func peek()->Card? {
        if(size()==0){
            return nil
        }
        let card = cards[size()-1]
        return card
    }
    
    func size()->Int {
        return cards.count
    }
    
}