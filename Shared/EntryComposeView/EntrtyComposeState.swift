import Foundation
import ComposableArchitecture

struct EntryComposeState: Equatable {
    var title: String = ""
    var postfolder = EntryComposeState.posfolder()
    var componentStates: [EntryComposeComponentState] = []
    var settingsState: SettingsComponentState

    var editingState: EntryComposeComponentState?

    var showsImagePicker = false
    var pickedImage: Data?
    var uploadButtonTitle = "Upload"
    var uploadButtonEnabled = true
    var showsSettings = false

    static func posfolder() -> String {
        return Date().iso8601withFractionalSeconds
    }
}

