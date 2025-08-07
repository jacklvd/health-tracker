//
//  CaloriesViewModel.swift
//  heathtracker
//
//  Created by Jack Vo on 8/7/25.
//

import Foundation

class CaloriesViewModel: ObservableObject {
    @Published var caloriesBurned: [CaloriesBurned] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var activityQuery = ""
    @Published var duration = "30"
    
    private let apiService = APIService()
    
    func searchCaloriesBurned() async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            let items = try await apiService.fetchCaloriesBurned(
                activity: activityQuery,
                duration: Int(duration)
            )
            await MainActor.run {
                self.caloriesBurned = items
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
