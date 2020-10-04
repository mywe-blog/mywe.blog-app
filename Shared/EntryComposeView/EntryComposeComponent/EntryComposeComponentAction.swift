import Foundation

enum EntryComposeComponentAction {
    case changeText(String)
    case changeImage(URL?)
    case uploadImageIfNeeded
    case delete
}
