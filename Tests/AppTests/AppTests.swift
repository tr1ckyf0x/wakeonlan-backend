@testable import App
import XCTVapor

final class AppTests: XCTestCase {

    var app: Application!

    override func setUp() async throws {
        try await super.setUp()
        app = Application(.testing)
        try configure(app)
    }

    override func tearDown() {
        super.tearDown()
        app.shutdown()
    }

    func testAdminFetchRecords() async throws {

        let record1 = FeedbackRecord(username: "abc", email: "abc@test.com", message: "test")
        let record2 = FeedbackRecord(username: "test", email: "test@test.com", message: "test")

//        try await app.db.transaction { db in
        try await record1.save(on: app.db)
        try await record2.save(on: app.db)
//        }

        let expectedResponse = [record1, record2]
        
        try app.test(.GET, "/api/v1/admin/feedbacks") { response in
            XCTAssertEqual(response.status, .ok)
            let records = try response.content.decode([FeedbackRecord].self)
            XCTAssertEqual(records, expectedResponse)
        }
    }
}
