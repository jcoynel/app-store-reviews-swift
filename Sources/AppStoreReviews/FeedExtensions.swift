import Foundation

extension Feed {
    public var currentPage: Page? { Page(links.current) }
    public var firstPage: Page? { Page(links.first) }
    public var lastPage: Page? { Page(links.last) }
    public var previousPage: Page? {
        guard let currentPage = currentPage, let firstPage = firstPage, currentPage.page > firstPage.page else {
            return nil
        }
        return Page(links.previous)
    }
    public var nextPage: Page? {
        guard let currentPage = currentPage, let lastPage = lastPage, currentPage.page < lastPage.page else {
            return nil
        }
        return Page(links.next)
    }
}
