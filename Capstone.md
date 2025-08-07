# HealthTracker

## Table of Contents

- [Overview](#overview)
- [Product Spec](#product-spec)
- [Wireframes](#wireframes)
- [Schema](#schema)

## Overview

### Description

HealthTracker is a comprehensive health and wellness iOS application that helps users monitor their nutrition intake, discover healthy recipes, track exercise routines, calculate calories burned, and explore cocktail recipes. The app integrates multiple health-related APIs to provide real-time nutritional data and personalized health insights, making it easier for users to maintain a balanced lifestyle.

### App Evaluation

- **Category**: Health & Fitness / Lifestyle
- **Mobile**: This app is primarily developed for mobile (iOS) as it leverages portability for on-the-go nutrition tracking, quick calorie lookups during meals, and exercise tracking during workouts. Mobile-specific features include camera integration for future food recognition and location services for nearby healthy restaurants.
- **Story**: Creates a seamless health tracking experience where users can instantly analyze their food choices, plan meals, track workouts, and monitor their overall caloric balance. The app tells the story of a user's daily health journey, from breakfast nutrition to evening workout calories burned.
- **Market**: The target market includes health-conscious individuals, fitness enthusiasts, people on specific diets, athletes, and anyone looking to improve their nutritional awareness. The global health and fitness app market is valued at billions with consistent growth, particularly post-pandemic.
- **Habit**: Users are expected to open the app 3-5 times daily - before meals to check nutrition, during workout planning, and for recipe discovery. The app creates healthy habits through daily calorie tracking and exercise reminders.
- **Scope**: V1 focuses on core nutrition tracking and exercise features. V2 could include meal planning, barcode scanning, and social features. V3 might add AI-powered meal suggestions and integration with fitness wearables. The initial scope is well-defined and achievable within a development sprint.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

- User can search for food items and view detailed nutritional information (calories, protein, carbs, fats, etc.)
- User can search and browse healthy recipes with ingredients and instructions
- User can browse exercises filtered by muscle group and exercise type
- User can calculate calories burned for various activities with custom duration
- User can search for cocktail recipes to understand their nutritional impact
- User can view aggregated daily calorie intake from searched foods
- User can navigate between different features using tab navigation
- User can pull to refresh data in list views
- User can expand/collapse detailed information in list items

**Optional Nice-to-have Stories**

- User can save favorite foods and recipes for quick access
- User can create a daily meal plan with automatic nutrition calculation
- User can set daily calorie goals and track progress
- User can scan barcodes to quickly add packaged foods
- User can view nutrition trends over time with charts
- User can share recipes with friends
- User can create custom workout routines
- User can sync data with Apple Health
- User can receive notifications for meal times and workout reminders
- User can access offline mode with cached data

### 2. Screen Archetypes

**Nutrition Search Screen**

- User can search for any food item
- User can view total calories for multiple items
- User can see detailed macro breakdown

**Recipe Discovery Screen**

- User can search recipes by name or ingredient
- User can view cooking instructions
- User can see serving sizes

**Exercise Library Screen**

- User can filter by muscle group
- User can filter by exercise type
- User can view exercise instructions

**Calories Calculator Screen**

- User can input activity type
- User can specify duration
- User can view calories burned per hour

**Cocktail Recipe Screen**

- User can search cocktails by name
- User can view ingredients list
- User can see mixing instructions

### 3. Navigation

**Tab Navigation (Tab to Screen)**

- Nutrition Tab → Nutrition Tracker Screen (Leaf icon)
- Recipes Tab → Recipe Discovery Screen (Book icon)
- Exercises Tab → Exercise Library Screen (Running figure icon)
- Calories Tab → Calories Calculator Screen (Flame icon)
- Cocktails Tab → Cocktail Recipes Screen (Wine glass icon)

**Flow Navigation (Screen to Screen)**

**Nutrition Tracker Screen**

- → Search Bar (Text input with search functionality)
- → Nutrition Results List (After search)
- → Expandable nutrition details (Tap on item)

**Recipe Discovery Screen**

- → Search Bar (Text input)
- → Recipe List (After search)
- → Expandable recipe details with instructions (Tap "Show More")

**Exercise Library Screen**

- → Muscle Group Picker (Dropdown selection)
- → Exercise Type Picker (Dropdown selection)
- → Exercise List (After search)
- → Expandable exercise instructions (Tap "Show Instructions")

**Calories Calculator Screen**

- → Activity Input Field
- → Duration Input Field
- → Calculate Button → Results List

**Cocktail Recipes Screen**

- → Search Bar
- → Cocktail List (After search)
- → Expandable recipe details (Tap "Show Recipe")

### Digital Wireframes & Mockups

**Main Tab Bar Layout**

```
┌─────────────────────────────┐
│      Navigation Title       │
│┌───────────────────────────┐│
││     Search Bar            ││
│└───────────────────────────┘│
│                             │
│  ┌─────────────────────┐    │
│  │   List Item 1       │    │
│  └─────────────────────┘    │
│  ┌─────────────────────┐    │
│  │   List Item 2       │    │
│  └─────────────────────┘    │
│                             │
│──────────────────────────── │
│   🍃   📚   🏃   🔥   🍷      │
└─────────────────────────────┘
```

### Interactive Prototype Features

- Swipe between tabs for quick navigation
- Pull-to-refresh gesture on all list views
- Tap to expand/collapse detailed information
- Keyboard dismissal on search execution
- Loading states during API calls
- Error state handling with user-friendly messages

## Schema

### Models

| Model          | Properties                                                                                                                                                                                | Description                                       |
| -------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------- |
| Nutrition      | id: UUID<br>name: String<br>calories: Double<br>serving_size_g: Double<br>fat_total_g: Double<br>protein_g: Double<br>carbohydrates_total_g: Double<br>fiber_g: Double<br>sugar_g: Double | Represents nutritional information for food items |
| Recipe         | id: UUID<br>title: String<br>ingredients: String<br>servings: String<br>instructions: String                                                                                              | Contains recipe details and cooking instructions  |
| Exercise       | id: UUID<br>name: String<br>type: String<br>muscle: String<br>equipment: String<br>difficulty: String<br>instructions: String                                                             | Exercise information with detailed instructions   |
| CaloriesBurned | id: UUID<br>name: String<br>calories_per_hour: Double<br>duration_minutes: Double<br>total_calories: Double                                                                               | Activity calorie burn calculations                |
| Cocktail       | id: UUID<br>name: String<br>ingredients: [String]<br>instructions: String                                                                                                                 | Cocktail recipes with ingredients list            |

### Networking

**API Endpoints (API Ninjas)**

- Base URL: https://api.api-ninjas.com/v1
- Authentication: All requests require X-Api-Key header

| Screen              | Endpoint        | HTTP Method | Parameters                            |
| ------------------- | --------------- | ----------- | ------------------------------------- |
| Nutrition Tracker   | /nutrition      | GET         | query: String (food text)             |
| Recipe Discovery    | /recipe         | GET         | query: String (recipe name)           |
| Exercise Library    | /exercises      | GET         | muscle: String?<br>type: String?      |
| Calories Calculator | /caloriesburned | GET         | activity: String<br>duration: Int?    |
| Cocktail Recipes    | /cocktail       | GET         | name: String?<br>ingredients: String? |

### Network Request Examples

**Nutrition Search:**

```swift
func fetchNutrition(query: String) async throws -> [Nutrition] {
    let url = "\(baseURL)/nutrition?query=\(query)"
    var request = URLRequest(url: URL(string: url)!)
    request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")

    let (data, _) = try await URLSession.shared.data(for: request)
    return try JSONDecoder().decode([Nutrition].self, from: data)
}
```

**Recipe Search:**

```swift
func fetchRecipe(query: String) async throws -> [Recipe] {
    let url = "\(baseURL)/recipe?query=\(query)"
    var request = URLRequest(url: URL(string: url)!)
    request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")

    let (data, _) = try await URLSession.shared.data(for: request)
    return try JSONDecoder().decode([Recipe].self, from: data)
}
```

### API Response Examples

**Nutrition Response:**

```json
[
  {
    "name": "brisket",
    "calories": 358.0,
    "serving_size_g": 100,
    "fat_total_g": 28.4,
    "protein_g": 25.2,
    "carbohydrates_total_g": 0
  }
]
```

**Exercise Response:**

```json
[
  {
    "name": "Push-ups",
    "type": "strength",
    "muscle": "chest",
    "equipment": "body_only",
    "difficulty": "beginner",
    "instructions": "Place hands shoulder-width apart..."
  }
]
```

## Technologies Used

- **Swift 5.9** - Primary programming language
- **SwiftUI** - UI framework for declarative interface design
- **Async/Await** - Modern concurrency for API calls
- **URLSession** - Native networking
- **Codable** - JSON parsing
- **@StateObject/@ObservableObject** - State management
- **MVVM Architecture** - Clean separation of concerns

## Installation

1. Clone the repository
2. Open HealthTracker.xcodeproj in Xcode
3. Get your free API key from API Ninjas
4. Replace YOUR_API_KEY_HERE in APIService.swift
5. Build and run on iOS 15.0+ device or simulator

## Future Enhancements

- Integration with HealthKit
- Barcode scanning for packaged foods
- Meal planning and scheduling
- Social features for sharing progress
- AI-powered nutrition recommendations
- Wearable device integration
- Offline mode with data caching
- Premium features with advanced analytics
