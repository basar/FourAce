//
//  Constants.swift
//  FortuneTeller
//
//  Created by basar cetinkaya on 08/08/15.
//  Copyright (c) 2015 basar cetinkaya. All rights reserved.
//

import UIKit





class Constants {

    
    
    static var cardWidth:CGFloat {
        get{
            if(Util.isIPhone4OrLess()){
                return 55
            }
            
            return 60;
        }
    }
    
    static var cardHeight:CGFloat{
        get{
            if(Util.isIPhone4OrLess()){
                return 65;
            }
            return 75;
        }
    }
    
    static var deckWidth:CGFloat {
        get{
            if Util.isIPhone4OrLess() {
                return 65
            }
            return 75;
        }
    }
    
    static var deckHeight:CGFloat {
        get{
            if Util.isIPhone4OrLess() {
                return 50;
            }
            return 75;
        }
    }
    
    
    
    static var constantDeckPosition:CGPoint {
        get{
            if Util.isIPhone4OrLess(){
                return CGPointMake(270, 425);
            }
            return CGPointMake(270, 490);
        }
    }
    
   
    static var restartButtonWidth:CGFloat {
        get{
            if Util.isIPhone4OrLess() {
                return 30
            }
            return 35
        }
    }
    
    static var restartButtonHeight:CGFloat {
        get{
            if Util.isIPhone4OrLess() {
                return 30
            }
            return 35
        }
    }
    
    static var restartButtonPosition:CGPoint {
        get{
            if Util.isIPhone4OrLess() {
                return CGPointMake(75, 440);
            }
            return CGPointMake(75, 520);
        }
    }
    
    static var infoButtonWidth:CGFloat {
        get{
            if Util.isIPhone4OrLess() {
                return 30
            }
            return 35
        }
    }
    
    static var infoButtonHeight:CGFloat {
        get{
            if Util.isIPhone4OrLess() {
                return 30
            }
            return 35
        }
    }
    
    static var infoButtonPosition:CGPoint {
        get{
            if Util.isIPhone4OrLess() {
                return CGPointMake(30, 440);
            }
            return CGPointMake(30, 520)
        }
    }
    
    
    static var stacksY:CGFloat {
        get{
            if Util.isIPhone4OrLess() {
                return 350;
            }
            return 390;
        }
    }
    
    static var stacksXPositions:[CGFloat] {
        get {
            if Util.isIPhone4OrLess() {
               return [40,120,200,280];
            }
            return [40,120,200,280];
        }
    }
    
    static var trashPosition:CGPoint {
        get{
            if Util.isIPhone4OrLess() {
                return CGPointMake(175, 425)
            }
            return CGPointMake(175, 490)
        }
    }
    
    static var trashWidth: CGFloat {
        get{
            if Util.isIPhone4OrLess() {
                return 50;
            }
            return 60;
        }
    }
    
    static var trashHeight: CGFloat {
        get{
            if Util.isIPhone4OrLess() {
                return 60;
            }
            return 75;
        }
    }
    
    
    static var scoreLabelPosition:CGPoint {
        get{
            if Util.isIPhone4OrLess() {
                return CGPointMake(15, 410);
            }
            return CGPointMake(15, 480);
        }
    }
    
    
    static let maxZIndex:CGFloat = 100;
    static let cardStartZIndex:CGFloat = 5;
    
    static let placeHolderMargin:CGFloat = 5;
    


}
