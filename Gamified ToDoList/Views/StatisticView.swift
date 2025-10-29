import UIKit

class StatisticView: UIView {
    
    // MARK: - UI Elements
    private let levelLabel: UILabel = {
        let label = UILabel()
        label.text = "Lvl: 1"
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let expLabel: UILabel = {
        let label = UILabel()
        label.text = "EXP"
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let expProgressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.progress = 0.6
        progressView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        progressView.progressTintColor = .systemYellow
        progressView.trackTintColor = .systemGray5
        progressView.layer.cornerRadius = 5
        progressView.clipsToBounds = true
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    private let hpLabel: UILabel = {
        let label = UILabel()
        label.text = "HP"
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let hpProgressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.progress = 0.6
        progressView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        progressView.progressTintColor = .systemRed
        progressView.trackTintColor = .systemGray5
        progressView.layer.cornerRadius = 5
        progressView.clipsToBounds = true
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    private lazy var expStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [expLabel, expProgressView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var hpStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [hpLabel, hpProgressView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [levelLabel,expStackView, hpStackView])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 16
        stackView.distribution = .fill
        return stackView
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        expProgressView.transform = CGAffineTransform(scaleX: 1, y: 3)
        hpProgressView.transform = CGAffineTransform(scaleX: 1, y: 3)
        
        addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            mainStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            expLabel.widthAnchor.constraint(equalTo: hpLabel.widthAnchor),
        ])
    }
}
