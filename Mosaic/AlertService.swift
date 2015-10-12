import UIKit
import Foundation

class AlertService {

    class func createDefaultAlert(title: String, message: String) -> UIAlertController {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment:"AlertActionOK"), style: .Default, handler: nil)
        alertController.addAction(okAction)
        
        return alertController
    }
    
}
