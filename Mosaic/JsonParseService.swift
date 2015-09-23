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
    func parseMailsResponse(json: AnyObject?) -> Result<MailsResponse> {
        if let json = json {
            let decocedResponse = MailsResponse.decode(JSON.parse(json))
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
    
}

// MARK: - MailsResponse
extension MailsResponse: Decodable {
    static func decode(json: JSON) -> Decoded<MailsResponse> {
        return curry(MailsResponse.init)
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
            <*> json <||? "cc"
            <*> json <||? "bcc"
            <*> json <| "subject"
            <*> json <| "date"
    }
}

extension NSDate: Decodable {
    
    private static let jsonDateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH-mm-ss.Sx"
        return formatter
    }()
    
    public static func decode(json: JSON) -> Decoded<NSDate> {
        switch json {
        case .String(let dateString):
            if let date = jsonDateFormatter.dateFromString(dateString) {
                return Decoded.Success(date)
            }
            return Decoded.Failure(DecodeError.TypeMismatch(expected: "a date", actual: dateString))
        default:
            return Decoded.Failure(DecodeError.TypeMismatch(expected: "a date", actual: json.description))
        }
    }
}
