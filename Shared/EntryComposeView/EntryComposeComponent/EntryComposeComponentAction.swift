import Foundation

enum EntryComposeComponentAction {
    case changeParagraph(String)
    case changeHeadline(String)
    case changeImage(URL?, filename: String?)
    case uploadImageIfNeeded
    case delete
}
