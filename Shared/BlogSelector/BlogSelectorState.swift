import Foundation

struct BlogSelectorState: Equatable {
    var allBlogs: [BlogConfiguration]
    var composeComponentState = EntryComposeState()
    var settingsState = SettingsComponentState()

    var navigationActive = false
    var showsSettings = false
}
