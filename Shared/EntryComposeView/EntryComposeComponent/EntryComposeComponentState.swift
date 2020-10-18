import Foundation

struct EntryComposeComponentState: Equatable, Identifiable {
    enum ComponentType: Equatable {
        case headline(String)
        case paragraph(String)
        case imageURL(Data, String)
        case link(title: String, urlString: String)
        case uploadingImage(Data)
    }

    var componentType: ComponentType

    let id: UUID = UUID()

    var text: String {
        switch componentType {
        case .headline(let string):
            return string
        case .paragraph(let string):
            return string
        case .imageURL:
            return "Image"
        case .uploadingImage:
            return "Uploading"
        case .link:
            return "Link"
        }
    }

    func toContentPart() -> ContentPart? {
        switch componentType {
        case .headline(let string):
            return .header(string)
        case .imageURL(_, let filename):
            return .image(filename: filename)
        case .paragraph(let string):
            return .paragraph(string)
        case .uploadingImage:
            return nil
        case .link(let title, let urlString):
            return .link(title: title, urlString: urlString)
        }
    }
}
