import UIKit

final class SignupRouting: Routing {
    weak var viewController: UIViewController?
}

extension SignupRouting {

    func showLoginScreen() {
        let loginVC = LoginViewController.instantiateInitialViewController()
        loginVC.inject(routing: LoginRouting(), viewModel: LoginViewModel())

        if viewController?.presentingViewController is LoginViewController {
            viewController?.dismiss(animated: true)
        } else {
            viewController?.present(loginVC, animated: true)
        }
    }

    func showHomeScreen() {
        let bookListVC = BookListViewController.instantiateInitialViewController()
        bookListVC.inject(routing: BookListRouting(), viewModel: BookListViewModel())

        let nc = MainNavigationController(rootViewController: bookListVC)
        nc.setupNavigationBar(
            forVC: bookListVC,
            config: bookListVC as NavigationBarConfiguration
        )
        
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        window?.rootViewController = nc
    }

    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}