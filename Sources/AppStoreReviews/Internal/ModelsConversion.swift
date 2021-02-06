import Foundation
import OSLog

extension Feed.Author {
    init?(_ author: DecodableFeed.EntryAuthor) {
        guard let uri = URL(string: author.uri.label) else {
            Logger().error("Failed to create URL from string: \(author.uri.label)")
            return nil
        }

        self.init(name: author.name.label, uri: uri)
    }

    init?(_ author: DecodableFeed.FeedAuthor) {
        guard let uri = URL(string: author.uri.label) else {
            Logger().error("Failed to create URL from string: \(author.uri.label)")
            return nil
        }

        self.init(
            name: author.name.label,
            uri: uri
        )
    }
}

extension Feed.Entry {
    init?(_ entry: DecodableFeed.Entry) {
        guard let author = Feed.Author(entry.author),
              let rating = Int(entry.imRating.label),
              let voteCount = Int(entry.imVoteCount.label),
              let voteSum = Int(entry.imVoteSum.label) else {
            Logger().error("Failed to convert DecodableFeed.Entry values with ID: \(entry.id.label)")
            return nil
        }

        self.init(
            author: author,
            appVersion: entry.imVersion.label,
            rating: rating,
            id: entry.id.label,
            title: entry.title.label,
            description: entry.content.label,
            voteCount: voteCount,
            voteSum: voteSum
        )
    }
}

extension Feed {
    init?(_ feed: DecodableFeed.Feed) {
        guard let author = Feed.Author(feed.author),
              let updated = ISO8601DateFormatter().date(from: feed.updated.label),
              let links = Feed.Links(feed.link) else {
            Logger().error("Failed to convert DecodableFeed.Feed values.")
            return nil
        }

        guard let currentPage = Page(links.current),
              let firstPage = Page(links.first),
              let lastPage = Page(links.last) else {
            Logger().error("Failed to generate pages from links.")
            return nil
        }

        var previousPage: Page? = nil
        if currentPage.page > firstPage.page, let page = try? Page(appID: currentPage.appID, territory: currentPage.territory, page: currentPage.page - 1) {
            previousPage = page
        }

        var nextPage: Page? = nil
        if currentPage.page < lastPage.page, let page = try? Page(appID: currentPage.appID, territory: currentPage.territory, page: currentPage.page + 1) {
            nextPage = page
        }

        self.init(
            author: author,
            entries: feed.entry?.compactMap { Feed.Entry($0) } ?? [],
            title: feed.title.label,
            rights: feed.rights.label,
            updated: updated,
            links: links,
            currentPage: currentPage,
            firstPage: firstPage,
            lastPage: lastPage,
            previousPage: previousPage,
            nextPage: nextPage
        )
    }
}

extension Feed.Links {
    init?(_ links: [DecodableFeed.LinkElement]) {
        guard let alternate = links[.alternate],
              let current = links[.current],
              let first = links[.first],
              let last = links[.last],
              let previous = links[.previous],
              let next = links[.next] else {
            return nil
        }
        self.init(
            alternate: alternate,
            current: current,
            first: first,
            last: last,
            previous: previous,
            next: next
        )
    }
}

// MARK: - Helpers

private enum RelKeys: String {
    case alternate
    case current = "self"
    case first
    case last
    case previous
    case next
}

extension Array where Element == DecodableFeed.LinkElement {
    fileprivate subscript(rel: RelKeys) -> URL? {
        guard let href = first(where: { $0.attributes.rel == rel.rawValue })?.attributes.href else {
            return nil
        }
        return URL(string: href)
    }
}
