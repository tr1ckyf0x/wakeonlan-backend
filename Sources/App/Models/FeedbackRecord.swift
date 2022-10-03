//
//  FeedbackRecord.swift
//  
//
//  Created by Vladislav Lisianskii on 15.08.2021.
//

import Foundation
import Vapor
import Fluent

final class FeedbackRecord: Model, Content {
    static let schema = "feedbackRecords"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "username")
    var username: String

    @Field(key: "email")
    var email: String

    @Field(key: "message")
    var message: String

    init() { }

    init(id: UUID? = nil,
         username: String,
         email: String,
         message: String) {
        self.id = id
        self.username = username
        self.email = email
        self.message = message
    }
}

extension FeedbackRecord: Equatable {
    static func ==(lhs: FeedbackRecord, rhs: FeedbackRecord) -> Bool {
        guard lhs.username == rhs.username,
              lhs.email == rhs.email,
              lhs.message == rhs.message
        else { return false }
        return true
    }
}
