//
//  CocktailSearchBar.swift
//  heathtracker
//
//  Created by Jack Vo on 8/7/25.
//

import SwiftUI

struct CocktailSearchBar: View {
    @Binding var searchText: String
    let onSearch: () -> Void
    @FocusState private var isSearchFieldFocused: Bool
    @State private var currentPlaceholderIndex = 0
    
    private let placeholders = [
        "Search cocktails... (e.g., margarita, mojito)",
        "Try 'martini', 'daiquiri', or 'old fashioned'",
        "Discover classics like 'manhattan' or 'negroni'",
        "Find favorites: 'cosmopolitan', 'whiskey sour'"
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "wineglass")
                        .foregroundColor(.pink)
                        .font(.title2)
                    
                    Text("Cocktail Finder")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
                
                HStack {
                    Text("Discover classic and modern cocktail recipes")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
            
            // Search input section
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.pink)
                        .font(.caption)
                    Text("🍹 Cocktail Name")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                
                TextField(placeholders[currentPlaceholderIndex], text: $searchText)
                    .focused($isSearchFieldFocused)
                    .font(.subheadline)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray6))
                            .stroke(isSearchFieldFocused ? Color.pink : Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .onSubmit {
                        isSearchFieldFocused = false
                        onSearch()
                    }
                    .submitLabel(.search)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Search") {
                                isSearchFieldFocused = false
                                onSearch()
                            }
                            .foregroundColor(.pink)
                            .fontWeight(.medium)
                        }
                    }
            }
            
            // Quick cocktail suggestions
            VStack(alignment: .leading, spacing: 8) {
                Text("Popular Cocktails:")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 8) {
                    ForEach(["Margarita", "Mojito", "Martini", "Daiquiri", "Manhattan", "Negroni"], id: \.self) { cocktail in
                        Button(cocktail) {
                            searchText = cocktail.lowercased()
                        }
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.pink.opacity(0.15))
                        .foregroundColor(.pink)
                        .cornerRadius(6)
                    }
                }
            }
            
            // Search button
            Button(action: {
                isSearchFieldFocused = false
                onSearch()
            }) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Find Cocktails")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.pink, Color.purple]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
            }
            .disabled(searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .opacity(searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.6 : 1.0)
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
    
    private func startPlaceholderTimer() {
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                currentPlaceholderIndex = (currentPlaceholderIndex + 1) % placeholders.count
            }
        }
    }
}

// Compact version of the cocktail search bar
struct CompactCocktailSearchBar: View {
    @Binding var searchText: String
    let onSearch: () -> Void
    let onExpand: () -> Void
    @FocusState private var isSearchFieldFocused: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            // Compact search field
            TextField("Search cocktails...", text: $searchText)
                .focused($isSearchFieldFocused)
                .font(.subheadline)
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray6))
                        .stroke(Color.pink.opacity(0.3), lineWidth: 1)
                )
                .onSubmit {
                    isSearchFieldFocused = false
                    onSearch()
                }
                .submitLabel(.search)
            
            // Search button
            Button(action: {
                isSearchFieldFocused = false
                onSearch()
            }) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 28, height: 28)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.pink, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(6)
            }
            
            // Expand button
            Button(action: onExpand) {
                Image(systemName: "chevron.down")
                    .font(.caption)
                    .foregroundColor(.pink)
                    .padding(6)
                    .background(
                        Circle()
                            .fill(Color.pink.opacity(0.15))
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
}
