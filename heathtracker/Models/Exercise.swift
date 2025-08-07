//
//  Exercise.swift
//  heathtracker
//
//  Created by Jack Vo on 8/7/25.
//

import Foundation

struct Exercise: Codable, Identifiable {
    let id: UUID
    let name: String
    let type: String
    let muscle: String
    let equipment: String
    let difficulty: String
    let instructions: String
    
    // CodingKeys to exclude 'id' from decoding since it's not in the API response
    enum CodingKeys: String, CodingKey {
        case name, type, muscle, equipment, difficulty, instructions
    }
    
    // Custom initializer to generate stable ID
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let exerciseName = try container.decode(String.self, forKey: .name)
        
        // Generate a consistent ID based on the name hash
        self.id = UUID(uuidString: String(format: "%08x-%04x-%04x-%04x-%012x", 
                                         abs(exerciseName.hashValue), 
                                         0x4000, 0x5000, 0x6000, 0x456789012345)) ?? UUID()
        
        name = exerciseName
        type = try container.decode(String.self, forKey: .type)
        muscle = try container.decode(String.self, forKey: .muscle)
        equipment = try container.decode(String.self, forKey: .equipment)
        difficulty = try container.decode(String.self, forKey: .difficulty)
        instructions = try container.decode(String.self, forKey: .instructions)
    }
}
