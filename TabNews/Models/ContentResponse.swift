//
//  ContentResponse.swift
//  TabNews
//
//  Created by Danilo Lira on 04/12/25.
//

import Foundation

struct ContentResponse: Codable, Identifiable {
    let id: String
    let ownerId: String
    let parentId: String?
    let slug: String
    let title: String
    let status: String
    let sourceURL: String?
    let createdAt: String
    let updatedAt: String
    let publishedAt: String
    let deletedAt: String?
    let tabcoins: Int
    let tabcoinsCredit: Int
    let tabcoinsDebit: Int
    let ownerUsername: String
    let childrenDeepCount: Int
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerId = "owner_id"
        case parentId = "parent_id"
        case slug
        case title
        case status
        case sourceURL = "source_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case publishedAt = "published_at"
        case deletedAt = "deleted_at"
        case tabcoins
        case tabcoinsCredit = "tabcoins_credit"
        case tabcoinsDebit = "tabcoins_debit"
        case ownerUsername = "owner_username"
        case childrenDeepCount = "children_deep_count"
        case type
    }
    
    var publishedDate: Date? {
        ISO8601DateFormatter().date(from: publishedAt)
    }
}
