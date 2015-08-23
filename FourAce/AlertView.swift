//
//  AlertView.swift
//  FortuneTeller
//
//  Created by basar cetinkaya on 08/08/15.
//  Copyright (c) 2015 basar cetinkaya. All rights reserved.
//

import UIKit


class AlertView : NSObject, UIAlertViewDelegate {
    
    
    private var okCallback:(()->(Void))?
    
    private var cancelCallback:(()->Void)?
    
    var title:String;
    var message:String;
    
    private var viewController:UIViewController;
   
    
    init(title:String,message:String,viewController:UIViewController){
        
        self.title=title;
        self.message = message;
        self.viewController = viewController;
        super.init();
        
    }
    
    
    func show(okCallback:(()->Void)?,cancelCallback:(()->Void)?) {
    
        self.okCallback = okCallback;
        self.cancelCallback = cancelCallback;
        
        if let ios8Alert: AnyClass = NSClassFromString("UIAlertController") {
            
            let alert: UIAlertController = UIAlertController(title: self.title, message: self.message, preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: "Ok".localized, style: .Default, handler: { action in
                self.okCallback?()
            }))
            
            if self.cancelCallback != nil {
                alert.addAction(UIAlertAction(title: "Cancel".localized, style: .Default, handler: {action in
                    self.cancelCallback?()
                }))
            }
            
            viewController.presentViewController(alert, animated: true, completion: nil)
            
        } else { // iOS 7
            
            let alert: UIAlertView = UIAlertView()
            alert.delegate = self
            
            alert.title = self.title
            alert.message = self.message
            alert.addButtonWithTitle("Ok".localized)
            if self.cancelCallback != nil {
                alert.addButtonWithTitle("Cancel".localized);
            }
            
            alert.show()
        }
    
    }
    
    
    
    func show(okCallback:(()->Void)){
        self.show(okCallback,cancelCallback:nil);
    }
    
    func show(){
        self.show(nil, cancelCallback: nil);
    }
    
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if(buttonIndex==0){
            self.okCallback?();
        }
        
        if(buttonIndex==1){
            self.cancelCallback?();
        }
        
    }
    
    
    
    
}