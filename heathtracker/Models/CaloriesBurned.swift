//
//  CaloriesBurned.swift
//  heathtracker
//
//  Created by Jack Vo on 8/7/25.
//

import Foundation

struct CaloriesBurned: Codable, Identifiable {
    let id: UUID
    let name: String
    let calories_per_hour: Double
    let duration_minutes: Double
    let total_calories: Double
    
    enum CodingKeys: String, CodingKey {
        case name
        case calories_per_hour
        case duration_minutes
        case total_calories
    }
    
    // Custom initializer to generate stable ID
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let activityName = try container.decode(String.self, forKey: .name)
        
        // Generate a consistent ID based on the name hash
        self.id = UUID(uuidString: String(format: "%08x-%04x-%04x-%04x-%012x", 
                                         abs(activityName.hashValue), 
                                         0x5000, 0x6000, 0x7000, 0x567890123456)) ?? UUID()
        
        name = activityName
        calories_per_hour = try container.decode(Double.self, forKey: .calories_per_hour)
        duration_minutes = try container.decode(Double.self, forKey: .duration_minutes)
        total_calories = try container.decode(Double.self, forKey: .total_calories)
    }
}
