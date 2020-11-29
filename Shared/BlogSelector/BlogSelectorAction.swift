import Foundation

enum BlogSelectorAction {
    case selectBlog(BlogConfiguration)
    case entryComposeAction(EntryComposeAction)
    case setNavigationActive(Bool)
    case showSettings(BlogConfiguration)
    case settingsAction(SettingsComponentAction)
    case setShowSettingsActive(Bool)
}
