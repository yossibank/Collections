import Combine
import DomainKit
import Utility

final class LoginViewModel: ViewModel {
    typealias State = LoadingState<UserEntity, APPError>

    @Published var email = String.blank
    @Published var password = String.blank
    @Published private(set) var state: State = .standby

    var emailValidationText: String? {
        EmailValidator.validate(email).errorDescription
    }

    var passwordValidationText: String? {
        PasswordValidator.validate(password).errorDescription
    }

    private let usecase: LoginUsecase

    private var cancellables: Set<AnyCancellable> = []

    init(usecase: LoginUsecase = Domain.Usecase.Account.Login()) {
        self.usecase = usecase
    }
}

// MARK: - internal methods

extension LoginViewModel {

    func login() {
        state = .loading

        usecase
            .login(email: email, password: password)
            .sink { [weak self] completion in
                guard let self = self else { return }

                switch completion {
                    case let .failure(error):
                        Logger.debug(message: error.localizedDescription)
                        self.state = .failed(.init(error: error))

                    case .finished:
                        Logger.debug(message: "finished")
                        FirebaseAuthManager.shared.signIn(
                            email: self.email,
                            password: self.password
                        )
                }
            } receiveValue: { [weak self] state in
                self?.state = .done(state)
            }
            .store(in: &cancellables)
    }
}
