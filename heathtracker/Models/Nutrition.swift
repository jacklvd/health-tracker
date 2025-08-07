//
//  Nutrition.swift
//  heathtracker
//
//  Created by Jack Vo on 8/7/25.
//

import Foundation

struct Nutrition: Codable, Identifiable {
    let id: UUID
    let name: String
    let calories: Double?
    let servingSizeG: Double?
    let fatTotalG: Double?
    let fatSaturatedG: Double?
    let proteinG: Double?
    let sodiumMg: Double?
    let potassiumMg: Double?
    let cholesterolMg: Double?
    let carbohydratesTotalG: Double?
    let fiberG: Double?
    let sugarG: Double?
    
    // CodingKeys to map snake_case API fields to camelCase Swift properties
    enum CodingKeys: String, CodingKey {
        case name
        case calories
        case servingSizeG = "serving_size_g"
        case fatTotalG = "fat_total_g"
        case fatSaturatedG = "fat_saturated_g"
        case proteinG = "protein_g"
        case sodiumMg = "sodium_mg"
        case potassiumMg = "potassium_mg"
        case cholesterolMg = "cholesterol_mg"
        case carbohydratesTotalG = "carbohydrates_total_g"
        case fiberG = "fiber_g"
        case sugarG = "sugar_g"
    }
    
    // Custom initializer from decoder to handle mixed string/number values
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Name should always be a string
        let itemName = try container.decode(String.self, forKey: .name)
        
        // Generate a consistent ID based on the name hash
        self.id = UUID(uuidString: String(format: "%08x-%04x-%04x-%04x-%012x", 
                                         abs(itemName.hashValue), 
                                         0x1000, 0x2000, 0x3000, 0x123456789012)) ?? UUID()
        
        name = itemName
        
        // For each numeric field, try to decode as Double, fallback to nil if it's a string
        calories = try? container.decode(Double.self, forKey: .calories)
        servingSizeG = try? container.decode(Double.self, forKey: .servingSizeG)
        fatTotalG = try? container.decode(Double.self, forKey: .fatTotalG)
        fatSaturatedG = try? container.decode(Double.self, forKey: .fatSaturatedG)
        proteinG = try? container.decode(Double.self, forKey: .proteinG)
        sodiumMg = try? container.decode(Double.self, forKey: .sodiumMg)
        potassiumMg = try? container.decode(Double.self, forKey: .potassiumMg)
        cholesterolMg = try? container.decode(Double.self, forKey: .cholesterolMg)
        carbohydratesTotalG = try? container.decode(Double.self, forKey: .carbohydratesTotalG)
        fiberG = try? container.decode(Double.self, forKey: .fiberG)
        sugarG = try? container.decode(Double.self, forKey: .sugarG)
    }
    
    // Encode method for completeness (if needed)
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(calories, forKey: .calories)
        try container.encodeIfPresent(servingSizeG, forKey: .servingSizeG)
        try container.encodeIfPresent(fatTotalG, forKey: .fatTotalG)
        try container.encodeIfPresent(fatSaturatedG, forKey: .fatSaturatedG)
        try container.encodeIfPresent(proteinG, forKey: .proteinG)
        try container.encodeIfPresent(sodiumMg, forKey: .sodiumMg)
        try container.encodeIfPresent(potassiumMg, forKey: .potassiumMg)
        try container.encodeIfPresent(cholesterolMg, forKey: .cholesterolMg)
        try container.encodeIfPresent(carbohydratesTotalG, forKey: .carbohydratesTotalG)
        try container.encodeIfPresent(fiberG, forKey: .fiberG)
        try container.encodeIfPresent(sugarG, forKey: .sugarG)
    }
}
