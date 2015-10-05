//
//  DetailViewController.swift
//  Mosaic
//
//  Created by Hennes Roemmer on 23.09.15.
//  Copyright © 2015 Pixelated. All rights reserved.
//

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
        print("you selected the \(selectedMail!) mail")
        if let mail = selectedMail {
            mailsService.fetchSingleMail(ident: mail.ident, delegate: self)
            render(mail)
        }
    }
    
    private func render(mail: Mail) {
        sentFromLabel.text = mail.header.from
        mailSubject.text = mail.header.subject
        mailDateLabel.text = mail.header.date.format(dateFormatter)
        mailContentTextView.text = mail.textPlainBody
    }
    
}

extension DetailViewController: FetchMailDelegate {
    
    func fetched(mail: Mail) {
        render(mail)
    }
    
}
