import PMKAlamofire
import OHHTTPStubs
import PromiseKit
import Alamofire
import XCTest

class AlamofireTests: XCTestCase {
    func test() {
        let inputJson: [String: Any] = ["key1": "value1", "key2": ["value2A", "value2B"]]

        OHHTTPStubs.stubRequests(passingTest: { $0.url!.host == "example.com" }) { _ in
            return OHHTTPStubsResponse(jsonObject: inputJson, statusCode: 200, headers: nil)
        }

        let ex = expectation(description: "")

        firstly {
            Alamofire.request("http://example.com").responseJSON().flatMap{ $0 as? [String: Any] }
        }.then { outputJson in
            XCTAssertEqual(inputJson as NSDictionary, outputJson as NSDictionary)
            ex.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
    }
}
