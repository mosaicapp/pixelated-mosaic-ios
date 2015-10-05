import Foundation
import Alamofire

protocol FetchDelegate {
    typealias T
    func failure(message: String) -> Void
    func fetched(value: T) -> Void
}

extension FetchDelegate {
    func failure(message: String) {
        debugPrint("Error when fetching mails:", message)
    }
}

class MailsService {
    
    let baseUrl = "http://localhost:3333"
    
    let jsonParseService = JsonParseService()
    
    func fetchInboxMails<FD: FetchDelegate where FD.T == Mails>(page page: Int, size: Int, delegate: FD) {
        Alamofire.request(.GET, baseUrl + "/mails", parameters: ["q": "tag:inbox", "p": page, "w": size])
            .responseJSON { response in
                self.handleResponse(response, withParser: self.jsonParseService.parseMails, andDelegate: delegate)
        }
    }
    
    func fetchSingleMail<FD: FetchDelegate where FD.T == Mail>(ident ident: String, delegate: FD) {
        Alamofire.request(.GET, baseUrl + "/mail/" + ident).responseJSON { response in
            self.handleResponse(response, withParser: self.jsonParseService.parseMail, andDelegate: delegate)
        }
    }
    
    private func handleResponse<FD: FetchDelegate>(
        response: Response<AnyObject, NSError>,
        withParser parse: (AnyObject) -> JsonParseResult<FD.T>,
        andDelegate delegate: FD) -> Void
    {
        switch response.result {
        case let .Success(json):
            debugPrint(json)
            let mail = parse(json)
            switch mail {
            case let .Success(value):
                delegate.fetched(value)
            case let .Failure(message):
                delegate.failure(message)
            }
        case let .Failure(error):
            debugPrint(error)
            delegate.failure("Failed http request")
        }
    }
    
}
