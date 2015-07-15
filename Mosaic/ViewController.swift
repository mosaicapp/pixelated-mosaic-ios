import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request(.GET, URLString: "http://localhost:3333/mails?q=tag%3A%22inbox%22&p=1&w=25")
            .responseJSON(completionHandler: { (request, response, json, error) -> Void in
                print(json)
        })
    }
}

