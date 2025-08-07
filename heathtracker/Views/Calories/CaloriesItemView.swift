//
//  CaloriesItemView.swift
//  heathtracker
//
//  Created by Jack Vo on 8/7/25.
//

import SwiftUI

struct CaloriesItemView: View {
    let calories: CaloriesBurned
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header section with activity name and total calories
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(calories.name.capitalized)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("🔥 Calorie Burn Calculator")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(String(format: "%.0f", calories.total_calories))")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    
                    Text("calories burned")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.orange.opacity(0.15))
                        .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 12)
            
            Divider()
                .background(Color.gray.opacity(0.3))
            
            // Detailed breakdown
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "chart.bar.fill")
                        .foregroundColor(.blue)
                        .font(.title3)
                    Text("Activity Breakdown")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    CalorieMetricCard(
                        icon: "speedometer",
                        label: "Intensity",
                        value: "\(String(format: "%.0f", calories.calories_per_hour)) cal/hr",
                        color: .blue
                    )
                    
                    CalorieMetricCard(
                        icon: "clock.fill",
                        label: "Duration",
                        value: "\(String(format: "%.0f", calories.duration_minutes)) min",
                        color: .green
                    )
                    
                    CalorieMetricCard(
                        icon: "figure.run",
                        label: "Activity",
                        value: calories.name.capitalized,
                        color: .purple
                    )
                    
                    CalorieMetricCard(
                        icon: "flame.fill",
                        label: "Total Burn",
                        value: "\(String(format: "%.0f", calories.total_calories)) cal",
                        color: .orange
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

// Helper view for calorie metric cards
struct CalorieMetricCard: View {
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
                    .lineLimit(1)
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
