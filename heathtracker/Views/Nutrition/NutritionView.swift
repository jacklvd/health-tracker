//
//  NutritionView.swift
//  heathtracker
//
//  Created by Jack Vo on 8/7/25.
//

import SwiftUI

struct NutritionView: View {
    @StateObject private var viewModel = NutritionViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Enhanced search section
                VStack(spacing: 16) {
                    NutritionSearchBar(text: $viewModel.searchQuery, onSearch: {
                        Task {
                            await viewModel.searchNutrition()
                        }
                    })
                    
                    // Total calories display
                    if !viewModel.nutritionItems.isEmpty {
                        HStack {
                            Image(systemName: "flame.fill")
                                .foregroundColor(.orange)
                                .font(.title3)
                            
                            if viewModel.totalCalories > 0 {
                                Text("Total: \(String(format: "%.0f", viewModel.totalCalories)) calories")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                            } else {
                                Text("Total calories require premium subscription")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.orange)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.orange.opacity(0.1))
                                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.top, 8)
                .background(Color(.systemGroupedBackground))
                
                // Content area
                if viewModel.isLoading {
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.2)
                        Text("Searching nutrition data...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemGroupedBackground))
                } else if viewModel.nutritionItems.isEmpty && !viewModel.searchQuery.isEmpty {
                    // Empty state
                    VStack(spacing: 16) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 40))
                            .foregroundColor(.secondary)
                        
                        Text("No nutrition data found")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("Try searching for specific foods like 'apple', 'chicken breast', or '1 cup rice'")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemGroupedBackground))
                } else {
                    // Results list
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.nutritionItems) { item in
                                NutritionItemView(nutrition: item)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 16)
                    }
                    .background(Color(.systemGroupedBackground))
                    .refreshable {
                        if !viewModel.searchQuery.isEmpty {
                            await viewModel.searchNutrition()
                        }
                    }
                }
                
                // Error display
                if let error = viewModel.errorMessage {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                            .font(.title2)
                        
                        Text("Error")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(error)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(.vertical, 20)
                    .background(Color(.systemGroupedBackground))
                }
            }
            .navigationTitle("Nutrition Tracker")
        }
    }
}

