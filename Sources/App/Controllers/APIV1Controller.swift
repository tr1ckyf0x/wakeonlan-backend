//
//  APIV1Controller.swift
//  
//
//  Created by Vladislav Lisianskii on 15.08.2021.
//

import Foundation
import Vapor

struct APIV1Controller: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let apiV1Group = routes.grouped("api", "v1")
        try apiV1Group.register(collection: SupportController())
    }
}
