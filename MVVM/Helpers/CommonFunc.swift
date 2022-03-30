//
//  CommonFunc.swift
//  MVVM
//
//  Created by Gulam Ali on 30/03/22.
//

import Foundation
import UIKit

class CommonFuncs: NSObject {
        
    // MARK: -  Alert with ok btn to dismiss
    class func AlertWithOK(msg:String,vc:UIViewController){
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        vc.present(alert, animated: true, completion: nil)
    }
    
}



