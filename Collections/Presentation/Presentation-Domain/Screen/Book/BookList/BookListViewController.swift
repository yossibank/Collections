import UIKit
import RxSwift
import RxCocoa

final class BookListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    private let router: RouterProtocol = Router()
    private let disposeBag: DisposeBag = DisposeBag()

    private var viewModel: BookListViewModel!
    private var dataSource: BookListDataSource!

    static func createInstance(viewModel: BookListViewModel) -> BookListViewController {
        let instance = BookListViewController.instantiateInitialViewController()
        instance.viewModel = viewModel
        return instance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
    }
}

extension BookListViewController {

    private func setupTableView() {
        dataSource = BookListDataSource(viewModel: viewModel)

        tableView.register(BookListTableViewCell.xib(), forCellReuseIdentifier: BookListTableViewCell.resourceName)
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.rowHeight = 100
    }
}

extension BookListViewController {

    private func bindViewModel() {
        viewModel.fetchBookList(isInitial: true)

        viewModel.result
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] result in
                guard let self = self,
                      let result = result else { return }

                switch result {

                case .success(let response):
                    dump(response)
                    self.tableView.reloadData()

                case .failure(let error):
                    dump(error)
                }
            })
            .disposed(by: disposeBag)

        viewModel.loading
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] loading in
                guard let self = self else { return }

                loading ? self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)
    }
}

extension BookListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let bookId = viewModel.getBookId(index: indexPath.row) else { return }
        let book = viewModel.books[indexPath.row]
        let bookData = EditBookViewData(
            id: bookId,
            name: book.name,
            image: book.image,
            price: book.price,
            purchaseDate: book.purchaseDate
        )
        router.push(.editBook(bookId: bookId, bookData: bookData), from: self)
    }
}
