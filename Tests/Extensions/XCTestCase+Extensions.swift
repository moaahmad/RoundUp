//
//  XCTestCase+Extensions.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 12/09/2024.
//

import XCTest

// MARK: - Memory Leak Tracking

extension XCTestCase {
    func trackForMemoryLeaks(
        _ instance: AnyObject,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(
                instance,
                "Instance should have been deallocated. Potential memory leak.",
                file: file,
                line: line
            )
        }
    }
}
