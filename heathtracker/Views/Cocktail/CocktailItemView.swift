//
//  CocktailItemView.swift
//  heathtracker
//
//  Created by Jack Vo on 8/7/25.
//

import SwiftUI

struct CocktailItemView: View {
    let cocktail: Cocktail
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header section with cocktail name
            VStack(alignment: .leading, spacing: 4) {
                Text(cocktail.name.capitalized)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("🍸 Cocktail Recipe")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Divider()
                .background(Color.gray.opacity(0.3))
            
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
                
                LazyVGrid(columns: [GridItem(.flexible())], spacing: 8) {
                    ForEach(Array(cocktail.ingredients.enumerated()), id: \.offset) { index, ingredient in
                        HStack(alignment: .top, spacing: 8) {
                            Text("\(index + 1).")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                                .frame(width: 20, alignment: .leading)
                            
                            Text(ingredient)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.orange.opacity(0.1))
                                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                        )
                    }
                }
            }
            
            // Instructions section
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "doc.text.fill")
                        .foregroundColor(.green)
                        .font(.title3)
                    Text("Instructions")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                
                Text(cocktail.instructions)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineSpacing(4)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.green.opacity(0.1))
                            .stroke(Color.green.opacity(0.3), lineWidth: 1)
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal, 4)
        .padding(.vertical, 4)
    }
}
