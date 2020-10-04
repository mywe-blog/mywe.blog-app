import Foundation

struct EntryComposeComponentState: Equatable, Identifiable {
    enum ComponentType: Equatable {
        case headline(String)
        case paragraph(String)
        case imageURL(URL)
        case uploadingImage(Data, startUpload: Bool)
    }

    var componentType: ComponentType

    let id: UUID = UUID()

    var text: String {
        switch componentType {
        case .headline(let string):
            return string
        case .paragraph(let string):
            return string
        case .imageURL(let url):
            return url.absoluteString
        case .uploadingImage:
            return "Uploading"
        }
    }

    func toContentPart() -> ContentPart? {
        switch componentType {
        case .headline(let string):
            return .header(string)
        case .imageURL(let url):
            return .image(url.absoluteString)
        case .paragraph(let string):
            return .paragraph(string)
        case .uploadingImage:
            return nil
        }
    }
}