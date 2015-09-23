import Foundation
import Alamofire

protocol FetchMailsDelegate {
    func fetched(mails: Mails) -> Void
    func failure(message: String) -> Void
}

extension FetchMailsDelegate {
    func failure(message: String) {
        print("Error when fetching mails:", message)
    }
}


class MailsService {
    
    let baseUrl = "http://localhost:3333"
    
    let jsonParseService = JsonParseService()
    
    func fetchInboxMails(page page: Int, size: Int, delegate: FetchMailsDelegate) {
        Alamofire.request(.GET, baseUrl + "/mails", parameters: ["q": "tag:inbox", "p": page, "w": size])
            .responseJSON { response in
            switch response.result {
            case let .Success(json):
                // print(json)
                let mails = self.jsonParseService.parseMails(json)
                switch mails {
                case let .Success(value):
                    delegate.fetched(value)
                case let .Failure(message):
                    delegate.failure(message)
                }
            case let .Failure(error):
                print(error)
                delegate.failure("Failed http request")
            }
        }
    }
    
    func fetchSingleMail(ident ident: String) {
        Alamofire.request(.GET, baseUrl + "/mail/" + ident).responseJSON { response in
            switch response.result {
            case let .Success(json):
                print(json)
            case let .Failure(error):
                print(error)
            }
        }
    }
    
}
