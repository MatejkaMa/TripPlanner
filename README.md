# Trip planner

- The-project-challange

## Platforms

- iOS >= 15.0
- Used Xcode Version 13.4.1 (13F100)

## Technologies stack

- Swift
- SwiftUI (iOS 15)
- Combine

## Used architectures (Patterns)

- MVVM
- Flow coordinators
- Modular architecture
- Atomic design (https://atomicdesign.bradfrost.com)

## Modules

### TUIKit (Package)
-  Targets: 
    - APIKit
        - Protocoled a basic REST API implementation
        - Implemented a basic APIService 
        - Implemented a basic MockAPIService (returns sample data)
    - TUIAPIKit
        - It contains the implementation of the service to communicate with the TUI Hub (TUIMobilityHubService) and the mocked variant (MockTUIMobilityHubService) 
    - TUIAlgorithmKit
        - It contains the algorithm to find the shortest path  

### TripPlanner
- /Shared
    - shared sources/resources between eventual multiple deployment targets
- /Targets/TripPlanner-iOS
    - sources/resources for the iOS target



