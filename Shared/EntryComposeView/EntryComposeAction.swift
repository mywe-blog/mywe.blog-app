import Foundation

enum EntryComposeAction {
    case updateTitle(text: String)
    case selectImage
    case showsImagePicker(Bool)
    case imageSelectionResponse(Data?)
    case addParagraph
    case addHeadline
    case composeAction(Int, EntryComposeComponentAction)
    case settingsAction(SettingsComponentAction)
    case showSettings(Bool)
    case move(items: IndexSet, position: Int)
    case upload
    case uploadSuccess(Bool)
}
