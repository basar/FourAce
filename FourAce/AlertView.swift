//
//  AlertView.swift
//  FortuneTeller
//
//  Created by basar cetinkaya on 08/08/15.
//  Copyright (c) 2015 basar cetinkaya. All rights reserved.
//

import UIKit


class AlertView : NSObject, UIAlertViewDelegate {
    
    
    fileprivate var okCallback:(()->(Void))?
    
    fileprivate var cancelCallback:(()->Void)?
    
    var title:String;
    var message:String;
    
    fileprivate var viewController:UIViewController;
   
    
    init(title:String,message:String,viewController:UIViewController){
        
        self.title=title;
        self.message = message;
        self.viewController = viewController;
        super.init();
        
    }
    
    
    func show(_ okCallback:(()->Void)?,cancelCallback:(()->Void)?) {
    
        self.okCallback = okCallback;
        self.cancelCallback = cancelCallback;
        
        if #available(iOS 8.0, *){
            
            let alert: UIAlertController = UIAlertController(title: self.title, message: self.message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok".localized, style: .default, handler: { action in
                self.okCallback?()
            }))
            
            if self.cancelCallback != nil {
                alert.addAction(UIAlertAction(title: "Cancel".localized, style: .default, handler: {action in
                    self.cancelCallback?()
                }))
            }
            
            viewController.present(alert, animated: true, completion: nil)
            
        } else { // iOS 7
            
            let alert: UIAlertView = UIAlertView()
            alert.delegate = self
            
            alert.title = self.title
            alert.message = self.message
            alert.addButton(withTitle: "Ok".localized)
            if self.cancelCallback != nil {
                alert.addButton(withTitle: "Cancel".localized);
            }
            
            alert.show()
        }
    
    }
    
    
    
    func show(_ okCallback:@escaping (()->Void)){
        self.show(okCallback,cancelCallback:nil);
    }
    
    func show(){
        self.show(nil, cancelCallback: nil);
    }
    
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        
        if(buttonIndex==0){
            self.okCallback?();
        }
        
        if(buttonIndex==1){
            self.cancelCallback?();
        }
        
    }
    
    
    
    
}
