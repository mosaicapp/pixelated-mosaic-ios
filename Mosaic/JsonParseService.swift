import Foundation
import Argo
import Curry

/**
  Result type returned from parsing JSON
*/
public enum Result<T> {
    case Success(T)
    case Failure(String)
}


class JsonParseService {
    
    /**
      Parse the result from a fetch mails request
    */
    func parseMails(json: AnyObject?) -> Result<Mails> {
        if let json = json {
            let decocedResponse = Mails.decode(JSON.parse(json))
            switch decocedResponse {
            case let .Success(response):
                return Result.Success(response)
            case let .Failure(error):
                switch error {
                case let .MissingKey(key):
                    return Result.Failure("Error parsing JSON: Missing key " + key)
                case let .TypeMismatch(expected, actual):
                    return Result.Failure("Error parsing JSON: expected " + expected + ", found " + actual)
                }
            }
        }
        return Result.Failure("Missing input")
    }
    
    func parseMail(json: AnyObject?) -> Result<Mail> {
        if let json = json {
            let decodedResponse = Mail.decode(JSON.parse(json))
            switch decodedResponse {
            case let .Success(response):
                return Result.Success(response)
            case let .Failure(error):
                switch error {
                case let .MissingKey(key):
                    return Result.Failure("Error parsing JSON: Missing key " + key)
                case let .TypeMismatch(expected, actual):
                    return Result.Failure("Error parsing JSON: expected " + expected + ", found " + actual)
                }
            }
        }
        return Result.Failure("Missing input")
    }
    
}

// MARK: - MailsResponse
extension Mails: Decodable {
    static func decode(json: JSON) -> Decoded<Mails> {
        return curry(Mails.init)
            <^> json <|| "mails"
            <*> json <|  "stats"
    }
}

// MARK: - Mail
extension Mail: Decodable {
    static func decode(json: JSON) -> Decoded<Mail> {
        return curry(Mail.init)
            <^> json <| "header"
            <*> json <|? "textPlainBody"
            <*> json <| "mailbox"
            <*> json <| "ident"
    }
}

// MARK: - Stats
extension Stats: Decodable {
    static func decode(json: JSON) -> Decoded<Stats> {
        return curry(Stats.init) <^> json <| "total"
    }
}

// MARK: - Header
extension Header: Decodable {
    static func decode(json: JSON) -> Decoded<Header> {
        return curry(Header.init)
            <^> json <|? "from"
            <*> json <|| "to"
            <*> json <||? "cc"
            <*> json <||? "bcc"
            <*> json <| "subject"
            <*> json <| "date"
    }
}

// MARK: - Date
extension Date: Decodable {
    private static let jsonDateFormatters: [NSDateFormatter] = {
        let formatter1 = NSDateFormatter()
        formatter1.dateFormat = "yyyy-MM-dd'T'HH-mm-ss.Sx"

        let formatter2 = NSDateFormatter()
        formatter2.dateFormat = "EEE, d MMM yyyy HH-mm-ss Z"

        return [formatter1, formatter2]
    }()
    
    static func decode(json: JSON) -> Decoded<Date> {
        switch json {
        case .String(let dateString):
            for formatter in jsonDateFormatters {
                if let date = formatter.dateFromString(dateString) {
                    return Decoded.Success(Date.Parsed(date))
                }
            }
            return Decoded.Success(Date.Unparsed(dateString))
        default:
            return Decoded.Failure(DecodeError.TypeMismatch(expected: "a date", actual: json.description))
        }
    }
}
