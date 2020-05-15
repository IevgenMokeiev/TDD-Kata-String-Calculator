//
//  StringCalculatorAppTests.swift
//  StringCalculatorAppTests
//
//  Created by Yevhen Mokeiev on 14.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import XCTest
@testable import StringCalculatorApp

class StringCalculator {
    func add(numbers: String) -> Int {
        let components = numbers.components(separatedBy: ",")
        return components.reduce(0) { $0 + (Int($1) ?? 0) }
    }
}

class StringCalculatorAppTests: XCTestCase {

    // 1.
    func test_0_empty_string() {
        XCTAssertTrue(makeSUT().add(numbers: "") == 0)
    }

    func test_1_number_string() {
        XCTAssertTrue(makeSUT().add(numbers: "1") == 1)
    }

    func test_2_numbers_string() {
        XCTAssertTrue(makeSUT().add(numbers: "1,2") == 3)
    }

    // 2.
    func test_3_numbers_string() {
         XCTAssertTrue(makeSUT().add(numbers: "1,2,4") == 7)
    }

    func test_5_numbers_string() {
         XCTAssertTrue(makeSUT().add(numbers: "1,2,4,6,4") == 17)
    }

    // 3.

    func makeSUT() -> StringCalculator {
        return StringCalculator()
    }
}
