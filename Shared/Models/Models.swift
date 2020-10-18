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
    let date: Date
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
    case image(filename: String)

    enum CodingError: Error {
        case decoding(String)
    }

    enum CodingKeys: String, CodingKey {
        case type
        case text
        case filename
        case title
        case url
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard let typeString = try? container.decode(String.self, forKey: .type) else {
            throw CodingError.decoding("ContentPart couldn't be decoded")
        }

        switch typeString {
        case "Header":
            guard let valueString = try? container.decode(String.self, forKey: .text) else {
                throw CodingError.decoding("ContentPart couldn't be decoded")
            }

            self = .header(valueString)
        case "Paragraph":
            guard let valueString = try? container.decode(String.self, forKey: .text) else {
                throw CodingError.decoding("ContentPart couldn't be decoded")
            }

            self = .paragraph(valueString)
        case "Image":
            guard let valueString = try? container.decode(String.self, forKey: .filename) else {
                throw CodingError.decoding("ContentPart couldn't be decoded")
            }

            self = .image(filename: valueString)
        default:
            throw CodingError.decoding("ImageResource couldn't be decoded")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .header(let value):
            try? container.encode("Header", forKey: .type)
            try? container.encode(value, forKey: .text)
        case .paragraph(let value):
            try? container.encode("Paragraph", forKey: .type)
            try? container.encode(value, forKey: .text)
        case .image(let value):
            try? container.encode("Image", forKey: .type)
            try? container.encode(value, forKey: .filename)
        }
    }
}
