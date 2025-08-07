//
//  ExerciseSearchBar.swift
//  heathtracker
//
//  Created by Jack Vo on 8/7/25.
//

import SwiftUI

struct ExerciseSearchBar: View {
    @Binding var selectedMuscle: String
    @Binding var selectedType: String
    let muscleGroups: [String]
    let exerciseTypes: [String]
    let onSearch: () -> Void
    @State private var currentPlaceholderIndex = 0
    
    private let muscleGroupsPlaceholders = [
        "Select target muscle group...",
        "Choose from abs, chest, back...",
        "Pick biceps, legs, shoulders...",
        "Target specific muscle groups"
    ]
    
    private let typePlaceholders = [
        "Choose exercise type...",
        "Strength, cardio, or stretching?",
        "Olympic, powerlifting, or plyometrics?",
        "Select your workout style"
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "figure.strengthtraining.traditional")
                        .foregroundColor(.blue)
                        .font(.title2)
                    
                    Text("Exercise Finder")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
                
                HStack {
                    Text("Find exercises by muscle group and type")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
            
            // Muscle Group Picker
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "figure.arms.open")
                        .foregroundColor(.purple)
                        .font(.caption)
                    Text("💪 Target Muscle")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                
                Picker("Muscle Group", selection: $selectedMuscle) {
                    Text("All Muscles").tag("")
                    ForEach(muscleGroups, id: \.self) { muscle in
                        Text(formatDisplayText(muscle)).tag(muscle)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray6))
                        .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                )
            }
            
            // Exercise Type Picker
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "dumbbell.fill")
                        .foregroundColor(.green)
                        .font(.caption)
                    Text("🏋️ Exercise Type")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                
                Picker("Exercise Type", selection: $selectedType) {
                    Text("All Types").tag("")
                    ForEach(exerciseTypes, id: \.self) { type in
                        Text(formatDisplayText(type)).tag(type)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray6))
                        .stroke(Color.green.opacity(0.3), lineWidth: 1)
                )
            }
            
            // Quick muscle suggestions
            VStack(alignment: .leading, spacing: 8) {
                Text("Quick Select:")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 8) {
                    ForEach(["abdominals", "chest", "biceps", "quadriceps", "shoulders", "back"], id: \.self) { muscle in
                        Button(formatDisplayText(muscle)) {
                            selectedMuscle = muscle
                            selectedType = ""
                        }
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.purple.opacity(0.15))
                        .foregroundColor(.purple)
                        .cornerRadius(6)
                    }
                }
            }
            
            // Search button
            Button(action: onSearch) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Find Exercises")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
        .onAppear {
            startPlaceholderTimer()
        }
    }
    
    private func formatDisplayText(_ text: String) -> String {
        return text.replacingOccurrences(of: "_", with: " ")
                  .split(separator: " ")
                  .map { $0.capitalized }
                  .joined(separator: " ")
    }
    
    private func startPlaceholderTimer() {
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                currentPlaceholderIndex = (currentPlaceholderIndex + 1) % muscleGroupsPlaceholders.count
            }
        }
    }
}

// Compact version of the search bar for when results are displayed
struct CompactExerciseSearchBar: View {
    @Binding var selectedMuscle: String
    @Binding var selectedType: String
    let muscleGroups: [String]
    let exerciseTypes: [String]
    let onSearch: () -> Void
    let onExpand: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Compact muscle picker
            Menu {
                Button("All Muscles") {
                    selectedMuscle = ""
                }
                ForEach(muscleGroups, id: \.self) { muscle in
                    Button(formatDisplayText(muscle)) {
                        selectedMuscle = muscle
                    }
                }
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "figure.arms.open")
                        .foregroundColor(.purple)
                        .font(.caption)
                    Text(selectedMuscle.isEmpty ? "Muscle" : formatDisplayText(selectedMuscle))
                        .font(.caption)
                        .fontWeight(.medium)
                        .lineLimit(1)
                    Image(systemName: "chevron.down")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.purple.opacity(0.15))
                        .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                )
            }
            
            // Compact type picker
            Menu {
                Button("All Types") {
                    selectedType = ""
                }
                ForEach(exerciseTypes, id: \.self) { type in
                    Button(formatDisplayText(type)) {
                        selectedType = type
                    }
                }
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "dumbbell.fill")
                        .foregroundColor(.green)
                        .font(.caption)
                    Text(selectedType.isEmpty ? "Type" : formatDisplayText(selectedType))
                        .font(.caption)
                        .fontWeight(.medium)
                        .lineLimit(1)
                    Image(systemName: "chevron.down")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.green.opacity(0.15))
                        .stroke(Color.green.opacity(0.3), lineWidth: 1)
                )
            }
            
            // Search button
            Button(action: onSearch) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 28, height: 28)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(6)
            }
            
            Spacer()
            
            // Expand button
            Button(action: onExpand) {
                Image(systemName: "chevron.down")
                    .font(.caption)
                    .foregroundColor(.blue)
                    .padding(6)
                    .background(
                        Circle()
                            .fill(Color.blue.opacity(0.15))
                    )
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
    }
    
    private func formatDisplayText(_ text: String) -> String {
        return text.replacingOccurrences(of: "_", with: " ")
                  .split(separator: " ")
                  .map { $0.capitalized }
                  .joined(separator: " ")
    }
}
