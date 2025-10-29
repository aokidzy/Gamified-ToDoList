import UIKit

class MainViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let hudView: StatisticView = {
        let view = StatisticView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let characterNameLabel: UILabel = {
        let label = UILabel()
        label.text = "To-Do List"
        label.textColor = .label
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addNoteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("+", for: .normal)
        button.backgroundColor = .systemOrange
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let notesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Note")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupButtonActions()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addNoteButton.layer.cornerRadius = addNoteButton.frame.height / 2
        addNoteButton.clipsToBounds = true
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        
        view.backgroundColor = .systemBackground
        view.addSubview(characterNameLabel)
        view.addSubview(hudView)
        view.addSubview(notesTableView)
        view.addSubview(addNoteButton)
        
        notesTableView.delegate = self
        notesTableView.dataSource = self
        
        NSLayoutConstraint.activate([
            characterNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            characterNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 75),
            
            hudView.topAnchor.constraint(equalTo: characterNameLabel.bottomAnchor, constant: 20),
            hudView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            hudView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            
            notesTableView.topAnchor.constraint(equalTo: hudView.bottomAnchor, constant: 20),
            notesTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            notesTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            notesTableView.bottomAnchor.constraint(equalTo: addNoteButton.topAnchor, constant: -20),
            
            addNoteButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            addNoteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addNoteButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15),
            addNoteButton.heightAnchor.constraint(equalTo: addNoteButton.widthAnchor)
        ])
    }
}

// MARK: - AddNoteButton Actions
private extension MainViewController {
    
    private func setupButtonActions() {
        addNoteButton.addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        addNoteButton.addTarget(self, action: #selector(buttonReleased), for: .touchUpInside)
    }
    
    @objc private func buttonPressed() {
        UIView.animate(withDuration: 0.1) {
            self.addNoteButton.alpha = 0.7
        }
    }
    
    @objc private func buttonReleased() {
        UIView.animate(withDuration: 0.1) {
            self.addNoteButton.alpha = 1
        }
        
        
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 5
        case 2:
            return 8
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
        cell.textLabel?.text = "section \(indexPath.section) cell =  \(indexPath.row)"
        
        cell.backgroundColor = .systemGray6
        cell.accessoryType = .checkmark
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}
