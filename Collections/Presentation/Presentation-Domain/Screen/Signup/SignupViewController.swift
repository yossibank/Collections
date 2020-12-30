import UIKit

final class SignupViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var secureTextChangeButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!

    var keyboardNotifier: KeyboardNotifier = KeyboardNotifier()

    private var isSecureCheck: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        setupButton()
        listenerKeyboard(keyboardNotifier: keyboardNotifier)
    }
}

extension SignupViewController {

    private func setupTextField() {
        [emailTextField, passwordTextField, passwordConfirmationTextField]
            .forEach { $0?.delegate = self }
    }

    private func setupButton() {
        secureTextChangeButton.addTarget(
            self,
            action: #selector(secureTextChange),
            for: .touchUpInside
        )

        signupButton.addTarget(
            self,
            action: #selector(showHomeScreen),
            for: .touchUpInside
        )
    }

    @objc private func secureTextChange(_ sender: UIButton) {
        let secureImage = isSecureCheck
            ? Resources.Images.Account.checkInBox
            : Resources.Images.Account.checkOffBox
        sender.setImage(secureImage, for: .normal)

        [passwordTextField, passwordConfirmationTextField].forEach {
            $0?.isSecureTextEntry = isSecureCheck ? false : true
        }
        isSecureCheck = !isSecureCheck
    }

    @objc private func showHomeScreen(_ sender: UIButton) {

    }
}

extension SignupViewController: UITextFieldDelegate {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if emailTextField == textField {
            passwordTextField.becomeFirstResponder()
        } else if passwordTextField == textField {
            passwordConfirmationTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension SignupViewController: KeyboardDelegate {

    func keyboardPresent(_ height: CGFloat) {
        let displayHeight = self.view.frame.height - height
        let signupButtonOffsetY = signupButton.convert(signupButton.frame, to: stackView).minY
        let bottomOffsetY = signupButtonOffsetY - displayHeight
        view.frame.origin.y == 0 ? (view.frame.origin.y -= bottomOffsetY) : ()
    }

    func keyboardDismiss(_ height: CGFloat) {
        view.frame.origin.y != 0 ? (view.frame.origin.y = 0) : ()
    }
}