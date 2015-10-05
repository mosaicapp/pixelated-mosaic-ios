import Foundation

struct Mails {
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
    let date: Date
}

enum Date {
    case Parsed(NSDate)
    case Unparsed(String)
    
    func format(formatter: NSDateFormatter) -> String {
        switch self {
        case let .Parsed(date):
            return formatter.stringFromDate(date)
        case let .Unparsed(value):
            return value
        }
    }
}
