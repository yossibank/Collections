import RxSwift
import RxRelay

final class ChatSelectViewModel {
    private let usecase: ChatSelectUsecase
    private let roomListRelay: BehaviorRelay<[Room]> = BehaviorRelay(value: [])
    private let errorRelay: BehaviorRelay<Error?> = BehaviorRelay(value: nil)
    private let disposeBag: DisposeBag = DisposeBag()

    var roomList: Observable<[Room]> {
        roomListRelay.asObservable()
    }

    var error: Observable<Error?> {
        errorRelay.asObservable()
    }

    init(usecase: ChatSelectUsecase) {
        self.usecase = usecase
        bindUsecase()
    }

    private func bindUsecase() {
        usecase.roomList
            .bind(to: roomListRelay)
            .disposed(by: disposeBag)

        usecase.error
            .bind(to: errorRelay)
            .disposed(by: disposeBag)
    }

    func fetchRooms() {
        FirestoreManager
            .shared
            .fetchRooms()
            .subscribe(
                onSuccess: { [weak self] rooms in
                    self?.roomListRelay.accept(rooms)
                },
                onFailure: { [weak self] error in
                    self?.errorRelay.accept(error)
                })
                .disposed(by: disposeBag)
    }
}
