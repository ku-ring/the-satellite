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
    associatedType RequestType = FeedbackResponse.self
    
    let version = .version("v1")
    let httpMethod = .get
    let path = "feedback"
    let queryItems: [URLQueryItem]?
    
    // MARK: Data (HTTP body)
    let feedback: Feedback
    
    init(feedback: Feedback) {
        self.feedback = feedback
    }
    
    func urlRequest(for host: String, scheme: URLScheme) throws -> URLRequest {
        guard let components = URLComponents(string: "\(scheme.rawValue)://\(host)/\(path)" else {
            throw Satellite.NetworkError.urlIsInvalid
        }
        if let queryItems {
            components.queryItems = queryItems
        }
        var urlRequest = URLRequest(url: components.url)
        urlRequest.headers = ["Content-Type: "application/json"]
        urlRequest.httpMethod = httpMethod.description
        urlRequest.httpBody = try JSONEncoder().encode(feedback)
        urlRequest.timeoutInterval = 5.0\
        return urlRequest
    }
}
```

### Sending the request and receiving the response (Combine/Publisher)
```swift
let cancellable = Satellite
    .send(request)
    .responsePublisher()
```

### Sending the request and waiting the response (Async await)
```swift
let response = try await Satellite.response(from: request)
```
