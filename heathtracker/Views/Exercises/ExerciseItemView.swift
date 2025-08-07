//
//  ExerciseItemView.swift
//  heathtracker
//
//  Created by Jack Vo on 8/7/25.
//

import SwiftUI

struct ExerciseItemView: View {
    let exercise: Exercise
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header section with exercise name
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(formatDisplayText(exercise.name))
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    Text("🏋️ Exercise Guide")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Difficulty indicator
                VStack(alignment: .trailing, spacing: 2) {
                    HStack(spacing: 4) {
                        ForEach(0..<getDifficultyLevel(exercise.difficulty), id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .foregroundColor(.orange)
                                .font(.caption2)
                        }
                        ForEach(getDifficultyLevel(exercise.difficulty)..<3, id: \.self) { _ in
                            Image(systemName: "star")
                                .foregroundColor(.orange.opacity(0.3))
                                .font(.caption2)
                        }
                    }
                    
                    Text(formatDisplayText(exercise.difficulty))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.orange.opacity(0.15))
                        .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 12)
            
            Divider()
                .background(Color.gray.opacity(0.3))
            
            // Exercise details
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title3)
                    Text("Exercise Details")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ExerciseDetailCard(
                        icon: "figure.walk",
                        label: "Type",
                        value: formatDisplayText(exercise.type),
                        color: .blue
                    )
                    
                    ExerciseDetailCard(
                        icon: "figure.arms.open",
                        label: "Target Muscle",
                        value: formatDisplayText(exercise.muscle),
                        color: .purple
                    )
                    
                    ExerciseDetailCard(
                        icon: "dumbbell.fill",
                        label: "Equipment",
                        value: formatDisplayText(exercise.equipment),
                        color: .green
                    )
                    
                    ExerciseDetailCard(
                        icon: "star.fill",
                        label: "Difficulty",
                        value: formatDisplayText(exercise.difficulty),
                        color: .orange
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            
            // Instructions section (collapsible)
            if isExpanded {
                Divider()
                    .background(Color.gray.opacity(0.3))
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "list.number")
                            .foregroundColor(.indigo)
                            .font(.title3)
                        Text("Instructions")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                    }
                    
                    Text(exercise.instructions)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .lineSpacing(4)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6))
                                .stroke(Color.indigo.opacity(0.2), lineWidth: 1)
                        )
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
            
            // Toggle instructions button
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                    Text(isExpanded ? "Hide Instructions" : "Show Instructions")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    Rectangle()
                        .fill(Color.blue.opacity(0.08))
                )
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
        )
        .padding(.horizontal, 4)
        .padding(.vertical, 6)
    }
    
    private func formatDisplayText(_ text: String) -> String {
        return text.replacingOccurrences(of: "_", with: " ")
                  .split(separator: " ")
                  .map { $0.capitalized }
                  .joined(separator: " ")
    }
    
    private func getDifficultyLevel(_ difficulty: String) -> Int {
        switch difficulty.lowercased() {
        case "beginner":
            return 1
        case "intermediate":
            return 2
        case "expert":
            return 3
        default:
            return 1
        }
    }
}

// Helper view for exercise detail cards
struct ExerciseDetailCard: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.caption)
                Text(label)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                Spacer()
            }
            
            HStack {
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                Spacer()
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(color.opacity(0.08))
                .stroke(color.opacity(0.2), lineWidth: 1)
        )
    }
}
