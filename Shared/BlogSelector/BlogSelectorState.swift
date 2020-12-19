import Foundation

struct BlogSelectorState: Equatable {
    var allComposeComponentStates: [EntryComposeState] = []
    var selectedSettingsComponentsState: SettingsComponentState?
    var showsSettings = false
}
