import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Provides the ability to mock network calls.
///
/// Reference: [Apple Developer Documentation - URLProtocol](https://developer.apple.com/documentation/foundation/urlprotocol)
final class MockURLProtocol: URLProtocol {
    /// Specify mock responses for specific urls.
    static var mockResponses = [URL: Response?]()
    /// Specify a mock response for all url calls not included in `mockResponses`.
    static var mockResponse: Response?
    /// Remove all test data.
    static func clearTestData() {
        mockResponse = nil
        mockResponses.removeAll()
    }

    // MARK: URLProtocol

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        let mockResponse: Response?
        if let url = request.url, Self.mockResponses.keys.contains(url) {
            mockResponse = Self.mockResponses[url]?.flatMap { $0 }
        } else {
            mockResponse = Self.mockResponse
        }

        switch mockResponse {
        case .error(let error):
            client?.urlProtocol(self, didFailWithError: error)
            return
        case .nonHTTPURLResponse:
            if let url = request.url {
                let response = URLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
        case .HTTPURLResponse(let responseFields):
            if let url = request.url,
               let response = HTTPURLResponse(
                url: url,
                statusCode: responseFields.statusCode,
                httpVersion: responseFields.httpVersion,
                headerFields: responseFields.headerFields) {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                client?.urlProtocol(self, didLoad: responseFields.data)
            }
        case .none:
            break
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

extension MockURLProtocol {
    enum Response {
        case error(Error)
        case nonHTTPURLResponse
        case HTTPURLResponse(ResponseFields)
    }

    struct ResponseFields {
        let statusCode: Int
        let httpVersion: String?
        let headerFields: [String: String]?
        let data: Data

        init(statusCode: Int = 200,
             httpVersion: String? = nil,
             headerFields: [String: String]? = nil,
             data: Data
        ) {
            self.statusCode = statusCode
            self.httpVersion = httpVersion
            self.headerFields = headerFields
            self.data = data
        }
    }
}
