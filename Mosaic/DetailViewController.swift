//
//  DetailViewController.swift
//  Mosaic
//
//  Created by Hennes Roemmer on 23.09.15.
//  Copyright © 2015 Pixelated. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var row:Int!
    var detailedMailResponse:Mail?
    
    @IBOutlet weak var mailSubject: UILabel!
    @IBOutlet weak var sentFromLabel: UILabel!
    @IBOutlet weak var mailDateLabel: UILabel!
    @IBOutlet weak var mailContentTextView: UITextView!
    
    override func viewDidLoad() {
        print("you selected the \(detailedMailResponse!) mail")
        sentFromLabel.text = detailedMailResponse!.header.from
        mailSubject.text = detailedMailResponse?.header.subject
        mailDateLabel.text = "\(detailedMailResponse?.header.date)"
        //mailContentTextView.text = "\()"
    }
}
