import UIKit

class AddNoteView: UIViewController {
    
    // MARK: - Properties
    var onSave: ((String) -> Void)?
    private let maxCharacterCount = 500
    
    // MARK: - UI Elements
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.backgroundColor = .systemGray6
        textView.isScrollEnabled = true
        textView.alwaysBounceVertical = true
        textView.keyboardDismissMode = .interactive
        
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.textContainer.maximumNumberOfLines = 0
        textView.textContainer.lineFragmentPadding = 0
        textView.layer.cornerRadius = 8
        textView.clipsToBounds = true
        
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your note here..."
        label.textColor = .placeholderText
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    private let characterCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/500"
        label.textColor = .secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSheetPresentation()
        setupTextView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(textView)
        view.addSubview(saveButton)
        view.addSubview(placeholderLabel)
        view.addSubview(characterCountLabel)
        
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textView.heightAnchor.constraint(equalToConstant: 200),
            
            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: 12),
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 12),
            placeholderLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -12),
            
            characterCountLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 8),
            characterCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            saveButton.topAnchor.constraint(equalTo: characterCountLabel.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - SheetPresentation Setup
    private func setupSheetPresentation() {
        if let sheet = sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
            sheet.selectedDetentIdentifier = .medium
        }
    }
    
    // MARK: - TextView Setup
    private func setupTextView() {
        textView.delegate = self
        
        DispatchQueue.main.async {
            if self.textView.text.isEmpty {
                self.textView.scrollRangeToVisible(NSRange(location: 0, length: 0))
            }
        }
    }
    
    // MARK: - Hide Keyboard by touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.3) {
            self.textView.resignFirstResponder()
        }
    }
}

// MARK: - Actions
private extension AddNoteView {
    
    // MARK: - SaveButton
    @objc func saveButtonTapped() {
        guard let text = textView.text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showAlert("Enter a note first")
            return
        }
        
        onSave?(text)
        dismiss(animated: true)
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextViewDelegate
extension AddNoteView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        let count = textView.text.count
        characterCountLabel.text = "\(count)/\(maxCharacterCount)"
        
        updateCharacterCountColor(for: count)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        
        if text == "\n" {
            let newLength = currentText.count + text.count - range.length
            return newLength <= maxCharacterCount
        }
        
        let newLength = currentText.count + text.count - range.length
        
        if newLength > maxCharacterCount {
            UIView.animate(withDuration: 0.1) {
                self.characterCountLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            } completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    self.characterCountLabel.transform = .identity
                }
            }
            return false
        }
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.selectedRange = NSRange(location: 0, length: 0)
        }
    }
    
    private func updateCharacterCountColor(for count: Int) {
        switch count {
        case maxCharacterCount...:
            characterCountLabel.textColor = .systemRed
        case Int(Double(maxCharacterCount) * 0.9)...:
            characterCountLabel.textColor = .systemOrange
        case Int(Double(maxCharacterCount) * 0.8)...:
            characterCountLabel.textColor = .systemYellow
        default:
            characterCountLabel.textColor = .secondaryLabel
        }
    }
}
