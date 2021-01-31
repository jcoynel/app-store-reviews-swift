import Foundation

/// DecodableFeed defines the various models used to decode the reviews feed json. It is intended to be
/// used only for that purpose and should not be made public outside of this package.
struct DecodableFeed {
    struct CustomerReviews: Decodable {
        let feed: Feed
    }

    struct Feed: Decodable {
        let author: FeedAuthor
        let entry: [Entry]?
        let updated, rights, title, icon: Text
        let link: [LinkElement]
        let id: Text
    }

    struct FeedAuthor: Decodable {
        let name, uri: Text
    }

    struct Text: Decodable {
        let label: String
    }

    struct Entry: Decodable {
        let author: EntryAuthor
        let imVersion, imRating, id, title: Text
        let content: Content
        let link: EntryLink
        let imVoteSum: Text
        let imContentType: IMContentType
        let imVoteCount: Text

        enum CodingKeys: String, CodingKey {
            case author
            case imVersion = "im:version"
            case imRating = "im:rating"
            case id, title, content, link
            case imVoteSum = "im:voteSum"
            case imContentType = "im:contentType"
            case imVoteCount = "im:voteCount"
        }
    }

    struct EntryAuthor: Decodable {
        let uri, name: Text
        let label: String
    }

    struct Content: Decodable {
        let label: String
        let attributes: ContentAttributes
    }

    struct ContentAttributes: Decodable {
        let type: TypeEnum
    }

    enum TypeEnum: String, Decodable {
        case text = "text"
    }

    struct IMContentType: Decodable {
        let attributes: IMContentTypeAttributes
    }

    struct IMContentTypeAttributes: Decodable {
        let term, label: Label
    }

    enum Label: String, Decodable {
        case application = "Application"
    }

    struct EntryLink: Decodable {
        struct Attributes: Decodable {
            let rel: Rel
            let href: String
        }

        let attributes: Attributes
    }

    enum Rel: String, Decodable {
        case related = "related"
    }

    struct LinkElement: Decodable {
        struct Attributes: Decodable {
            let rel: String
            let type: String?
            let href: String
        }

        let attributes: Attributes
    }
}
