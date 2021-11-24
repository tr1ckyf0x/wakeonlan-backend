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

    func create(req: Request) async throws -> FeedbackRecord {
        guard let captchaToken = req.headers.first(name: "ReCaptchaToken")
        else {
            throw Abort(.forbidden)
        }

        async let verificationResponse = req.client.post("https://www.google.com/recaptcha/api/siteverify", beforeSend: { (clientRequest: inout ClientRequest) -> Void in
            let secret = Environment.get("AWAKE_CAPTCHA_KEY") ?? ""
            try clientRequest.content.encode([
                "secret": secret,
                "response": captchaToken
            ], as: .urlEncodedForm)
        }).content.decode(SiteverifyResponse.self)

        guard try await verificationResponse.isValid else {
            throw Abort(.forbidden)
        }

        let feedbackRecord = try req.content.decode(FeedbackRecord.self)

        try await feedbackRecord.save(on: req.db)

        return feedbackRecord
    }
}
