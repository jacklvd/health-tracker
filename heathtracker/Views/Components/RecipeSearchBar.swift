//
//  RecipeSearchBar.swift
//  heathtracker
//
//  Created by Jack Vo on 8/7/25.
//

import SwiftUI

struct RecipeSearchBar: View {
    @Binding var text: String
    let onSearch: () -> Void
    @FocusState private var isTextFieldFocused: Bool
    @State private var currentPlaceholderIndex = 0
    
    private let placeholders = [
        "Search for recipes... (e.g., pasta, chicken curry)",
        "Try 'chocolate cake' or 'beef stir fry'",
        "Search 'vegetarian lasagna' or 'grilled salmon'",
        "Enter dishes like 'pizza' or 'chicken soup'"
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            // Search input section
            HStack(spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                        .font(.system(size: 16))
                    
                    TextField("", text: $text, prompt: Text(currentPlaceholder).foregroundColor(.secondary))
                        .focused($isTextFieldFocused)
                        .onSubmit {
                            isTextFieldFocused = false
                            onSearch()
                        }
                        .submitLabel(.search)
                        .font(.system(size: 16))
                    
                    if !text.isEmpty {
                        Button(action: {
                            text = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                                .font(.system(size: 14))
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                        .stroke(isTextFieldFocused ? Color.green : Color.clear, lineWidth: 2)
                )
                
                Button(action: {
                    isTextFieldFocused = false
                    onSearch()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [.green, .blue]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                    )
                    .shadow(color: .green.opacity(0.3), radius: 2, x: 0, y: 1)
                }
                .disabled(text.isEmpty)
                .opacity(text.isEmpty ? 0.6 : 1.0)
            }
            
            // Quick search suggestions
            if text.isEmpty && !isTextFieldFocused {
                VStack(alignment: .leading, spacing: 8) {
                    Text("🍽️ Popular Recipes:")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(quickSearchSuggestions, id: \.self) { suggestion in
                                Button(action: {
                                    text = suggestion
                                    onSearch()
                                }) {
                                    Text(suggestion)
                                        .font(.caption)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            Capsule()
                                                .fill(Color.green.opacity(0.1))
                                                .stroke(Color.green.opacity(0.3), lineWidth: 1)
                                        )
                                        .foregroundColor(.green)
                                }
                            }
                        }
                        .padding(.horizontal, 2)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .onAppear {
            startPlaceholderRotation()
        }
    }
    
    private var currentPlaceholder: String {
        placeholders[currentPlaceholderIndex]
    }
    
    private let quickSearchSuggestions = [
        "pasta", "pizza", "chicken curry", "beef stew", "chocolate cake", "salmon", "soup", "salad"
    ]
    
    private func startPlaceholderRotation() {
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                currentPlaceholderIndex = (currentPlaceholderIndex + 1) % placeholders.count
            }
        }
    }
}
