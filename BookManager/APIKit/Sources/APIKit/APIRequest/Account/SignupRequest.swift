import Foundation

public struct SignupRequest: Request {
    public typealias Response = SignupResponse
    public typealias PathComponent = EmptyPathComponent

    public struct Parameters: Codable {
        let email: String
        let password: String

        public init(
            email: String,
            password: String
        ) {
            self.email = email
            self.password = password
        }
    }

    public var parameters: Parameters
    public var method: HTTPMethod { .post }
    public var path: String { "/sign_up" }
    public var body: Data?
    public var testDataPath: URL? { nil }

    public init(
        parameters: Parameters,
        pathComponent: EmptyPathComponent = .init()
    ) {
        self.parameters = parameters
    }
}
