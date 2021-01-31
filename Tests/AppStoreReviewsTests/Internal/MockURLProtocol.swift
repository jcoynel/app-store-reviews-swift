import Foundation

/// Provides the ability to mock network calls.
///
/// Reference: [Apple Developer Documentation - URLProtocol](https://developer.apple.com/documentation/foundation/urlprotocol)
final class MockURLProtocol: URLProtocol {
    static var mockResponse: ResponseFields?

    // MARK: URLProtocol

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let url = request.url,
           let responseFields = MockURLProtocol.mockResponse {
            if responseFields.isHTTPURLResponse == false {
                let response = URLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            } else if let response = HTTPURLResponse(url: url,
                                              statusCode: responseFields.statusCode,
                                              httpVersion: responseFields.httpVersion,
                                              headerFields: responseFields.headerFields) {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                client?.urlProtocol(self, didLoad: responseFields.data)
            }
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

extension MockURLProtocol {
    struct ResponseFields {
        let statusCode: Int
        let httpVersion: String?
        let headerFields: [String: String]?
        let data: Data
        let isHTTPURLResponse: Bool

        init(statusCode: Int = 200,
             httpVersion: String? = nil,
             headerFields: [String: String]? = nil,
             data: Data,
             isHTTPURLResponse: Bool = true
        ) {
            self.statusCode = statusCode
            self.httpVersion = httpVersion
            self.headerFields = headerFields
            self.data = data
            self.isHTTPURLResponse = isHTTPURLResponse
        }
    }
}
