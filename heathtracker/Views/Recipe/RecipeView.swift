//
//  RecipeView.swift
//  heathtracker
//
//  Created by Jack Vo on 8/7/25.
//

import SwiftUI

struct RecipeView: View {
    @StateObject private var viewModel = RecipeViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Enhanced search section
                VStack(spacing: 16) {
                    RecipeSearchBar(text: $viewModel.searchQuery, onSearch: {
                        Task {
                            await viewModel.searchRecipes()
                        }
                    })
                    
                    // Recipe count display
                    if !viewModel.recipes.isEmpty {
                        HStack {
                            Image(systemName: "book.fill")
                                .foregroundColor(.green)
                                .font(.title3)
                            
                            Text("Found \(viewModel.recipes.count) recipe\(viewModel.recipes.count == 1 ? "" : "s")")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.green.opacity(0.1))
                                .stroke(Color.green.opacity(0.3), lineWidth: 1)
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
                        Text("Searching for delicious recipes...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemGroupedBackground))
                } else if viewModel.recipes.isEmpty && !viewModel.searchQuery.isEmpty {
                    // Empty state
                    VStack(spacing: 16) {
                        Image(systemName: "book.closed")
                            .font(.system(size: 40))
                            .foregroundColor(.secondary)
                        
                        Text("No recipes found")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("Try searching for dishes like 'pasta', 'chicken curry', or 'chocolate cake'")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemGroupedBackground))
                } else if viewModel.recipes.isEmpty {
                    // Initial state
                    VStack(spacing: 20) {
                        Image(systemName: "fork.knife.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)
                        
                        Text("Discover Amazing Recipes")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("Search for your favorite dishes and discover step-by-step cooking instructions")
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
                            ForEach(viewModel.recipes) { recipe in
                                RecipeItemView(recipe: recipe)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 16)
                    }
                    .background(Color(.systemGroupedBackground))
                    .refreshable {
                        if !viewModel.searchQuery.isEmpty {
                            await viewModel.searchRecipes()
                        }
                    }
                }
                
                // Error display
                if let error = viewModel.errorMessage {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                            .font(.title2)
                        
                        Text("Oops! Something went wrong")
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
            .navigationTitle("Recipe Finder")
        }
    }
}
