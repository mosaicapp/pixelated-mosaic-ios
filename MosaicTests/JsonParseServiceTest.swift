import Quick
import Nimble

class JsonParseServiceTestSpec: QuickSpec {
    override func spec() {
        
        let jsonParseService = JsonParseService()
        
        describe("the MailService") {
            it("should correctly parse JSON response") {
                let json = JsonFromFile("mailsResponse")
                let res = jsonParseService.parseMailsResponse(json)
                expect(res).notTo(beNil())
                expect(res?.stats.total) == 2
                expect(res?.mails.count) == 2
                expect(res?.mails[0].textPlainBody) == "first"
                expect(res?.mails[0].mailbox) == "inbox"
                expect(res?.mails[1].textPlainBody) == "second"
                expect(res?.mails[1].mailbox) == "inbox"
            }
        }
    }
}
