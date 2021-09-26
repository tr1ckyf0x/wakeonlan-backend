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
        guard let captchaToken = req.headers.first(name: "ReCaptchaToken")
        else {
            throw Abort(.forbidden)
        }

        return req.client.post("https://www.google.com/recaptcha/api/siteverify") { (clientRequest: inout ClientRequest) -> Void in
            let secret = Environment.get("AWAKE_CAPTCHA_KEY") ?? ""
            try clientRequest.content.encode([
                "secret": secret,
                "response": captchaToken
            ], as: .urlEncodedForm)
        }
        .flatMapThrowing({ (clientResponse: ClientResponse) -> SiteverifyResponse in
            let verificationResponse = try clientResponse.content.decode(SiteverifyResponse.self)
            return verificationResponse
        })
        .guard({ (verificationResponse: SiteverifyResponse) -> Bool in
            verificationResponse.isValid
        }, else: Abort(.forbidden))
        .flatMapThrowing({ (_) -> FeedbackRecord in
            try req.content.decode(FeedbackRecord.self)
        })
        .flatMap { (feedbackRecord: FeedbackRecord) -> EventLoopFuture<FeedbackRecord> in
            return feedbackRecord
                .save(on: req.db)
                .map { feedbackRecord }
        }
    }
}
