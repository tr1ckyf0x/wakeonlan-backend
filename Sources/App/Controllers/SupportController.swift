//
//  SupportController.swift
//  
//
//  Created by Vladislav Lisianskii on 15.08.2021.
//
import Foundation
import Vapor

struct SupportController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let feedbackGroup = routes.grouped("feedback")

        feedbackGroup.post(use: create)
    }

    func create(req: Request) throws -> EventLoopFuture<FeedbackRecord> {
        let feedbackRecord = try req.content.decode(FeedbackRecord.self)
        return feedbackRecord.save(on: req.db).map { feedbackRecord }
    }
}
