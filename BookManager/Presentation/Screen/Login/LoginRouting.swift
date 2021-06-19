import UIKit

final class LoginRouting: Routing {
    weak var viewController: UIViewController?
}

extension LoginRouting {

    func showSignupScreen() {
        let signupVC = SignupViewController.instantiateInitialViewController()
        signupVC.inject(routing: SignupRouting(), viewModel: SignupViewModel())

        if viewController?.presentingViewController is SignupViewController {
            viewController?.dismiss(animated: true)
        } else {
            viewController?.present(signupVC, animated: true)
        }
    }

    func showRootScreen() {
        let tabVC = RootTabBarController()
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        window?.rootViewController = tabVC
    }
}
