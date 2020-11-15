import Foundation
import ComposableArchitecture

struct EntryComposeState: Equatable {
    var title: String = ""
    var date = Date()
    var componentStates: [EntryComposeComponentState] = []
    var settingsState: SettingsComponentState

    var editingState: EntryComposeComponentState?

    var showsImagePicker = false
    var pickedImage: Data?
    var uploadButtonTitle = "Upload"
    var uploadButtonEnabled = true
    var uploadMessage: String? = nil
    var showsSettings = false
}

