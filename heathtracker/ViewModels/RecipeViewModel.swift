//
//  RecipeViewModel.swift
//  heathtracker
//
//  Created by Jack Vo on 8/7/25.
//

import Foundation

class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchQuery = ""
    
    private let apiService = APIService()
    
    func searchRecipes() async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            let items = try await apiService.fetchRecipe(query: searchQuery)
            await MainActor.run {
                self.recipes = items
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}
