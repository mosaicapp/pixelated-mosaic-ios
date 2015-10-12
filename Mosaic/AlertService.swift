import UIKit
import Foundation

class AlertService {

    class func createDefaultAlert(title: String, message: String) -> UIAlertController {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment:"AlertActionOK"), style: .Default, handler: nil)
        alertController.addAction(okAction)
        
        return alertController
    }
    
    class func showConnectionErrorAlert(controller: UIViewController) -> Void {
        let alert = createDefaultAlert("Connection Error", message: "You are not connected to the internet");
        controller.presentViewController(alert, animated: true, completion: nil)
    }
    
    class func showDataErrorAlert(controller: UIViewController, message: String) -> Void {
        let alert = createDefaultAlert("Data Error", message: message);
        controller.presentViewController(alert, animated: true, completion: nil)
    }
    
}
