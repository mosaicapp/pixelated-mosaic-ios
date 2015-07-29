import UIKit
import Alamofire

class ViewController: UIViewController {
    
    let jsonParseService = JsonParseService()

    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request(.GET, "http://localhost:3333/mails",
                                parameters: ["q": "tag:inbox", "p": 1, "w": 25])
            .responseJSON(completionHandler: { (request, response, json, error) -> Void in
                print("json: \(json)")
                let parsed = self.jsonParseService.parseMailsResponse(json)
                print("parsed: \(parsed)")
        })
    }
}

