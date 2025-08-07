//
//  ExerciseView.swift
//  heathtracker
//
//  Created by Jack Vo on 8/7/25.
//

import SwiftUI

struct ExerciseView: View {
    @StateObject private var viewModel = ExerciseViewModel()
    @State private var isSearchCompact = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Custom search header
                VStack(spacing: 0) {
                    if isSearchCompact && !viewModel.exercises.isEmpty {
                        // Compact search bar when results are shown
                        CompactExerciseSearchBar(
                            selectedMuscle: $viewModel.selectedMuscle,
                            selectedType: $viewModel.selectedType,
                            muscleGroups: viewModel.muscleGroups,
                            exerciseTypes: viewModel.exerciseTypes,
                            onSearch: {
                                hideKeyboard()
                                Task {
                                    await viewModel.searchExercises()
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
                        ExerciseSearchBar(
                            selectedMuscle: $viewModel.selectedMuscle,
                            selectedType: $viewModel.selectedType,
                            muscleGroups: viewModel.muscleGroups,
                            exerciseTypes: viewModel.exerciseTypes,
                            onSearch: {
                                hideKeyboard()
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isSearchCompact = true
                                }
                                Task {
                                    await viewModel.searchExercises()
                                }
                            }
                        )
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                        .padding(.bottom, 8)
                    }
                    
                    if viewModel.isLoading {
                        HStack {
                            ProgressView()
                                .scaleEffect(0.8)
                            Text("Finding exercises...")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.bottom, 8)
                    }
                }
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.blue.opacity(0.1),
                            Color.clear
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea(edges: .top)
                )
                
                // Results section
                if !viewModel.exercises.isEmpty {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            // Results header
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Exercise Results")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                    
                                    Text("\(viewModel.exercises.count) exercise\(viewModel.exercises.count == 1 ? "" : "s") found")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "figure.strengthtraining.traditional")
                                    .foregroundColor(.blue)
                                    .font(.title2)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 16)
                            .padding(.bottom, 8)
                            
                            // Exercise items
                            ForEach(viewModel.exercises) { exercise in
                                ExerciseItemView(exercise: exercise)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                    }
                } else if !viewModel.isLoading {
                    // Empty state
                    VStack(spacing: 16) {
                        Spacer()
                        
                        Image(systemName: "figure.strengthtraining.traditional")
                            .font(.system(size: 60))
                            .foregroundColor(.blue.opacity(0.6))
                        
                        VStack(spacing: 8) {
                            Text("Find Your Perfect Exercise")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("Select a muscle group and exercise type to discover targeted workouts")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        
                        // Popular muscle group suggestions
                        VStack(spacing: 8) {
                            Text("Popular targets:")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 8) {
                                ForEach(["Abdominals", "Chest", "Biceps", "Quadriceps"], id: \.self) { muscle in
                                    Button(muscle) {
                                        viewModel.selectedMuscle = muscle.lowercased()
                                        viewModel.selectedType = ""
                                    }
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.blue.opacity(0.15))
                                    .foregroundColor(.blue)
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
            .alert("Error", isPresented: .constant(viewModel.errorMessage?.isEmpty == false)) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
