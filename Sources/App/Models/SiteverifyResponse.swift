//
//  SiteverifyResponse.swift
//  
//
//  Created by Vladislav Lisianskii on 04.09.2021.
//

import Foundation

struct SiteverifyResponse: Decodable {
    let isValid: Bool

    private enum CodingKeys: String, CodingKey {
        case isValid = "success"
    }
}
