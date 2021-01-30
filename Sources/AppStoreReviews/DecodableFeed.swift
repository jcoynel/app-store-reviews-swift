import Foundation

/// DecodableFeed defines the various models used to decode the reviews feed json. It is intended to be
/// used only for that purpose and should not be made public outside of this package.
struct DecodableFeed {
    struct CustomerReviews: Decodable {
        let feed: Feed

        init(feed: Feed) {
            self.feed = feed
        }
    }

    struct Feed: Decodable {
        let author: FeedAuthor
        let entry: [Entry]?
        let updated, rights, title, icon: Text
        let link: [LinkElement]
        let id: Text

        init(author: FeedAuthor, entry: [Entry], updated: Text, rights: Text, title: Text, icon: Text, link: [LinkElement], id: Text) {
            self.author = author
            self.entry = entry
            self.updated = updated
            self.rights = rights
            self.title = title
            self.icon = icon
            self.link = link
            self.id = id
        }
    }

    struct FeedAuthor: Decodable {
        let name, uri: Text

        init(name: Text, uri: Text) {
            self.name = name
            self.uri = uri
        }
    }

    struct Text: Decodable {
        let label: String

        init(label: String) {
            self.label = label
        }
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

        init(author: EntryAuthor, imVersion: Text, imRating: Text, id: Text, title: Text, content: Content, link: EntryLink, imVoteSum: Text, imContentType: IMContentType, imVoteCount: Text) {
            self.author = author
            self.imVersion = imVersion
            self.imRating = imRating
            self.id = id
            self.title = title
            self.content = content
            self.link = link
            self.imVoteSum = imVoteSum
            self.imContentType = imContentType
            self.imVoteCount = imVoteCount
        }
    }

    struct EntryAuthor: Decodable {
        let uri, name: Text
        let label: String

        init(uri: Text, name: Text, label: String) {
            self.uri = uri
            self.name = name
            self.label = label
        }
    }

    struct Content: Decodable {
        let label: String
        let attributes: ContentAttributes

        init(label: String, attributes: ContentAttributes) {
            self.label = label
            self.attributes = attributes
        }
    }

    struct ContentAttributes: Decodable {
        let type: TypeEnum

        init(type: TypeEnum) {
            self.type = type
        }
    }

    enum TypeEnum: String, Decodable {
        case text = "text"
    }

    struct IMContentType: Decodable {
        let attributes: IMContentTypeAttributes

        init(attributes: IMContentTypeAttributes) {
            self.attributes = attributes
        }
    }

    struct IMContentTypeAttributes: Decodable {
        let term, label: Label

        init(term: Label, label: Label) {
            self.term = term
            self.label = label
        }
    }

    enum Label: String, Decodable {
        case application = "Application"
    }

    struct EntryLink: Decodable {
        struct Attributes: Decodable {
            let rel: Rel
            let href: String

            init(rel: Rel, href: String) {
                self.rel = rel
                self.href = href
            }
        }

        let attributes: Attributes

        init(attributes: Attributes) {
            self.attributes = attributes
        }
    }

    enum Rel: String, Decodable {
        case related = "related"
    }

    struct LinkElement: Decodable {
        struct Attributes: Decodable {
            let rel: String
            let type: String?
            let href: String

            init(rel: String, type: String?, href: String) {
                self.rel = rel
                self.type = type
                self.href = href
            }
        }

        let attributes: Attributes

        init(attributes: Attributes) {
            self.attributes = attributes
        }
    }
}
