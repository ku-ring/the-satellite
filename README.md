![Frame 7@3x](https://user-images.githubusercontent.com/53814741/231978905-e0540fc8-1ea9-4beb-b088-357778092e66.png)

The Satellite is an API communication module written in Swift.

## v1: Sputnik

### Setting up with API key and your domain
```swift
Satellite.setup(key: "{API.KEY}", domain: "{BASE.URL}")
```

### Sending the request and receiving the response (Combine/Publisher)
```swift
Satellite
    .send(request)
    .receive(on: responsePublisher)
    .resume()
```

### Sending the request and waiting the response (Async await)
```swift
let response = try await Satellite.response(from: request)
```
