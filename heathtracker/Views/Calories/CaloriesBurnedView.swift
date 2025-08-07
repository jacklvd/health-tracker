//
//  CaloriesBurnedView.swift
//  heathtracker
//
//  Created by Jack Vo on 8/7/25.
//

import SwiftUI

struct CaloriesBurnedView: View {
    @StateObject private var viewModel = CaloriesViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Custom search header
                VStack(spacing: 0) {
                    CaloriesSearchBar(
                        activityText: $viewModel.activityQuery,
                        durationText: $viewModel.duration,
                        onCalculate: {
                            Task {
                                await viewModel.searchCaloriesBurned()
                            }
                        }
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 8)
                    
                    if viewModel.isLoading {
                        HStack {
                            ProgressView()
                                .scaleEffect(0.8)
                            Text("Calculating calories...")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.bottom, 8)
                    }
                }
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.orange.opacity(0.1),
                            Color.clear
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea(edges: .top)
                )
                
                // Results section
                if !viewModel.caloriesBurned.isEmpty {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            // Results header
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Calorie Calculations")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                    
                                    Text("\(viewModel.caloriesBurned.count) result\(viewModel.caloriesBurned.count == 1 ? "" : "s") found")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "flame.fill")
                                    .foregroundColor(.orange)
                                    .font(.title2)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 16)
                            .padding(.bottom, 8)
                            
                            // Calorie items
                            ForEach(viewModel.caloriesBurned) { calories in
                                CaloriesItemView(calories: calories)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                    }
                } else if !viewModel.isLoading {
                    // Empty state
                    VStack(spacing: 16) {
                        Spacer()
                        
                        Image(systemName: "flame")
                            .font(.system(size: 60))
                            .foregroundColor(.orange.opacity(0.6))
                        
                        VStack(spacing: 8) {
                            Text("Calculate Calories Burned")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("Enter an activity and duration to see how many calories you'll burn")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        
                        // Example suggestions
                        VStack(spacing: 8) {
                            Text("Try these activities:")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                            
                            HStack(spacing: 8) {
                                ForEach(["Running", "Cycling", "Swimming"], id: \.self) { activity in
                                    Button(activity) {
                                        viewModel.activityQuery = activity.lowercased()
                                        viewModel.duration = "30"
                                    }
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.orange.opacity(0.15))
                                    .foregroundColor(.orange)
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
