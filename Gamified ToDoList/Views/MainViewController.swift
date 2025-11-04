import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    var presenter: MainPresenterProtocol!
    
    // MARK: - UI Elements
    
    private let statisticView: StatisticView = {
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
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
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
    
    // MARK: - UI Setup
    private func setupUI() {
        
        view.backgroundColor = .systemBackground
        view.addSubview(characterNameLabel)
        view.addSubview(statisticView)
        view.addSubview(notesTableView)
        view.addSubview(addNoteButton)
        
        notesTableView.delegate = self
        notesTableView.dataSource = self
        notesTableView.separatorStyle = .none
        
        NSLayoutConstraint.activate([
            characterNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            characterNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 75),
            
            statisticView.topAnchor.constraint(equalTo: characterNameLabel.bottomAnchor, constant: 20),
            statisticView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            statisticView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            
            notesTableView.topAnchor.constraint(equalTo: statisticView.bottomAnchor, constant: 20),
            notesTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            notesTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            notesTableView.bottomAnchor.constraint(equalTo: addNoteButton.topAnchor, constant: -20),
            
            addNoteButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            addNoteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addNoteButton.widthAnchor.constraint(equalToConstant: 60),
            addNoteButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}

// MARK: - Actions
private extension MainViewController {
    
    // MARK: - AddNoteButton
    func setupButtonActions() {
        addNoteButton.addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        addNoteButton.addTarget(self, action: #selector(buttonReleased), for: .touchUpInside)
    }
    
    @objc func buttonPressed() {
        UIView.animate(withDuration: 0.1) {
            self.addNoteButton.alpha = 0.7
        }
    }
    
    @objc func buttonReleased() {
        UIView.animate(withDuration: 0.1) {
            self.addNoteButton.alpha = 1
        }
        showAddNoteSheet()
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.notesCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
        let note = presenter.note(at: indexPath.section)
        
        cell.textLabel?.numberOfLines = 0
        cell.backgroundColor = .systemGray6
        cell.layer.cornerRadius = 16
        cell.clipsToBounds = true
        cell.accessoryType = note.isDone ? .checkmark : .none
        
        if note.isDone {
            let attributedString = NSMutableAttributedString(string: note.title)
            attributedString.addAttribute(
                .strikethroughStyle,
                value: NSUnderlineStyle.single.rawValue,
                range: NSRange(location: 0, length: note.title.count)
            )
            attributedString.addAttribute(
                .strikethroughColor,
                value: UIColor.systemGray,
                range: NSRange(location: 0, length: note.title.count)
            )
            attributedString.addAttribute(
                .foregroundColor,
                value: UIColor.systemGray,
                range: NSRange(location: 0, length: note.title.count)
            )
            cell.textLabel?.attributedText = attributedString
        } else {
            cell.textLabel?.attributedText = nil
            cell.textLabel?.text = note.title
            cell.textLabel?.textColor = .label
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = presenter.note(at: indexPath.section)
        
        presenter.toggleNote(at: indexPath.section)
        
        if note.isDone {
            presenter.decreaseExp()
        } else {
            presenter.increaseExp()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completion) in
            self?.showDeleteConfirmation(for: indexPath.section, completion: completion)
        }
        
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash")

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        
        return configuration
    }
}

// MARK: - MainViewProtocol
extension MainViewController: MainViewProtocol {
    func updateStatistic(with statistic: Statistic) {
        statisticView.update(with: statistic)
    }
    
    func reloadNotes() {
        notesTableView.reloadData()
    }
}

// MARK: - Add Note Sheet
private extension MainViewController {
    func showAddNoteSheet() {
        let addNoteVC = AddNoteView()
        
        addNoteVC.onSave = { [weak self] noteText in
            let newNote = Note(title: noteText, isDone: false)
            self?.presenter.addNote(note: newNote)
        }
        
        present(addNoteVC, animated: true)
    }
}

// MARK: - Delete Confirmation
private extension MainViewController {
    
    func showDeleteConfirmation(for index: Int, completion: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(
            title: "Delete note?",
            message: "This action cannot be undone",
            preferredStyle: .actionSheet
        )
    
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.presenter.deleteNote(at: index)
            completion(true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(false)
        }
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}
