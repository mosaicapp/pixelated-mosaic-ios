import UIKit

class MainInboxController : UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    let mailsService = MailsService()
    
    let dateFormatter = NSDateFormatter()
    
    var mails : Mails?
    var refreshControl:UIRefreshControl!
    var isRefreshing: Bool = false
    var mailRow: Int!
    
    
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
            if self.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            
            let alert = AlertService.createDefaultAlert("Connection Error", message: "")
            if let alertToPresent = alert {
                self.presentViewController(alertToPresent, animated: true, completion: { () -> Void in
                    if self.isRefreshing {
                        self.refreshControl.endRefreshing()
                    }
                })
            }
        }
    }
    
    func refresh(sender:AnyObject) {
        isRefreshing = true
        loadInbox()
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        mailRow = indexPath.row
        print("zeile: \(mailRow)")
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "DetailViewSegue" {
            if let path = self.tableView.indexPathForSelectedRow {
                if let mails = mails {
                    let choosenMail = mails.mails[path.row]
                    if let controller = segue.destinationViewController as? DetailViewController {
                        controller.selectedMail = choosenMail
                        controller.dateFormatter = self.dateFormatter
                    }
                }
            }
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
            cell.date.text = dateFormatter.stringFromDate(mail.header.date)
            cell.body.text = mail.textPlainBody
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mails?.mails.count ?? 0
    }
    
}

extension MainInboxController: UITableViewDelegate {
    
}

extension MainInboxController: FetchMailsDelegate {
    
    func fetched(mails: Mails) {
        self.mails = mails
        self.tableView.reloadData()
        
        if self.isRefreshing {
            self.refreshControl.endRefreshing()
        }
    }
    
    func failure(message: String) {
        
        print(message) // For debugging. TODO show the message to the user?
        
        let alert = AlertService.createDefaultAlert("Data Error", message: "Couldn't load inbox emails. Please try again later")
        if let alertToPresent = alert {
            self.presentViewController(alertToPresent, animated: true, completion: { () -> Void in
                if self.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
            })
        }
    }
    
}
