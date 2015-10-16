import Quick
import Nimble
import XCTest

private func expectSuccess<T>(result: JsonParseResult<T>, file: String = __FILE__, line: UInt = __LINE__, test: T -> () = { _ in }) {
    guard case let .Success(value) = result else {
        fail("expected <Success>, got <\(result)>", file: file, line: line)
        return
    }
    test(value)
}

private func expectParsed(date: Date, file: String = __FILE__, line: UInt = __LINE__, test: NSDate -> () = { _ in }) {
    guard case let .Parsed(value) = date else {
        fail("expected <Parsed>, got <\(date)>", file: file, line: line)
        return
    }
    test(value)
}

class JsonParseServiceTestSpec: QuickSpec {
    
    override func spec() {
        
        let jsonParseService = JsonParseService()
        
        describe("the JsonParseService") {
            it("should correctly parse JSON a response") {
                let json = JsonFromFile("mailsResponse")
                let result = jsonParseService.parseMails(json)
                
                expectSuccess(result) { mails in
                    expect(mails.stats.total) == 2
                    expect(mails.mails.count) == 2
                    
                    var mail = mails.mails[0]
                    var header = mail.header
                    expect(header.from) == "alice@dev.pixelated-project.org"
                    expect(header.to.count) == 1
                    expect(header.to).to(contain("bob@dev.pixelated-project.org"))
                    expect(header.cc!.count) == 2
                    expect(header.bcc!.count) == 1
                    expect(header.subject) == "Hello"
                    expectParsed(header.date) { date in
                        let desc = date.description
                        expect(desc) == "2015-10-05 07:49:52 +0000"
                    }
                    expect(mail.textPlainBody) == "world"
                    expect(mail.mailbox) == "inbox"
                    expect(mail.ident) == "M-xxxa"
                    
                    mail = mails.mails[1]
                    header = mail.header
                    expect(header.from).to(beNil())
                    expect(header.to.count) == 1
                    expect(header.to).to(contain("alice@dev.pixelated-project.org"))
                    expect(header.cc).to(beNil())
                    expect(header.bcc).to(beNil())
                    expect(header.subject) == "Welcome"
                    expectParsed(header.date) { date in
                        let desc = date.description
                        expect(desc) == "2015-07-15 18:08:23 +0000"
                    }
                    expect(mail.textPlainBody) == "First mail"
                    expect(mail.mailbox) == "inbox"
                    expect(mail.ident) == "M-xxxb"
                }
            }
        }
    }
}
