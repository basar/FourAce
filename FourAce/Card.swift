//
//  Card.swift
//  FortuneTeller
//
//  Created by basar cetinkaya on 30/07/14.
//  Copyright (c) 2014 basar cetinkaya. All rights reserved.
//

import Foundation


enum CardSuit:Int,CustomStringConvertible {
    
    case spades,hearths,diamonds,clubs
    
    static let allValues = [spades,hearths,diamonds,clubs]
    
    var description:String {
        switch self {
        case .spades:
            return "spades"
        case .hearths:
            return "hearts"
        case .diamonds:
            return "diamonds"
        case .clubs:
            return "clubs"
        }
    }
}

enum CardValue : Int,CustomStringConvertible {
    
    case ace = 1,two,three,four,five,six,seven,eight,nine,ten,jack,queen,king
    
    static let allValues = [ace,two,three,four,five,six,seven,eight,nine,ten,jack,queen,king]
    
    var description:String {
        switch self {
        case .ace:
            return "a"
        case .two:
            return "2"
        case .three:
            return "3"
        case .four:
            return "4"
        case .five:
            return "5"
        case .six:
            return "6"
        case .seven:
            return "7"
        case .eight:
            return "8"
        case .nine:
            return "9"
        case .ten:
            return "10"
        case .jack:
            return "j"
        case .queen:
            return "q"
        case .king:
            return "k"
        }
    }
}

func < (left:CardValue,right:CardValue)->Bool {
    
    if(right==CardValue.ace){
        return true
    }
    
    if(left == CardValue.ace){
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
