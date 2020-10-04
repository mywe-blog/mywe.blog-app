import Foundation

enum EntryComposeComponentAction {
    case changeText(String)
    case changeImage(URL?, filename: String?)
    case uploadImageIfNeeded
    case delete
}
