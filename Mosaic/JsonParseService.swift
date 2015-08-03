import Foundation
import Argo
import Curry

class JsonParseService {
    
    func parseMailsResponse(json: AnyObject?) -> MailsResponse? {
        if let json = json {
            return MailsResponse.decode(JSON.parse(json)).value
        }
        return .None
    }
    
}

// MARK: - MailsResponse
extension MailsResponse: Decodable {
    static func decode(json: JSON) -> Decoded<MailsResponse> {
        return curry(MailsResponse.init)
            <^> json <|| "mails"
            <*> json <|  "stats"
        //            <*> j <| "name"
        //            <*> j <|? "email" // Use ? for parsing optional values
        //            <*> j <| "role" // Custom types that also conform to Decodable just work
        //            <*> j <| ["company", "name"] // Parse nested objects
        //            <*> j <|| "friends" // parse arrays of objects
    }
}

// MARK: - Mail
extension Mail: Decodable {
    static func decode(json: JSON) -> Decoded<Mail> {
        return curry(Mail.init)
            <^> json <| "header"
            <*> json <| "textPlainBody"
            <*> json <| "mailbox"
    }
}

// MARK: - Stats
extension Stats: Decodable {
    static func decode(json: JSON) -> Decoded<Stats> {
        return Stats.init <^> json <| "total"
    }
}

// MARK: - Header
extension Header: Decodable {
    static func decode(json: JSON) -> Decoded<Header> {
        return curry(Header.init)
            <^> json <|? "from"
            <*> json <|| "to"
            <*> json <|| "cc"
            <*> json <|| "bcc"
            <*> json <| "subject"
            <*> json <| "date"
    }
}

private class JsonDateParser {
    
    let formatter = NSDateFormatter()
    
    init() {
        formatter.dateFormat = "yyyy-MM-dd'T'HH-mm-ss.Sx"
    }
    
    func parse(string: String) -> NSDate? {
        return formatter.dateFromString(string)
    }

}

private let jsonDateParser = JsonDateParser()

extension NSDate: Decodable {
    public static func decode(json: JSON) -> Decoded<NSDate> {
        switch json {
        case .String(let dateString):
            if let date = jsonDateParser.parse(dateString) {
                return Decoded.Success(date)
            }
            return Decoded.TypeMismatch(dateString)
        default:
            return Decoded.TypeMismatch(json.description)
        }
    }
}
