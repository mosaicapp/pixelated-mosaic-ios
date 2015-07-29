import UIKit
import Alamofire

class MainInboxController : UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    let jsonParseService = JsonParseService()
    
    var mailsResponse : MailsResponse?
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        loadInbox()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("inboxMailCell") as! InboxMailCell
        
        if let response = mailsResponse {
            cell.subject.text = response.mails[indexPath.row].header.subject
            cell.body.text = response.mails[indexPath.row].textPlainBody
            cell.date.text = "01/01/2015"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mailsResponse == nil ? 0 : mailsResponse!.mails.count
    }
    
    private func loadInbox() {
        Alamofire.request(.GET, "http://localhost:3333/mails",
            parameters: ["q": "tag:inbox", "p": 1, "w": 25])
            .responseJSON(completionHandler: { (request, response, json, error) -> Void in
                self.mailsResponse = self.jsonParseService.parseMailsResponse(json)
                self.tableView.reloadData()
            })
    }
}
