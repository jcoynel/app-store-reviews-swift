import Foundation
import Logging

extension Feed.Author {
    init?(_ author: DecodableFeed.EntryAuthor) {
        guard let uri = URL(string: author.uri.label) else {
            Logger.asrLogger.error("Failed to create URL from string: \(author.uri.label)")
            return nil
        }

        self.init(name: author.name.label, uri: uri)
    }

    init?(_ author: DecodableFeed.FeedAuthor) {
        guard let uri = URL(string: author.uri.label) else {
            Logger.asrLogger.error("Failed to create URL from string: \(author.uri.label)")
            return nil
        }

        self.init(
            name: author.name.label,
            uri: uri
        )
    }
}

extension Feed.Entry {
    init?(_ entry: DecodableFeed.Entry, territory: Territory, appID: Int) {
        guard let author = Feed.Author(entry.author),
              let rating = Int(entry.imRating.label),
              let voteCount = Int(entry.imVoteCount.label),
              let voteSum = Int(entry.imVoteSum.label) else {
            Logger.asrLogger.error("Failed to convert DecodableFeed.Entry values with ID: \(entry.id.label)")
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
            voteSum: voteSum,
            territory: territory,
            appID: appID
        )
    }
}

extension Feed {
    init?(_ feed: DecodableFeed.Feed) {
        guard let author = Feed.Author(feed.author),
              let updated = ISO8601DateFormatter().date(from: feed.updated.label),
              let links = Feed.Links(feed.link) else {
            Logger.asrLogger.error("Failed to convert DecodableFeed.Feed values.")
            return nil
        }

        guard let currentPage = Page(links.current) else {
            Logger.asrLogger.error("Failed to generate pages from links.")
            return nil
        }

        var firstPage: Page? = nil
        if let firstLink = links.first {
            firstPage = Page(firstLink)
        }
        var lastPage: Page? = nil
        if let lastLink = links.last {
            lastPage = Page(lastLink)
        }

        var previousPage: Page? = nil
        if let firstPage = firstPage,
           currentPage.page > firstPage.page,
           let page = try? Page(appID: currentPage.appID, territory: currentPage.territory, page: currentPage.page - 1) {
            previousPage = page
        }

        var nextPage: Page? = nil
        if let lastPage = lastPage,
           currentPage.page < lastPage.page,
           let page = try? Page(appID: currentPage.appID, territory: currentPage.territory, page: currentPage.page + 1) {
            nextPage = page
        }

        self.init(
            author: author,
            entries: feed.entry?.compactMap { Feed.Entry($0, territory: currentPage.territory, appID: currentPage.appID) } ?? [],
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
              let current = links[.current] else {
            return nil
        }
        self.init(
            alternate: alternate,
            current: current,
            first: links[.first],
            last: links[.last],
            previous: links[.previous],
            next: links[.next]
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
