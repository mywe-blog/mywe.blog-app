import Foundation

enum BlogSelectorAction {
    case entryComposeAction(Int, EntryComposeAction)
    case showSettings(SettingsComponentState)
    case setShowSettingsActive(Bool)
    case delete(BlogConfiguration)
    case addBlog
    case settingsAction(SettingsComponentAction)
}
