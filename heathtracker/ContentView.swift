//
//  ContentView.swift
//  heathtracker
//
//  Created by Jack Vo on 8/7/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NutritionView()
                .tabItem {
                    Label("Nutrition", systemImage: "leaf.fill")
                }
                .tag(0)
            
            RecipeView()
                .tabItem {
                    Label("Recipes", systemImage: "book.fill")
                }
                .tag(1)
            
            ExerciseView()
                .tabItem {
                    Label("Exercises", systemImage: "figure.run")
                }
                .tag(2)
            
            CaloriesBurnedView()
                .tabItem {
                    Label("Calories", systemImage: "flame.fill")
                }
                .tag(3)
            
            CocktailView()
                .tabItem {
                    Label("Cocktails", systemImage: "wineglass.fill")
                }
                .tag(4)
        }
        .onChange(of: selectedTab) {
            hideKeyboard()
        }
    }
}
