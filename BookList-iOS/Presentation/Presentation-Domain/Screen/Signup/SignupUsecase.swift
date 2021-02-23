import RxSwift
import RxRelay

final class SignupUsecase {
    private let loadingRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private let resultRelay: BehaviorRelay<Result<SignupResponse, Error>?> = BehaviorRelay(value: nil)
    private let disposeBag: DisposeBag = DisposeBag()

    var loading: Observable<Bool> {
        loadingRelay.asObservable()
    }

    var result: Observable<Result<SignupResponse, Error>?> {
        resultRelay.asObservable()
    }

    func signup(
        email: String,
        password: String
    ) {
        loadingRelay.accept(true)

        SignupRequest()
            .request(.init(
                        email: email,
                        password: password))
            .subscribe(
                onSuccess: { [weak self] response in
                    self?.loadingRelay.accept(false)
                    self?.resultRelay.accept(.success(response))
                    KeychainManager.shared.setToken(response.result.token)
                },
                onFailure: { [weak self] error in
                    self?.loadingRelay.accept(false)
                    self?.resultRelay.accept(.failure(error))
                })
            .disposed(by: disposeBag)
    }
}