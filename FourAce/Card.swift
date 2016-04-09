//
//  Card.swift
//  FortuneTeller
//
//  Created by basar cetinkaya on 30/07/14.
//  Copyright (c) 2014 basar cetinkaya. All rights reserved.
//

import Foundation


enum CardSuit:Int,CustomStringConvertible {
    
    case Spades,Hearths,Diamonds,Clubs
    
    static let allValues = [Spades,Hearths,Diamonds,Clubs]
    
    var description:String {
        switch self {
        case .Spades:
            return "spades"
        case .Hearths:
            return "hearts"
        case .Diamonds:
            return "diamonds"
        case .Clubs:
            return "clubs"
        }
    }
}

enum CardValue : Int,CustomStringConvertible {
    
    case Ace = 1,Two,Three,Four,Five,Six,Seven,Eight,Nine,Ten,Jack,Queen,King
    
    static let allValues = [Ace,Two,Three,Four,Five,Six,Seven,Eight,Nine,Ten,Jack,Queen,King]
    
    var description:String {
        switch self {
        case .Ace:
            return "a"
        case .Two:
            return "2"
        case .Three:
            return "3"
        case .Four:
            return "4"
        case .Five:
            return "5"
        case .Six:
            return "6"
        case .Seven:
            return "7"
        case .Eight:
            return "8"
        case .Nine:
            return "9"
        case .Ten:
            return "10"
        case .Jack:
            return "j"
        case .Queen:
            return "q"
        case .King:
            return "k"
        }
    }
}

func < (left:CardValue,right:CardValue)->Bool {
    
    if(right==CardValue.Ace){
        return true
    }
    
    if(left == CardValue.Ace){
        return false
    }
    
    return left.rawValue < right.rawValue
}



func == (left:Card,right:Card)->Bool {
    
    return left.suit==right.suit && left.value == right.value
    
}

func < (left:Card,right:Card)-> Bool {
    
    if(left.suit != right.suit){
        return false
    }
    return left.value < right.value
}


class Card:CustomStringConvertible,Equatable,Comparable {
    
    let value:CardValue
    let suit:CardSuit
    var stackIndex:Int = -1
    
    init(value:CardValue,suit:CardSuit){
        self.value = value
        self.suit = suit
    }
    
    var description:String {
        return "[\(self.value.description)-\(self.suit.description)]"
    }
    
    
    
}
