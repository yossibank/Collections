import Foundation

public struct LogoutRequest: Request {
    public typealias Parameters = EmptyParameters
    public typealias Response = EmptyResponse
    public typealias PathComponent = EmptyPathComponent

    public var parameters: Parameters
    public var queryItems: [URLQueryItem]?
    public var method: HTTPMethod { .delete }
    public var path: String { "/logout" }
    public var body: Data?

    public var successHandler: (EmptyResponse) -> Void {
        { _ in
            SecretDataHolder.accessToken = nil
        }
    }

    public var testDataPath: URL? {
        Bundle.module.url(forResource: "DeleteLogout", withExtension: "json")
    }

    public init(
        parameters: Parameters,
        pathComponent _: EmptyPathComponent = .init()
    ) {
        self.parameters = parameters
    }
}
