# Health Tracker App

A comprehensive health tracking application built with SwiftUI that provides nutrition information, recipes, exercises, cocktail recipes, and calorie burn calculations.

## Features

- 🥗 **Nutrition Tracker**: Search for food items and view detailed nutritional information
- 🍳 **Recipe Finder**: Discover recipes with ingredients and cooking instructions
- 💪 **Exercise Database**: Find exercises by muscle group and type with detailed instructions
- 🍹 **Cocktail Recipes**: Search for cocktail recipes with ingredients and instructions
- 🔥 **Calorie Calculator**: Calculate calories burned for various activities

## Setup

### API Configuration

This app uses the API Ninjas service for data. To set up your API key:

1. **Get an API Key**:

   - Sign up at [API Ninjas](https://api.api-ninjas.com/)
   - Get your free API key from the dashboard

2. **Configure the API Key**:

   - Copy `Config.plist.template` to `Config.plist`
   - Replace `YOUR_API_NINJAS_KEY_HERE` with your actual API key

   ```bash
   cp heathtracker/Config.plist.template heathtracker/Config.plist
   ```

   Then edit `Config.plist` and add your API key.

3. **Add Config.plist to Xcode Project**:

   - Open your Xcode project
   - Right-click on the `heathtracker` folder in the project navigator
   - Select "Add Files to 'heathtracker'"
   - Navigate to and select the `Config.plist` file
   - Make sure "Add to target" is checked for your main app target
   - Click "Add"

4. **Alternative - Environment Variable**:
   You can also set the API key as an environment variable:
   ```bash
   export API_NINJAS_KEY="your_api_key_here"
   ```

### Troubleshooting

If you see "No nutrition data found" or network errors:

1. **Check API Key**: Make sure your API key is correctly set in `Config.plist`
2. **Verify Bundle**: Ensure `Config.plist` is added to your Xcode project target
3. **Free Tier Limitations**: Some endpoints (like nutrition) may be temporarily unavailable for free users
4. **Test Other Features**: Try recipes, exercises, cocktails, or calorie calculator which should work with free tier
5. **Test API**: Verify your API key works by testing it directly on [API Ninjas](https://api.api-ninjas.com/)

### Known Limitations

- **Nutrition Endpoint**: Currently down for free tier users. Consider upgrading to premium or try other features
- **Rate Limits**: Free tier has request limits. Wait between searches if you hit limits

### Running the App

1. Open `heathtracker.xcodeproj` in Xcode
2. Make sure you've configured your API key (see above)
3. Build and run the project

## Security

- The `Config.plist` file containing your actual API key is excluded from version control
- Never commit your actual API key to the repository
- Use the template file for sharing the project structure

## API Endpoints Used

- **Nutrition**: `/v1/nutrition`
- **Recipes**: `/v1/recipe`
- **Exercises**: `/v1/exercises`
- **Cocktails**: `/v1/cocktail`
- **Calories Burned**: `/v1/caloriesburned`

## Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+
