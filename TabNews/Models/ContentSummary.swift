//
//  ContentSummary.swift
//  TabNews
//
//  Created by Assistant on 09/12/25.
//

import Foundation

struct ContentSummary: Codable, Identifiable {
    let id: String  // Same as ContentResponse id
    let summary: String
    let createdAt: Date
    
    init(id: String, summary: String) {
        self.id = id
        self.summary = summary
        self.createdAt = Date()
    }
}
