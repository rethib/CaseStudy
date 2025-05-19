# MovieList

A SwiftUI-based iOS application that allows users to search for movies using the OMDB API and manage their favorite movies.

## Features

- Search movies using OMDB API
- Display movies in a beautiful 2-column grid layout
- Add/remove movies to/from favorites
- Responsive UI with loading and empty states
- Modern SwiftUI implementation

## Requirements

- iOS 16.0+
- Xcode 14.0+
- Swift 5.9+

## Architecture

- MVVM + Coordinator pattern
- SwiftUI for UI
- URLSession + Codable for networking
- Swift Package Manager for dependency management
- XcodeGen for project generation

## Setup

1. **Clone the repository**
2. **Install XcodeGen** (if not already installed):
   ```sh
   brew install xcodegen
   ```
3. **Generate the Xcode project:**
   ```sh
   xcodegen
   ```
4. **Open `MovieList.xcodeproj` in Xcode**
5. **Build and run the project**

## API Key

The app uses the OMDB API. You will need to provide your own OMDB API key. Please refer to the OMDB API documentation for instructions on obtaining an API key.

## License

This project is available under the MIT license. See the LICENSE file for more info. 