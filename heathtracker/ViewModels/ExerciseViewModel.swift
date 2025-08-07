//
//  ExerciseViewModel.swift
//  heathtracker
//
//  Created by Jack Vo on 8/7/25.
//

import Foundation

class ExerciseViewModel: ObservableObject {
    @Published var exercises: [Exercise] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedMuscle = ""
    @Published var selectedType = ""
    
    private let apiService = APIService()
    
    let muscleGroups = ["abdominals", "biceps", "chest", "glutes", "hamstrings", "lats", "quadriceps", "triceps"]
    let exerciseTypes = ["cardio", "strength", "stretching", "plyometrics", "powerlifting"]
    
    func searchExercises() async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            let items = try await apiService.fetchExercises(
                muscle: selectedMuscle.isEmpty ? nil : selectedMuscle,
                type: selectedType.isEmpty ? nil : selectedType
            )
            await MainActor.run {
                self.exercises = items
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
