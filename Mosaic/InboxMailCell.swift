import UIKit

class InboxMailCell: UITableViewCell {

    @IBOutlet var subject: UILabel!
    @IBOutlet var body: UILabel!
    @IBOutlet var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
