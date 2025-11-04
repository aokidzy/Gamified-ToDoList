import Foundation

protocol MainViewProtocol: AnyObject {
    func updateStatistic(with statistic: Statistic)
    func reloadNotes()
}

protocol MainPresenterProtocol: AnyObject {
    init(view: MainViewProtocol, userStorage: UserStorageProtocol)
    var notesCount: Int { get }
    func note(at index: Int) -> Note
    func toggleNote(at index: Int)
    func addNote(note: Note)
    func deleteNote(at index: Int)
    func increaseExp()
    func decreaseExp()
    func decreaseHp()

}

final class MainPresenter: MainPresenterProtocol {
    
    // MARK: - Properties
    private weak var view: MainViewProtocol?
    private let userStorage: UserStorageProtocol
    
    private var notes: [Note] = []
    private var statistic: Statistic
    
    // MARK: - Initialization
    init(view: MainViewProtocol, userStorage: UserStorageProtocol) {
        self.notes = userStorage.getNotes() ?? []
        self.statistic = userStorage.getStatistic() ?? Statistic(level: 1, exp: 0.0, hp: 1.0)
        
        self.view = view
        self.userStorage = userStorage
        
        view.updateStatistic(with: statistic)
        view.reloadNotes()
    }
    
    // MARK: - Notes
    var notesCount: Int {
        return notes.count
    }
    
    func note(at index: Int) -> Note {
        guard notes.indices.contains(index) else {
            return Note(title: "", isDone: false)
        }
        return notes[index]
    }
    
    func toggleNote(at index: Int) {
        guard notes.indices.contains(index) else { return }
        notes[index] = Note(title: notes[index].title, isDone: !notes[index].isDone)
        userStorage.saveNotes(notes)
        view?.reloadNotes()
    }
    
    func addNote(note: Note) {
        notes.append(note)
        userStorage.saveNotes(notes)
        view?.reloadNotes()
    }
    
    func deleteNote(at index: Int) {
        guard notes.indices.contains(index) else { return }
        notes.remove(at: index)
        userStorage.saveNotes(notes)
        view?.reloadNotes()
    }
    
    // MARK: - Statistic
    func increaseExp() {
        statistic.exp += 0.1
        if statistic.exp >= 1.0 {
            statistic.exp = 0.0
            statistic.level += 1
        }
        userStorage.saveStatistic(statistic)
        view?.updateStatistic(with: statistic)
    }
    
    func decreaseExp() {
        if statistic.exp <= 0.0 {
            return
        }
        statistic.exp -= 0.1
        userStorage.saveStatistic(statistic)
        view?.updateStatistic(with: statistic)
    }
    
    func decreaseHp() {
        if statistic.hp <= 0.0 {
            statistic.exp = 0.0
            statistic.level = 1
            statistic.hp = 1.0
        } else {
            statistic.hp -= 0.1
        }
        userStorage.saveStatistic(statistic)
        view?.updateStatistic(with: statistic)
    }
}
