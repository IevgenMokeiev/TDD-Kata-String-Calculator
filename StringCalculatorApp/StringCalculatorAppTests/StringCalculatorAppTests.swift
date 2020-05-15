//
//  StringCalculatorAppTests.swift
//  StringCalculatorAppTests
//
//  Created by Yevhen Mokeiev on 14.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import XCTest
@testable import StringCalculatorApp

enum StringCalculatorError: Error {
    case negativeError(String)
}

class StringCalculator {
    func add(numbers: String) throws -> Int  {
        let (formattedString, delimeter) = parseDelimeter(numbers: numbers)

        if let delimeter = delimeter {
            return try sum(numbers: formattedString, delimeterSet: CharacterSet(charactersIn: delimeter))
        } else {
            return try sum(numbers: formattedString, delimeterSet: [",", "\n"])
        }
    }

    func sum(numbers: String, delimeterSet: CharacterSet) throws -> Int {
        let components = numbers.components(separatedBy: delimeterSet)
        return try components.reduce(0) { $0 + (try convertToInt(string: $1)) }
    }

    func convertToInt(string: String) throws -> Int {
        let integer = Int(string) ?? 0

        if integer < 0 {
            throw StringCalculatorError.negativeError("negatives not allowed: \(integer)")
        }

        return integer
    }

    func parseDelimeter(numbers: String) -> (formattedString: String, delimeter: String?) {

        if let firstComponent = numbers.split(separator: "\n").first, firstComponent.starts(with: "//") {
            let delimeter = String(firstComponent.dropFirst(2))
            let components = numbers.split(separator: "\n").dropFirst()
            let formattedString = components.joined()
            return (formattedString, delimeter)
        }

        return (numbers, nil)
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

    //5.
    func test_exception_for_negative_number() {
        expectThrows(numbers: "//;\n-1;2", errorMessage: "negatives not allowed: -1")
    }

    func test_exception_for_negative_numbers() {
        expectThrows(numbers: "//;\n-1;-2", errorMessage: "negatives not allowed: -1, -2")
    }

    //MARK: - Private
    private func expect(numbers: String, result: Int, file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(try StringCalculator().add(numbers: numbers) == result, file: file, line: line)
    }

    private func expectThrows(numbers: String, errorMessage: String, file: StaticString = #file, line: UInt = #line) {
        XCTAssertThrowsError(try StringCalculator().add(numbers: numbers), file: file, line: line) { error in
            guard case StringCalculatorError.negativeError(let message) = error else {
                return XCTFail("wrong error")
            }

            XCTAssertTrue(message == errorMessage, file: file, line: line)
        }
    }
}
