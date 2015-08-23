//
//  Util.swift
//  FortuneTeller
//
//  Created by basar cetinkaya on 30/07/14.
//  Copyright (c) 2014 basar cetinkaya. All rights reserved.
//

import SpriteKit



/* Global Functions */


func log(logMessage:String,functionName:String = __FUNCTION__){
    println("\(functionName): \(logMessage)");
}



func performAfterDelay(afterDelay delay:NSTimeInterval, block:() -> Void){
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), block)
}



/* Extensions */

extension Array {
    

    mutating func shuffle(){
        
        for var i=0;i<count;i++ {
            sort { (_,_) in arc4random() < arc4random() }
        }
        
    }

}

extension String {
    
    var localized:String {
        get{
            return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "");
        }
    }
    
    
    func localizedWithComment(comment:String)->String {
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: comment);
    }
}



class Util {
    
    static func isIPhone4OrLess()->Bool {
        
        var result:Bool = false;
        
        if UIScreen.mainScreen().bounds.height < 568.0 {
            result = true;
        }
        
        return result;
    }
    
    
    
}