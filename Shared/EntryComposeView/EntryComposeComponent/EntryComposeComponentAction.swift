import Foundation

enum EntryComposeComponentAction {
    case changeParagraph(String)
    case changeHeadline(String)
    case changeImage(Data, URL?, filename: String?)
    case uploadImageIfNeeded
    case delete
}
