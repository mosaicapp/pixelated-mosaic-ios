import Foundation
import Alamofire

protocol FetchMailsDelegate {
    func fetched(response: MailsResponse) -> Void
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
        .responseJSON(completionHandler: { (request, response, result) -> Void in
            switch result {
            case .Success(let json):
                // print(json)
                let mails = self.jsonParseService.parseMailsResponse(json)
                switch mails {
                case let .Success(value):
                    delegate.fetched(value)
                case let .Failure(message):
                    delegate.failure(message)
                }
            case let .Failure(_, error):
                print(error)
                delegate.failure("Failed http request")
            }
        })
    }
    
}
