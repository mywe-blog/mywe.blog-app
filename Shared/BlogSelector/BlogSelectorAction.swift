import Foundation

enum BlogSelectorAction {
    case entryComposeAction(Int, EntryComposeAction)
    case showSettings(BlogConfiguration)
    case setShowSettingsActive(Bool)
    case delete(BlogConfiguration)
}
