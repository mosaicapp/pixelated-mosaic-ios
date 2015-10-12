//
//  AlertService.swift
//  Mosaic
//
//  Created by Ben Hartmann on 27.08.15.
//  Copyright © 2015 Pixelated. All rights reserved.
//

import UIKit
import Foundation


enum StandardError : String {
    case DataError
    case ConnectionError
}


class AlertService: NSObject {

    class func createDefaultAlert(title: String, message: String) -> UIAlertController? {
        
        if (title == "" || message == "") {
            return nil
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: NSLocalizedString("OK",comment:"AlertActionOK"), style: .Default) { (action) in
        }
        alertController.addAction(OKAction)
        
        return alertController
    }
    
}
