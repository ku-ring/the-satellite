![Frame 7@3x](https://user-images.githubusercontent.com/53814741/231978905-e0540fc8-1ea9-4beb-b088-357778092e66.png)

The Satellite is an API communication module written in Swift.

## v1: Sputnik

### Setting up with API key and your domain
```swift
Satellite.setup(
    host: "{BASE.URL}",
    scheme: .https, // default: .https 
    key: "{API.KEY}" // default: nil
)
```

### Declare Request and Response
```swift
struct Feedback: Codable {
    let id: String
    let content: String
}

struct FeedbackRequest: Request {
    var version: Satellite.Version = .version("v1")
    var httpMethod: Satellite.Method = .post
    let path = "feedback"
    let queryItems: [URLQueryItem]? = nil

    // MARK: Data (HTTP Body)
    let feedback: Feedback

    init(feedback: Feedback) {
        self.feedback = feedback
    }
    
    func urlRequest(for host: String, scheme: Satellite.URLScheme, apiKey: String) throws -> URLRequest {
        var urlRequest = try defaultURLRequest(host: host, scheme: scheme, apiKey: apiKey)
        urlRequest.httpBody = try JSONEncoder().encode(feedback)
        return urlRequest
    }
}
```

### Sending the request and receiving the response (Combine/Publisher)
```swift
Satellite
    .send(request, willReceiveOn: myAppResponse)
```

### Sending the request and waiting the response (Async await)
```swift
let response = try await Satellite.response(from: request)
```
