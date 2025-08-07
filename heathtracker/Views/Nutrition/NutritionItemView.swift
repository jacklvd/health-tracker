//
//  NutritionItemView.swift
//  heathtracker
//
//  Created by Jack Vo on 8/7/25.
//

import SwiftUI

struct NutritionItemView: View {
    let nutrition: Nutrition
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header section with food name
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(nutrition.name.capitalized)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    if let calories = nutrition.calories {
                        HStack(spacing: 4) {
                            Image(systemName: "flame.fill")
                                .foregroundColor(.orange)
                                .font(.caption)
                            Text("\(String(format: "%.0f", calories)) cal")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.orange)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.orange.opacity(0.15))
                        )
                    }
                }
                
                Text("🥗 Nutritional Information")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 12)
            
            Divider()
                .background(Color.gray.opacity(0.3))
            
            // Nutrition details grid
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                if let protein = nutrition.proteinG {
                    NutritionValueCard(
                        icon: "figure.strengthtraining.traditional",
                        label: "Protein",
                        value: "\(String(format: "%.1f", protein))g",
                        color: .blue
                    )
                }
                
                if let carbs = nutrition.carbohydratesTotalG {
                    NutritionValueCard(
                        icon: "bolt.fill",
                        label: "Carbs",
                        value: "\(String(format: "%.1f", carbs))g",
                        color: .green
                    )
                }
                
                if let fat = nutrition.fatTotalG {
                    NutritionValueCard(
                        icon: "drop.fill",
                        label: "Fat",
                        value: "\(String(format: "%.1f", fat))g",
                        color: .purple
                    )
                }
                
                if let fiber = nutrition.fiberG {
                    NutritionValueCard(
                        icon: "leaf.fill",
                        label: "Fiber",
                        value: "\(String(format: "%.1f", fiber))g",
                        color: .brown
                    )
                }
                
                if let sugar = nutrition.sugarG {
                    NutritionValueCard(
                        icon: "cube.fill",
                        label: "Sugar",
                        value: "\(String(format: "%.1f", sugar))g",
                        color: .pink
                    )
                }
                
                if let sodium = nutrition.sodiumMg {
                    NutritionValueCard(
                        icon: "minus.circle.fill",
                        label: "Sodium",
                        value: "\(String(format: "%.0f", sodium))mg",
                        color: .red
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
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
}

// Helper view for nutrition value cards
struct NutritionValueCard: View {
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
