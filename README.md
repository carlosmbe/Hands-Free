# Hands Free: Gesture-Based Music Control

Play MiDi Chords using Apple's Vision Hand Pose. A project that captures hand gestures via the device's front camera to trigger MiDi chords, enabling users to 'play' music with their hands.

## Prerequisites

- Physical iOS device with a camera (as simulators don't have access to camera hardware).
- Basic understanding of Swift and Xcode's interface.

## Setup & Installation

1. **Clone the Repository**
    ```bash
    git clone https://github.com/carlosmbe/Hands-Free.git
    ```

2. **Open the Project in Xcode**
    - Navigate to the cloned directory.
    - Open `Hands Free.xcodeproj` or `Hands Free.xcworkspace` (if using CocoaPods).

3. **Configure Your iOS Device for Development**
    - Connect your iOS device via USB.
    - Choose your device from the dropdown near the play button in Xcode.
    - Go to Xcode > Preferences > Accounts, ensure your Apple ID is added and valid provisioning profiles are available.

4. **Run the App**
    - Hit the "Play" button in the top left of Xcode. This action will compile and install the app on your device.

## Usage

1. Launch "Hands Free" from your iOS device.
2. Grant the app access to your camera when prompted.
3. Position your hand in front of the device's front camera.
4. Experiment with different hand gestures. Recognized hand poses will trigger corresponding MiDi chords.
5. An overlay on the screen offers visual feedback on the identified hand posture, and the chord name will be centrally displayed.

## Code Structure & Explanation

- **MiDi.swift**: Manages the logic for generating and playing MiDi Chords.
- **ProcessingHands.swift**: Uses the Vision framework to determine hand postures and decide which chord to initiate based on the detected pose.
- **ContentView.swift**: A SwiftUI view that administers the camera and displays overlays.
- **CameraViewController.swift**: The principal controller overseeing the camera feed, the Vision requests, and the interpretation of recognized points.

## Contributing & Development

Any and all contributions are welcome and appreciated! Should you have suggestions or features to include, kindly create an issue or submit a pull request. Remember to comment your code for clarity.
