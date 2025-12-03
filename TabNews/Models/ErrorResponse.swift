//
//  ErrorResponse.swift
//  TabNews
//
//  Created by Rychillie Umpierre de Oliveira on 02/12/25.
//

import Foundation

struct ErrorResponse: Codable {
    let name: String
    let message: String
    let action: String
    let statusCode: Int
    let errorId: String
    let requestId: String
    let errorLocationCode: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case message
        case action
        case statusCode = "status_code"
        case errorId = "error_id"
        case requestId = "request_id"
        case errorLocationCode = "error_location_code"
    }
}
