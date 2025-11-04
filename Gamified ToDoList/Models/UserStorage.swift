import Foundation

// MARK: - Models
struct Statistic: Codable {
    var level: Int
    var exp: Float
    var hp: Float
}

struct Note: Codable {
    var title: String
    var isDone: Bool
}

// MARK: - Storage Protocol
protocol UserStorageProtocol {
    func saveStatistic(_ statistic: Statistic)
    func getStatistic() -> Statistic?
    
    func saveNotes(_ notes: [Note])
    func getNotes() -> [Note]?
}

// MARK: - UserStorage Implementation
final class UserStorage: UserStorageProtocol {
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    // MARK: - Statistic
    func saveStatistic(_ statistic: Statistic) {
        if let encoded = try? JSONEncoder().encode(statistic) {
            userDefaults.set(encoded, forKey: "statistic1")
            userDefaults.synchronize()
        }
    }
    
    func getStatistic() -> Statistic? {
        guard let data = userDefaults.data(forKey: "statistic1") else { return nil }
        return try? JSONDecoder().decode(Statistic.self, from: data)
    }
    
    // MARK: - Notes
    func saveNotes(_ notes: [Note]) {
        if let encoded = try? JSONEncoder().encode(notes) {
            userDefaults.set(encoded, forKey: "notes1")
            userDefaults.synchronize()
        }
    }
    
    func getNotes() -> [Note]? {
        guard let data = userDefaults.data(forKey: "notes1") else { return nil }
        return try? JSONDecoder().decode([Note].self, from: data)
    }
}
