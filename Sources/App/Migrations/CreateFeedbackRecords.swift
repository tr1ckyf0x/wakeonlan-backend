import Fluent

struct CreateFeedbackRecords: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database
            .schema("feedbackRecords")
            .id()
            .field("username", .string, .required)
            .field("email", .string, .required)
            .field("message", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database
            .schema("feedbackRecords")
            .delete()
    }
}
