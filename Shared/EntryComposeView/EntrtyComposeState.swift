import Foundation
import ComposableArchitecture

struct EntryComposeState: Equatable, Identifiable {
    var id: String {
        return settingsState.blogConfig.id.uuidString
    }

    var title: String = ""
    var date = Date()
    var componentStates: [EntryComposeComponentState] = []
    var settingsState: SettingsComponentState

    var showsImagePicker = false
    var pickedImage: Data?
    var uploadButtonTitle = "Upload"
    var uploadButtonEnabled = true
    var uploadMessage: String? = nil
    var showsSettings = false
}

