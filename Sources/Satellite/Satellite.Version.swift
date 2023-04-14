extension Satellite {
    public enum Version: CustomStringConvertible {
        case none
        case version(_ string: String)

        public var description: String {
            switch self {
            case .none: return ""
            case .version(let string): return string
            }
        }
    }
}
