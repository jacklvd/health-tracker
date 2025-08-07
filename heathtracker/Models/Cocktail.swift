//
//  Cocktail.swift
//  heathtracker
//
//  Created by Jack Vo on 8/7/25.
//

import Foundation

struct Cocktail: Codable, Identifiable {
    let id: UUID
    let name: String
    let ingredients: [String]
    let instructions: String
    
    // CodingKeys to exclude 'id' from decoding since it's not in the API response
    enum CodingKeys: String, CodingKey {
        case name, ingredients, instructions
    }
    
    // Custom initializer to generate stable ID
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let cocktailName = try container.decode(String.self, forKey: .name)
        
        // Generate a consistent ID based on the name hash
        self.id = UUID(uuidString: String(format: "%08x-%04x-%04x-%04x-%012x", 
                                         abs(cocktailName.hashValue), 
                                         0x3000, 0x4000, 0x5000, 0x345678901234)) ?? UUID()
        
        name = cocktailName
        ingredients = try container.decode([String].self, forKey: .ingredients)
        instructions = try container.decode(String.self, forKey: .instructions)
    }
}
