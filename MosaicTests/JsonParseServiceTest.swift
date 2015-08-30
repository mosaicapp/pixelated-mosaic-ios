import Quick
import Nimble
import XCTest

class JsonParseServiceTestSpec: QuickSpec {
    override func spec() {
        
        let jsonParseService = JsonParseService()
        
        describe("the MailService") {
            it("should correctly parse JSON response") {
                let json = JsonFromFile("mailsResponse")
                let result = jsonParseService.parseMailsResponse(json)
                
                switch result {
                case let .Success(res):
                    expect(res.stats.total) == 2
                    expect(res.mails.count) == 2
                    
                    expect(res.mails[0].header.from) == "alice@dev.pixelated-project.org"
                    expect(res.mails[0].header.to.count) == 1
                    expect(res.mails[0].header.to).to(contain("bob@dev.pixelated-project.org"))
                    expect(res.mails[0].header.cc!.count) == 2
                    expect(res.mails[0].header.bcc!.count) == 1
                    expect(res.mails[0].header.subject) == "Hello"
                    expect(res.mails[0].header.date).notTo(beNil())
                    expect(res.mails[0].textPlainBody) == "world"
                    expect(res.mails[0].mailbox) == "inbox"
                    
                    expect(res.mails[1].header.from).to(beNil())
                    expect(res.mails[1].header.to.count) == 1
                    expect(res.mails[1].header.to).to(contain("alice@dev.pixelated-project.org"))
                    expect(res.mails[1].header.cc).to(beNil())
                    expect(res.mails[1].header.bcc).to(beNil())
                    expect(res.mails[1].header.subject) == "Welcome"
                    expect(res.mails[1].textPlainBody) == "First mail"
                    expect(res.mails[1].mailbox) == "inbox"
                case let .Failure(msg):
                    XCTFail(msg)
                }
            }
        }
    }
}
