//
//  Recipe.swift
//  heathtracker
//
//  Created by Jack Vo on 8/7/25.
//

import Foundation

struct Recipe: Codable, Identifiable {
    let id: UUID
    let title: String
    let ingredients: String
    let servings: String
    let instructions: String
    
    // CodingKeys to exclude 'id' from decoding since it's not in the API response
    enum CodingKeys: String, CodingKey {
        case title, ingredients, servings, instructions
    }
    
    // Custom initializer to generate stable ID
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let recipeTitle = try container.decode(String.self, forKey: .title)
        
        // Generate a consistent ID based on the title hash
        self.id = UUID(uuidString: String(format: "%08x-%04x-%04x-%04x-%012x", 
                                         abs(recipeTitle.hashValue), 
                                         0x2000, 0x3000, 0x4000, 0x234567890123)) ?? UUID()
        
        title = recipeTitle
        ingredients = try container.decode(String.self, forKey: .ingredients)
        servings = try container.decode(String.self, forKey: .servings)
        instructions = try container.decode(String.self, forKey: .instructions)
    }
}
