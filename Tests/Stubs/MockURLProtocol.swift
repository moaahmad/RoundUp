//
//  MockURLProtocol.swift
//  StarlingRoundUpTests
//
//  Created by Mo Ahmad on 12/09/2024.
//

import Foundation

class MockURLProtocol: URLProtocol {
    private static var stub: Stub?
    private static var requestObserver: ((URLRequest) -> Void)?
    private struct Stub {
        let data: Data?
        let response: URLResponse?
        let error: Error?
    }

    static func stub(data: Data?, response: URLResponse?, error: Error?) {
        stub = Stub(data: data, response: response, error: error)
    }

    static func observeRequests(observer: @escaping (URLRequest) -> Void) {
        requestObserver = observer
    }

    static func startInterceptingRequests() {
        URLProtocol.registerClass(MockURLProtocol.self)
    }

    static func stopInterceptingRequests() {
        URLProtocol.unregisterClass(MockURLProtocol.self)
        stub = nil
        requestObserver = nil
    }

    override class func canInit(with request: URLRequest) -> Bool {
        requestObserver?(request)
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let data = MockURLProtocol.stub?.data {
            client?.urlProtocol(self, didLoad: data)
        }

        if let response = MockURLProtocol.stub?.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }

        if let error = MockURLProtocol.stub?.error {
            client?.urlProtocol(self, didFailWithError: error)
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
