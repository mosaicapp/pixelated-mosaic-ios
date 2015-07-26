import Foundation

struct MailsResponse {
    let mails: [Mail]
    let stats: Stats
}

struct Mail {
    let textPlainBody: String
    let mailbox: String
}

struct Stats {
    let total: Int
}
