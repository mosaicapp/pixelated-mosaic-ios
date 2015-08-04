import UIKit
import Alamofire

class MainInboxController : UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    let jsonParseService = JsonParseService()
    
    let dateFormatter = NSDateFormatter()
    
    var mailsResponse : MailsResponse?
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
    }
    
    override func viewWillAppear(animated: Bool) {
        loadInbox()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("inboxMailCell") as! InboxMailCell
        
        if let response = mailsResponse {
            let mail = response.mails[indexPath.row]
            cell.subject.text = mail.header.subject
            cell.date.text = dateFormatter.stringFromDate(mail.header.date)
            cell.body.text = mail.textPlainBody
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