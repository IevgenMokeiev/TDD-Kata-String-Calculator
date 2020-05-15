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
        let (delimeter, formattedString) = parseDelimeter(numbers: numbers)

        if let delimeter = delimeter {
            let components = formattedString.components(separatedBy: delimeter)
            return components.reduce(0) { $0 + (Int($1) ?? 0) }
        } else {
            let components = formattedString.components(separatedBy: [",", "\n"])
            return components.reduce(0) { $0 + (Int($1) ?? 0) }
        }
    }

    func parseDelimeter(numbers: String) -> (delimeter: String?, formattedString: String) {

        if let firstComponent = numbers.split(separator: "\n").first, firstComponent.starts(with: "//") {
            let delimeter = String(firstComponent.dropFirst(2))
            let components = numbers.split(separator: "\n").dropFirst()
            let formattedString = components.joined()
            return (delimeter, formattedString)
        }

        return (nil, numbers)
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

    //4.
    func test_different_delimeters() {
        expect(numbers: "//;\n1;2", result: 3)
        expect(numbers: "//e\n1e2", result: 3)
        expect(numbers: "//`\n1`2`4", result: 7)
    }

    //MARK: - Private
    private func expect(numbers: String, result: Int, file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(StringCalculator().add(numbers: numbers) == result, file: file, line: line)
    }
}
