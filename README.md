![Frame 7@3x](https://user-images.githubusercontent.com/53814741/231978905-e0540fc8-1ea9-4beb-b088-357778092e66.png)

The Satellite is an API communication module written in Swift.

## v1: Sputnik

"Version **Sputnik**" is the very first version of **The Satellite**, providing very basic public interfaces for API communication in Swift. It offers two main interfaces, one for *Swift concurrency* and another for *Combine*. Let's see how to use them.

### Setting up with API key and your domain
```swift
let satellite = Satellite(
    host: "{BASE.URL}",
    scheme: .http // default: `.https`
)
```

### Declare Request and Response
```swift
// Expected response object
struct CatFact: Codable {
    let text: String
}
```

### Sending the request and receiving the response (Combine/Publisher)
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

> **INFORMATION** For the more information on URLSession data task publisher, please see this [link](https://developer.apple.com/documentation/foundation/urlsession/processing_url_session_data_task_results_with_combine)

### Sending the request and waiting the response (Async await)
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

> **INFORMATION** For the more information on using async/await style, please see this [link](https://developer.apple.com/documentation/swift/updating_an_app_to_use_swift_concurrency)