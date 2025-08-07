//
//  CocktailView.swift
//  heathtracker
//
//  Created by Jack Vo on 8/7/25.
//

import SwiftUI

struct CocktailView: View {
    @State private var cocktails: [Cocktail] = []
    @State private var searchQuery = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var isSearchCompact = false
    private let apiService = APIService()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Custom search header
                VStack(spacing: 0) {
                    if isSearchCompact && !cocktails.isEmpty {
                        // Compact search bar when results are shown
                        CompactCocktailSearchBar(
                            searchText: $searchQuery,
                            onSearch: {
                                Task {
                                    await searchCocktails()
                                }
                            },
                            onExpand: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isSearchCompact = false
                                }
                            }
                        )
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    } else {
                        // Full search bar
                        CocktailSearchBar(
                            searchText: $searchQuery,
                            onSearch: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isSearchCompact = true
                                }
                                Task {
                                    await searchCocktails()
                                }
                            }
                        )
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                        .padding(.bottom, 8)
                    }
                    
                    if isLoading {
                        HStack {
                            ProgressView()
                                .scaleEffect(0.8)
                            Text("Finding cocktails...")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.bottom, 8)
                    }
                }
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.pink.opacity(0.1),
                            Color.clear
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea(edges: .top)
                )
                
                // Results section
                if !cocktails.isEmpty {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            // Results header
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Cocktail Results")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                    
                                    Text("\(cocktails.count) cocktail\(cocktails.count == 1 ? "" : "s") found")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "wineglass.fill")
                                    .foregroundColor(.pink)
                                    .font(.title2)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 16)
                            .padding(.bottom, 8)
                            
                            // Cocktail items
                            ForEach(cocktails) { cocktail in
                                CocktailItemView(cocktail: cocktail)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                    }
                    .refreshable {
                        if !searchQuery.isEmpty {
                            await searchCocktails()
                        }
                    }
                } else if !isLoading {
                    // Empty state
                    VStack(spacing: 16) {
                        Spacer()
                        
                        Image(systemName: "wineglass")
                            .font(.system(size: 60))
                            .foregroundColor(.pink.opacity(0.6))
                        
                        VStack(spacing: 8) {
                            Text("Discover Amazing Cocktails")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("Search for your favorite cocktail recipes and discover new drinks")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        
                        // Popular cocktail suggestions
                        VStack(spacing: 8) {
                            Text("Try these classics:")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 8) {
                                ForEach(["Margarita", "Mojito", "Martini", "Manhattan"], id: \.self) { cocktail in
                                    Button(cocktail) {
                                        searchQuery = cocktail.lowercased()
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            isSearchCompact = true
                                        }
                                        Task {
                                            await searchCocktails()
                                        }
                                    }
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.pink.opacity(0.15))
                                    .foregroundColor(.pink)
                                    .cornerRadius(8)
                                }
                            }
                        }
                        .padding(.top, 8)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 32)
                }
                
                Spacer()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .onTapGesture {
                hideKeyboard()
            }
            .alert("Error", isPresented: .constant(errorMessage?.isEmpty == false)) {
                Button("OK") {
                    errorMessage = nil
                }
            } message: {
                Text(errorMessage ?? "")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func searchCocktails() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let items = try await apiService.fetchCocktail(name: searchQuery)
            await MainActor.run {
                self.cocktails = items
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}
