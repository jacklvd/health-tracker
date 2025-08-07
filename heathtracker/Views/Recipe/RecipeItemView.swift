//
//  RecipeItemView.swift
//  heathtracker
//
//  Created by Jack Vo on 8/7/25.
//

import SwiftUI

struct RecipeItemView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header section with recipe title and servings
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(recipe.title.capitalized)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    Spacer()
                }
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "person.2.fill")
                            .foregroundColor(.green)
                            .font(.caption)
                        Text(recipe.servings)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Color.green.opacity(0.15))
                    )
                    
                    Text("🍽️ Complete Recipe")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 12)
            
            Divider()
                .background(Color.gray.opacity(0.3))
            
            // Recipe content
            VStack(alignment: .leading, spacing: 16) {
                // Ingredients section
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "list.bullet.circle.fill")
                            .foregroundColor(.orange)
                            .font(.title3)
                        Text("Ingredients")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                    }
                    
                    Text(formatIngredients(recipe.ingredients))
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .lineSpacing(4)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.orange.opacity(0.08))
                                .stroke(Color.orange.opacity(0.2), lineWidth: 1)
                        )
                }
                
                // Instructions section
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "doc.text.fill")
                            .foregroundColor(.blue)
                            .font(.title3)
                        Text("Instructions")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                    }
                    
                    Text(recipe.instructions)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .lineSpacing(6)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue.opacity(0.08))
                                .stroke(Color.blue.opacity(0.2), lineWidth: 1)
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
    
    // Helper function to format ingredients with better readability
    private func formatIngredients(_ ingredients: String) -> String {
        // Split by pipe character and format as a numbered list
        let ingredientList = ingredients.components(separatedBy: "|")
        return ingredientList.enumerated().map { index, ingredient in
            "\(index + 1). \(ingredient.trimmingCharacters(in: .whitespaces))"
        }.joined(separator: "\n")
    }
}
