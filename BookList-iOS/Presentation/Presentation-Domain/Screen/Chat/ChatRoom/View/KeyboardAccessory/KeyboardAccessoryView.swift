import UIKit

protocol KeyboardAccessoryViewDelegate: class {
    func didTappedSendButton(text: String)
}

final class KeyboardAccessoryView: UIView {

    @IBOutlet weak var sendTextView: UITextView! {
        didSet {
            sendTextView.text = .blank
            sendTextView.textContainerInset = .init(top: 8, left: 8, bottom: 4, right: 4)
            sendTextView.sizeToFit()
            sendTextView.delegate = self
        }
    }

    @IBOutlet weak var sendButton: UIButton! {
        didSet {
            sendButton.isEnabled = false
            sendButton.imageView?.contentMode = .scaleAspectFill
            sendButton.contentVerticalAlignment = .fill
            sendButton.contentHorizontalAlignment = .fill
            sendButton.onTap { [weak self] in
                guard
                    let self = self,
                    let text = self.sendTextView.text
                else {
                    return
                }

                self.delegate?.didTappedSendButton(text: text)
            }
        }
    }

    weak var delegate: KeyboardAccessoryViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeLayout()
    }

    override var intrinsicContentSize: CGSize {
        .zero
    }

    private func initializeLayout() {
        guard
            let view = KeyboardAccessoryView.initialize(ownerOrNil: self)
        else {
            return
        }

        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)

        autoresizingMask = .flexibleHeight
    }
}

extension KeyboardAccessoryView: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        sendButton.isEnabled = !textView.text.isEmpty
    }
}