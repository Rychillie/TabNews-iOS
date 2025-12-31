//
//  SummarizationService.swift
//  TabNews
//
//  Created by Assistant on 09/12/25.
//

import Foundation
import FoundationModels

@MainActor
class SummarizationService {
    static let shared = SummarizationService()
    
    private init() {}
    
    /// Check if FoundationModels is available on the current device
    func isAvailable() -> Bool {
        // Check if the system language model is available
        let model = SystemLanguageModel.default
        
        switch model.availability {
        case .available:
            return true
        case .unavailable:
            return false
        }
    }
    
    /// Get the availability status with detailed reason
    func getAvailabilityStatus() -> SystemLanguageModel.Availability {
        return SystemLanguageModel.default.availability
    }
    
    /// Summarize content from a ContentResponse (includes title, owner, date, body, and source)
    func summarize(content: ContentResponse) async throws -> String {
        guard isAvailable() else {
            throw NSError(
                domain: "SummarizationService",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "FoundationModels not available on this device"]
            )
        }
        
        // Create a session with instructions for summarization
        let instructions = """
            Você é um assistente que resume conteúdos de forma concisa e objetiva.
            Responda sempre em português.
            Use apenas texto simples, SEM markdown, sem negrito, sem itálico, sem formatação.
            Gere APENAS UM PARÁGRAFO único, sem quebras de linha ou espaços extras.
            """
        
        let session = LanguageModelSession(instructions: instructions)
        
        // Build comprehensive content string with all information that appears in PostDetailView
        var contentToSummarize = """
            Título: \(content.title)
            Autor: \(content.ownerUsername)
            """
        
        // Add publication date if available
        if !content.publishedAt.isEmpty {
            contentToSummarize += "\nPublicado: \(content.publishedAt)"
        }
        
        // Add body content
        if let body = content.body, !body.isEmpty {
            contentToSummarize += "\n\nConteúdo:\n\(body)"
        }
        
        // Add source URL if available
        if let sourceURL = content.sourceURL, !sourceURL.isEmpty {
            contentToSummarize += "\n\nFonte: \(sourceURL)"
        }
        
        // Add instructions for the model
        contentToSummarize += """
            
            
            Forneça um resumo conciso em texto simples (sem formatação) como um único parágrafo.
            Não use quebras de linha. Resuma os pontos principais de forma objetiva.
            """
        
        // Generate the summary
        let prompt = Prompt(contentToSummarize)
        let response = try await session.respond(to: prompt)
        
        // Clean the response to ensure single paragraph
        return cleanSummary(response.content)
    }
    
    /// Clean summary to ensure it's a single paragraph without newlines
    private func cleanSummary(_ text: String) -> String {
        // Replace newlines with spaces
        let cleaned = text
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "\r", with: " ")
            .replacingOccurrences(of: "\t", with: " ")
        
        // Remove multiple spaces
        return cleaned.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression).trimmingCharacters(in: .whitespaces)
    }
}
