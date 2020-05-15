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
        let components = numbers.components(separatedBy: [",", "\n"])
        return components.reduce(0) { $0 + (Int($1) ?? 0) }
    }
}

class StringCalculatorAppTests: XCTestCase {

    // 1.
    func test_0_empty_string() {
        expect(numbers: "", result: 0)
    }

    func test_1_number_string() {
        expect(numbers: "1", result: 1)
    }

    func test_2_numbers_string() {
        expect(numbers: "1,2", result: 3)
    }

    // 2.
    func test_3_numbers_string() {
        expect(numbers: "1,2,4", result: 7)
    }

    func test_5_numbers_string() {
        expect(numbers: "1,2,4,6,4", result: 17)
    }

    // 3.
    func test_newline_separator() {
        expect(numbers: "1\n2,4\n6,4", result: 17)
    }

    //MARK: - Private

    private func expect(numbers: String, result: Int, file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(StringCalculator().add(numbers: numbers) == result, file: file, line: line)
    }
}
