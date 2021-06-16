import APIKit
import Foundation

public struct UserMapper {
    func convert(response: UserResponse) -> UserEntity {
        UserEntity(
            id: response.result.id,
            email: response.result.email,
            token: response.result.token
        )
    }
}
