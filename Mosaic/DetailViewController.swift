import UIKit

class DetailViewController: UIViewController {

    var row: Int!
    var selectedMail: Mail?
    var dateFormatter: NSDateFormatter!
    
    var mailsService = MailsService()
    
    @IBOutlet weak var mailSubject: UILabel!
    @IBOutlet weak var sentFromLabel: UILabel!
    @IBOutlet weak var mailDateLabel: UILabel!
    @IBOutlet weak var mailContentTextView: UITextView!
    
    override func viewDidLoad() {
        if let mail = selectedMail {
            debugPrint("you selected the \(mail) mail")
            render(mail)
            mailsService.fetchSingleMail(ident: mail.ident, delegate: self)
        }
    }
    
    private func render(mail: Mail) {
        sentFromLabel.text = mail.header.from
        mailSubject.text = mail.header.subject
        mailDateLabel.text = mail.header.date.format(dateFormatter)
        mailContentTextView.text = mail.textPlainBody
    }
    
}

extension DetailViewController: FetchDelegate {
    
    func fetched(mail: Mail) {
        render(mail)
    }
    
    func failure(message: String) {
        debugPrint(message) // For debugging. TODO show the message to the user?
        AlertService.showDataErrorAlert(self, message: "Couldn't load email. Please try again later")
    }
    
}
