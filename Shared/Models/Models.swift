import Foundation

public struct ImageUploadContent: Codable {
    public struct Content: Codable {
        let downloadUrl: String
    }

    public struct CommitResponse: Codable {
        let content: Content
    }

    let commitResponse: CommitResponse
    let filename: String
}

public struct PostContent: Codable {
    let repo: String
    let accessToken: String
    let title: String?
    let postfolder: String
    let content: [ContentPart]
}

public enum ContentPart: Codable, Identifiable {
    public var id: UUID {
        return UUID()
    }

    case header(String)
    case paragraph(String)
    case image(String)

    enum CodingError: Error {
        case decoding(String)
    }

    enum CodingKeys: String, CodingKey {
        case type
        case value
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard let typeString = try? container.decode(String.self, forKey: .type),
            let valueString = try? container.decode(String.self, forKey: .value) else {
            throw CodingError.decoding("ContentPart couldn't be decoded")
        }

        switch typeString {
        case "Header":
            self = .header(valueString)
        case "Paragraph":
            self = .paragraph(valueString)
        case "Image":
            self = .image(valueString)
        default:
            throw CodingError.decoding("ImageResource couldn't be decoded")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .header(let value):
            try? container.encode("Header", forKey: .type)
            try? container.encode(value, forKey: .value)
        case .paragraph(let value):
            try? container.encode("Paragraph", forKey: .type)
            try? container.encode(value, forKey: .value)
        case .image(let value):
            try? container.encode("Image", forKey: .type)
            try? container.encode(value, forKey: .value)
        }
    }
}
