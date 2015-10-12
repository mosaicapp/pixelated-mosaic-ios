import UIKit

class MainInboxController : UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    let mailsService = MailsService()
    
    let dateFormatter = NSDateFormatter()
    
    var mails : Mails?
    var refreshControl: UIRefreshControl!
    
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("Pull To Refresh", comment: "PullToRefreshAction"))
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(animated: Bool) {
        loadInbox()
    }
    
    private func loadInbox() {
        if Reachability.connectedToNetwork() {
            self.mailsService.fetchInboxMails(page: 1, size: 25, delegate: self);
        } else {
            showAlert("Connection Error", message: "You are not connected to the internet")
        }
    }
    
    private func showAlert(title: String, message: String) {
        if self.refreshControl.refreshing {
            self.refreshControl.endRefreshing()
        }
        
        let alert = AlertService.createDefaultAlert(title, message: message);
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func refresh(sender:AnyObject) {
        loadInbox()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "DetailViewSegue" {
            guard
                let controller = segue.destinationViewController as? DetailViewController,
                let path = self.tableView.indexPathForSelectedRow,
                let mails = mails
            else {
                return
            }

            controller.selectedMail = mails.mails[path.row]
            controller.dateFormatter = self.dateFormatter
        }
    }
    
}

extension MainInboxController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("inboxMailCell") as! InboxMailCell
        
        if let response = mails {
            let mail = response.mails[indexPath.row]
            cell.from.text = mail.header.from
            cell.subject.text = mail.header.subject
            cell.date.text = mail.header.date.format(dateFormatter)
            cell.body.text = mail.textPlainBody
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mails?.mails.count ?? 0
    }
    
}

extension MainInboxController: UITableViewDelegate {

//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        print("zeile: \(indexPath.row)")
//    }
    
}

extension MainInboxController: FetchDelegate {
    
    func fetched(mails: Mails) {
        self.mails = mails
        self.tableView.reloadData()
        
        if self.refreshControl.refreshing {
            self.refreshControl.endRefreshing()
        }
    }
    
    func failure(message: String) {
        debugPrint(message) // For debugging. TODO show the message to the user?
        
        showAlert("Data Error", message: "Couldn't load inbox emails. Please try again later")
    }
    
}
