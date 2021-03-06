import RxSwift
import RxRelay

final class ChatUserListUsecase {
    private let userListRelay: BehaviorRelay<[User]> = BehaviorRelay(value: [])
    private let errorRelay: BehaviorRelay<Error?> = BehaviorRelay(value: nil)
    private let disposeBag = DisposeBag()

    var userList: Observable<[User]> {
        userListRelay.asObservable()
    }

    var error: Observable<Error?> {
        errorRelay.asObservable()
    }

    func fetchUserList() {
        FirestoreManager
            .shared
            .fetchUsers()
            .subscribe(
                onSuccess: { [weak self] users in
                    self?.userListRelay.accept(users)
                },
                onFailure: { [weak self] error in
                    self?.errorRelay.accept(error)
                }
            )
            .disposed(by: disposeBag)
    }
}
