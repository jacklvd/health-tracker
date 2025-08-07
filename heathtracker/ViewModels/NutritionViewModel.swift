//
//  NutritionViewModel.swift
//  heathtracker
//
//  Created by Jack Vo on 8/7/25.
//

import Foundation

class NutritionViewModel: ObservableObject {
    @Published var nutritionItems: [Nutrition] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchQuery = ""
    @Published var totalCalories: Double = 0
    
    private let apiService = APIService()
    
    func searchNutrition() async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            let items = try await apiService.fetchNutrition(query: searchQuery)
            await MainActor.run {
                self.nutritionItems = items
                self.calculateTotalCalories()
                self.isLoading = false
                if items.isEmpty {
                    self.errorMessage = "No nutrition data found for '\(searchQuery)'"
                }
            }
        } catch {
            await MainActor.run {
                self.isLoading = false
                if error.localizedDescription.contains("400") {
                    self.errorMessage = "Invalid API Key. Please check your API key in APIService.swift"
                } else if error.localizedDescription.contains("couldn't be read") {
                    self.errorMessage = "Invalid response format. Please check your API key is correct."
                } else {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func calculateTotalCalories() {
        totalCalories = nutritionItems.reduce(0) { total, item in
            total + (item.calories ?? 0)
        }
    }
}
