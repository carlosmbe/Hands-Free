# Hands Free: Gesture-Based Instrument 

"Hands Free" offers a novel way to play music. Using Apple's Vision Hand Pose, the project captures hand gestures through the device's front camera to trigger MiDi chords, letting users 'strum' melodies with simple hand movements.

For simplicity sake, I made the project only react when your thumb and pinky are touching. You can configure this behaviour by changing the code in ProcessingHands.swift.

Earlier versions of that file have all fingers enabled if you'd like to see example implementations

#### Important: Before building in Xcode, update the app team information to your own.

## Prerequisites

- **iOS Device**: Ensure you have a physical iOS device with a camera. Simulators are not suitable since they lack access to camera hardware.
- **Swift Knowledge**: Familiarity with Swift and an understanding of Xcode's interface are beneficial.

## Setup & Installation

1. **Clone the Repository**
    ```bash
    git clone https://github.com/carlosmbe/Hands-Free.git
    ```

2. **Open the Project in Xcode**
    - Head over to the directory where you cloned the repository.
    - Double click on `Hands Free.xcodeproj` or `Hands Free.xcworkspace` (if you've integrated CocoaPods).

3. **Set Up Your iOS Device for Development**
    - Connect your iOS device using a USB cable.
    - In Xcode, select your device from the dropdown list located near the play button.
    - Navigate to Xcode > Preferences > Accounts. Here, ensure your Apple ID is added and that you have the correct provisioning profiles.

4. **Run the App**
    - Simply press the "Play" icon in Xcode's top-left corner. Xcode will compile the code and install the app on your device.

## Usage

1. **Launch**: Start the "Hands Free" app on your iOS device.
2. **Permissions**: When prompted, allow the app to access your camera.
3. **Get Started**: Place your hand in view of the device's front camera.
4. **Interact**: Play around with various hand gestures. The app will recognize specific hand poses and will play corresponding MiDi chords in response.
5. **Visual Feedback**: A visual overlay will highlight the detected hand posture on the screen, and the name of the played chord will appear in the center.

## Code Structure & Explanation

Following a recent refactor, the codebase is now more organized and comprehensible:

- **MiDi.swift**: Central to generating and enacting MiDi Chords.
- **ProcessingHands.swift**: Leverages Apple's Vision framework to discern hand positions. Depending on the recognized hand pose, it then determines which chord to play.
- **ContentView.swift**: This SwiftUI view manages the camera interface and renders on-screen overlays.
- **CameraViewController.swift**: A pivotal controller. It oversees the camera's feed, coordinates Vision's hand detection requests, and interprets the detected hand positions.

## Contributing & Development

Your input is valuable! Whether it's bug reports, feature requests, or code contributions, we're eager to hear from you. If you're contributing code, please ensure it's well-commented for clarity. For any enhancements or issues, please create a related issue or submit a pull request.
