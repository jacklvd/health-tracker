//
//  CaloriesSearchBar.swift
//  heathtracker
//
//  Created by Jack Vo on 8/7/25.
//

import SwiftUI

struct CaloriesSearchBar: View {
    @Binding var activityText: String
    @Binding var durationText: String
    let onCalculate: () -> Void
    @FocusState private var isActivityFieldFocused: Bool
    @FocusState private var isDurationFieldFocused: Bool
    @State private var currentPlaceholderIndex = 0
    
    private let placeholders = [
        "Enter activity... (e.g., running, cycling)",
        "Try 'swimming', 'yoga', or 'dancing'",
        "Search 'basketball', 'walking', or 'hiking'",
        "Activities like 'tennis' or 'weightlifting'"
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            // Activity input section
            VStack(alignment: .leading, spacing: 8) {
                Text("🏃‍♀️ Activity")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                HStack(spacing: 8) {
                    Image(systemName: "figure.run")
                        .foregroundColor(.secondary)
                        .font(.system(size: 16))
                    
                    TextField("", text: $activityText, prompt: Text(currentPlaceholder).foregroundColor(.secondary))
                        .focused($isActivityFieldFocused)
                        .onSubmit {
                            isDurationFieldFocused = true
                        }
                        .submitLabel(.next)
                        .font(.system(size: 16))
                    
                    if !activityText.isEmpty {
                        Button(action: {
                            activityText = ""
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
                        .stroke(isActivityFieldFocused ? Color.orange : Color.clear, lineWidth: 2)
                )
            }
            
            // Duration input section
            VStack(alignment: .leading, spacing: 8) {
                Text("⏱️ Duration")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                HStack(spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "clock.fill")
                            .foregroundColor(.secondary)
                            .font(.system(size: 16))
                        
                        TextField("30", text: $durationText)
                            .focused($isDurationFieldFocused)
                            .keyboardType(.numberPad)
                            .font(.system(size: 16))
                            .frame(width: 60)
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    Button("Done") {
                                        isDurationFieldFocused = false
                                    }
                                }
                            }
                        
                        Text("minutes")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                            .stroke(isDurationFieldFocused ? Color.orange : Color.clear, lineWidth: 2)
                    )
                    
                    Spacer()
                }
            }
            
            // Calculate button
            Button(action: {
                isActivityFieldFocused = false
                isDurationFieldFocused = false
                onCalculate()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "flame.fill")
                    Text("Calculate Calories Burned")
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [.orange, .red]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                )
                .shadow(color: .orange.opacity(0.3), radius: 3, x: 0, y: 2)
            }
            .disabled(activityText.isEmpty || durationText.isEmpty)
            .opacity(activityText.isEmpty || durationText.isEmpty ? 0.6 : 1.0)
            
            // Quick activity suggestions
            if activityText.isEmpty && !isActivityFieldFocused {
                VStack(alignment: .leading, spacing: 8) {
                    Text("🔥 Popular Activities:")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(quickActivitySuggestions, id: \.self) { activity in
                                Button(action: {
                                    activityText = activity
                                    isDurationFieldFocused = true
                                }) {
                                    Text(activity)
                                        .font(.caption)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            Capsule()
                                                .fill(Color.orange.opacity(0.1))
                                                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                                        )
                                        .foregroundColor(.orange)
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
    
    private let quickActivitySuggestions = [
        "running", "walking", "cycling", "swimming", "yoga", "dancing", "basketball", "tennis"
    ]
    
    private func startPlaceholderRotation() {
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                currentPlaceholderIndex = (currentPlaceholderIndex + 1) % placeholders.count
            }
        }
    }
}
