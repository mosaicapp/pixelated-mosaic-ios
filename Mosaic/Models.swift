import Foundation

struct MailsResponse {
    let mails: [Mail]
    let stats: Stats
}

struct Mail {
    let header: Header
    let textPlainBody: String?
    let mailbox: String
    let ident: String
}

struct Stats {
    let total: Int
}

struct Header {
    let from: String?
    let to: [String]
    let cc: [String]?
    let bcc: [String]?
    let subject: String
    let date: NSDate
}
