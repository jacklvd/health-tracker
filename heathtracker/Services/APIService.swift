//
//  APIService.swift
//  heathtracker
//
//  Created by Jack Vo on 8/7/25.
//

import Foundation

class APIService: ObservableObject {
    private let apiKey = Config.apiKey
    private let baseURL = "https://api.api-ninjas.com/v1"
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Fetch Nutrition Data with better error handling
    func fetchNutrition(query: String) async throws -> [Nutrition] {
        guard !query.isEmpty else { return [] }
        
        let urlString = "\(baseURL)/nutrition?query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Check for HTTP errors
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    // Print response body for debugging (without sensitive info)
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("❌ API Error Response: \(responseString)")
                    }
                    
                    if httpResponse.statusCode == 400 {
                        // Check if it's a free tier limitation
                        if let responseString = String(data: data, encoding: .utf8),
                           responseString.contains("free users") {
                            throw NSError(domain: "API", code: 400, userInfo: [NSLocalizedDescriptionKey: "This endpoint is currently down for free users. Please try other features or upgrade to premium."])
                        }
                        throw NSError(domain: "API", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid request. Please check your search terms."])
                    } else if httpResponse.statusCode == 401 {
                        throw NSError(domain: "API", code: 401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized: Invalid API Key"])
                    } else if httpResponse.statusCode == 429 {
                        throw NSError(domain: "API", code: 429, userInfo: [NSLocalizedDescriptionKey: "Rate limit exceeded. Please try again later."])
                    }
                    throw URLError(.badServerResponse)
                }
            }
            
            // Decode the response
            let decoder = JSONDecoder()
            let nutrition = try decoder.decode([Nutrition].self, from: data)
            return nutrition
            
        } catch let decodingError as DecodingError {
            // Handle decoding errors with detailed information
            switch decodingError {
            case .dataCorrupted(let context):
                print("Data corrupted: \(context)")
            case .keyNotFound(let key, let context):
                print("Key '\(key)' not found: \(context.debugDescription)")
            case .typeMismatch(let type, let context):
                print("Type mismatch for type '\(type)': \(context.debugDescription)")
            case .valueNotFound(let type, let context):
                print("Value not found for type '\(type)': \(context.debugDescription)")
            @unknown default:
                print("Unknown decoding error")
            }
            throw decodingError
        } catch {
            throw error
        }
    }
    
    // Fetch Recipe Data
    func fetchRecipe(query: String) async throws -> [Recipe] {
        guard !query.isEmpty else { return [] }
        
        let urlString = "\(baseURL)/recipe?query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Check for HTTP errors
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    if httpResponse.statusCode == 400 {
                        throw NSError(domain: "API", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid request. Please check your search terms."])
                    }
                    throw URLError(.badServerResponse)
                }
            }
            
            let recipes = try JSONDecoder().decode([Recipe].self, from: data)
            return recipes
        } catch {
            throw error
        }
    }
    
    // Fetch Exercise Data
    func fetchExercises(muscle: String? = nil, type: String? = nil) async throws -> [Exercise] {
        var urlString = "\(baseURL)/exercises?"
        
        if let muscle = muscle, !muscle.isEmpty {
            urlString += "muscle=\(muscle.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        }
        if let type = type, !type.isEmpty {
            urlString += muscle != nil && !muscle!.isEmpty ? "&" : ""
            urlString += "type=\(type.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        }
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let exercises = try JSONDecoder().decode([Exercise].self, from: data)
        return exercises
    }
    
    // Fetch Calories Burned
    func fetchCaloriesBurned(activity: String, duration: Int? = nil) async throws -> [CaloriesBurned] {
        var urlString = "\(baseURL)/caloriesburned?activity=\(activity.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        
        if let duration = duration {
            urlString += "&duration=\(duration)"
        }
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let calories = try JSONDecoder().decode([CaloriesBurned].self, from: data)
        return calories
    }
    
    // Fetch Cocktail Data
    func fetchCocktail(name: String? = nil, ingredients: String? = nil) async throws -> [Cocktail] {
        var urlString = "\(baseURL)/cocktail?"
        
        if let name = name, !name.isEmpty {
            urlString += "name=\(name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        }
        if let ingredients = ingredients, !ingredients.isEmpty {
            urlString += name != nil && !name!.isEmpty ? "&" : ""
            urlString += "ingredients=\(ingredients.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        }
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let cocktails = try JSONDecoder().decode([Cocktail].self, from: data)
        return cocktails
    }
}
