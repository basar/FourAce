//
//  Util.swift
//  FortuneTeller
//
//  Created by basar cetinkaya on 30/07/14.
//  Copyright (c) 2014 basar cetinkaya. All rights reserved.
//

import SpriteKit



/* Global Functions */


func log(_ logMessage:String,functionName:String = #function){
    print("\(functionName): \(logMessage)");
}



func performAfterDelay(afterDelay delay:TimeInterval, block:@escaping () -> Void){
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: block)
}



/* Extensions */

extension Array {
    

    mutating func shuffle(){
        
        for _ in 0 ..< count {
            sort { (_,_) in arc4random() < arc4random() }
        }
        
    }

}

extension SKScene {
    
    
    var middlePoint:CGPoint {
        get{
            return CGPoint(x:self.size.width/2.0,y:self.size.height/2.0)
        }
    }
    
}

extension String {
    
    var localized:String {
        get{
            return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "");
        }
    }
    
    
    func localizedWithComment(_ comment:String)->String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: comment);
    }
}



class Util {
    
    static func isIPhone4OrLess()->Bool {
        
        var result:Bool = false;
        
        if UIScreen.main.bounds.height < 568.0 {
            result = true;
        }
        
        return result;
    }
    
    
    static func isFirstStartOfGame()->Bool {
        return !UserDefaults.standard.bool(forKey: Constants.firstStartKey)
    }
    
    static func changeGameState(_ value:Bool)->Void {
        UserDefaults.standard.set(value, forKey: Constants.firstStartKey)
    }
    
}
