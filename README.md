![Frame 7@3x](https://user-images.githubusercontent.com/53814741/231978905-e0540fc8-1ea9-4beb-b088-357778092e66.png)

The Satellite is an API communication module only for iOS written in Swift.

# Contribution

I welcome and appreciate contributions from the community. If you find a bug, have a feature request, or want to contribute code, please submit an issue or a pull request on our GitHub repository freely.
Please see [💪 How to Contribute in Discussion](https://github.com/ku-ring/the-satellite/discussions/2) tab.

> **Important**
>
> When you contribute code via pull request, please add the unit tests for your new functions.

# License
**The Satellite** is released under the MIT license. See [LICENSE](https://github.com/ku-ring/the-satellite/blob/main/LICENSE) for details.

# Installation

## Installation guide for your Swift Package
1. In your `Package.swift` Swift Package Manager manifest, add the following dependency to your dependencies argument:
    ```swift
    .package(url: "https://github.com/ku-ring/the-satellite.git, .branch("main")),
    ```
2. Add the dependency to any targets you've declared in your manifest:
    ```swift
    .target(name: "MyTarget", dependencies: ["Satellite"]),
    ```

## Installation guide for your Xcode project
To use the Satellite in your project, follow these steps:

1. In Xcode, select **File** > **Swift Packages** > **Add Package Dependency**.
2. In the search bar, paste the the Satellite URL: https://github.com/ku-ring/the-satellite
3. Select the branch as **main** to install.
4. Click **Next**, and then click **Finish**.

# Usage

To use the Satellite in your project, add the following import statement at the top of your file:

```swift
import Satellite
```

## v1: Sputnik

"Version **Sputnik**" is the very first version of **the Satellite**, providing very basic public interfaces for API communication in Swift. It offers two main interfaces, one for *Swift concurrency* and another for *Combine*. Let's see how to use them.

> **See Also**
>
> Here is the [class diagram for the Satellte: Sputnik](https://user-images.githubusercontent.com/53814741/232882550-3c0a5efd-0742-4f3b-bbeb-0598012d07d8.png)

### 1. Creating the new Satellite instance with your host domain
```swift
let satellite = Satellite(
    host: "{BASE.URL}",
    scheme: .http // default: `.https`
)
```

### 2. Declare Request and Response
```swift
// Expected response object
struct CatFact: Codable {
    let text: String
}
```

### 3-a. Sending the request and receiving the response (Combine/Publisher)
```swift
let satellite = Satellite(host: "cat-fact.herokuapp.com")
cancellable  = statellite
    .responsePublisher<ResponseType: [CatFact]>(
        for: "facts/random",
        httpMethod: .get,
        queryItems: [
            URLQueryItem(name: "animal_type", value: "cat"),
            URLQueryItem(name: "amount", value: "2")
        ]
    )
    .sink(
        receiveCompletion: { print ("Received completion: \($0).") },
        receiveValue: { catFacts in print("Cat Facts: \(catFacts).")}
    )
```

> **INFORMATION** 
>
> For the more information on URLSession data task publisher, please see this [link](https://developer.apple.com/documentation/foundation/urlsession/processing_url_session_data_task_results_with_combine)

### 3-b. Sending the request and waiting the response (Async await)
```swift
let satellite = Satellite(host: "cat-fact.herokuapp.com")
let catFacts: [CatFact] = try await satellite.response(
    for: "facts/random",
    httpMethod: .get,
    queryItems: [
        URLQueryItem(name: "animal_type", value: "cat"),
        URLQueryItem(name: "amount", value: "2")
    ]
)
self.text = catFacts
    .compactMap { $0.text }
    .joined(separator: ", ")
```

> **INFORMATION** 
> 
> For the more information on using async/await style, please see this [link](https://developer.apple.com/documentation/swift/updating_an_app_to_use_swift_concurrency)
