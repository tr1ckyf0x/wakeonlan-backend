import Foundation
import Vapor

struct AdminController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let adminGroup = routes
            .grouped("admin")
            .grouped(AsyncAdminAuthenticator())
            .grouped(AdminUser.guardMiddleware())

        adminGroup.get("feedbacks", use: fetchFeedbacks)
    }

    func fetchFeedbacks(req: Request) async throws -> [FeedbackRecord] {
        let records = try await FeedbackRecord.query(on: req.db).all()
        return records
    }
}
