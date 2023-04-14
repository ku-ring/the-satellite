extension Satellite {
    public enum URLScheme: CustomStringConvertible {
        case http
        case https

        public var description: String {
            switch self {
            case .http: return "http://"
            case .https: return "https://"
            }
        }
    }
}
