import UIKit

protocol Builder {
    static func createMainModule() -> UIViewController
}

final class ModuleBuilder: Builder {
    static func createMainModule() -> UIViewController {
        let view = MainViewController()
        let userStorage = UserStorage()
        let presenter = MainPresenter(view: view, userStorage: userStorage)
        view.presenter = presenter
        return view
    }
}
