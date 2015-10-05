import Quick
import Nimble
import XCTest

class JsonParseServiceTestSpec: QuickSpec {
    override func spec() {
        
        let jsonParseService = JsonParseService()
        
        describe("the MailService") {
            it("should correctly parse JSON response") {
                let json = JsonFromFile("mailsResponse")
                let result = jsonParseService.parseMails(json)
                
                switch result {
                case let .Success(res):
                    expect(res.stats.total) == 2
                    expect(res.mails.count) == 2
                    
                    var mail = res.mails[0]
                    var header = mail.header
                    expect(header.from) == "alice@dev.pixelated-project.org"
                    expect(header.to.count) == 1
                    expect(header.to).to(contain("bob@dev.pixelated-project.org"))
                    expect(header.cc!.count) == 2
                    expect(header.bcc!.count) == 1
                    expect(header.subject) == "Hello"
                    if case .Parsed(_) = header.date {
                        // ok
                    } else {
                        XCTFail("date has not been parsed")
                    }
                    expect(mail.textPlainBody) == "world"
                    expect(mail.mailbox) == "inbox"
                    expect(mail.ident) == "M-xxxa"
                    
                    mail = res.mails[1]
                    header = mail.header
                    expect(header.from).to(beNil())
                    expect(header.to.count) == 1
                    expect(header.to).to(contain("alice@dev.pixelated-project.org"))
                    expect(header.cc).to(beNil())
                    expect(header.bcc).to(beNil())
                    expect(header.subject) == "Welcome"
                    if case .Parsed(_) = header.date {
                        // ok
                    } else {
                        XCTFail("date has not been parsed")
                    }
                    expect(mail.textPlainBody) == "First mail"
                    expect(mail.mailbox) == "inbox"
                    expect(mail.ident) == "M-xxxb"
                case let .Failure(msg):
                    XCTFail(msg)
                }
            }
        }
    }
}
