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

        let result = components.reduce((number: 0, message: [String]())) {
            let integer = Int($1) ?? 0
            return (integer > 1000 ? $0.number : $0.number + integer, integer < 0 ? $0.message + [$1] : $0.message)
        }

        if result.message.count > 0 {
            let detailMessage = result.message.joined(separator: ", ")
            throw StringCalculatorError.negativeError("negatives not allowed: " + detailMessage)
        }

        return result.number
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

    // MARK: - 1.
    func test_0_empty_string() {
        expect(numbers: "", result: 0)
    }

    func test_1_2_numbers_string() {
        expect(numbers: "1", result: 1)
        expect(numbers: "1,2", result: 3)
    }

    // MARK: - 2.
    func test_several_numbers_string() {
        expect(numbers: "1,2,4", result: 7)
        expect(numbers: "1,2,4,6", result: 13)
        expect(numbers: "1,2,4,6,4", result: 17)
        expect(numbers: "1,2,4,6,4,1000", result: 1017)
    }

    // MARK: - 3.
    func test_newline_separator() {
        expect(numbers: "1\n2,4\n6,4", result: 17)
    }

    // MARK: - 4.
    func test_different_delimeters() {
        expect(numbers: "//;\n1;2", result: 3)
        expect(numbers: "//e\n1e2", result: 3)
        expect(numbers: "//`\n1`2`4", result: 7)
    }

    // MARK: - 5.
    func test_exception_for_negative_numbers() {
        expectThrows(numbers: "//;\n-1;2", errorMessage: "negatives not allowed: -1")
        expectThrows(numbers: "//;\n-1;-2", errorMessage: "negatives not allowed: -1, -2")
    }

    // MARK: - 6.
    func test_bigger_than_1000_igmored() {
        expect(numbers: "1\n2,4\n6,1001", result: 13)
    }

    // MARK: - 7.
    func test_delimeter_any_length_allowed() {
        expect(numbers: "//[***]\n1***2***3", result: 6)
    }

    // MARK: - 8.
    func test_multiple_delimeters_allowed() {
        expect(numbers: "//[*][%]\n1*2%3", result: 6)
    }

    // MARK: - 9.
    func test_multiple_delimeters_any_length_allowed() {
        expect(numbers: "//[**][%]\n1**2%3", result: 6)
    }

    // MARK: - Private
    private func expect(numbers: String, result: Int, file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(try StringCalculator().add(numbers: numbers) == result, file: file, line: line)
    }

    private func expectThrows(numbers: String, errorMessage: String, file: StaticString = #file, line: UInt = #line) {
        XCTAssertThrowsError(try StringCalculator().add(numbers: numbers), file: file, line: line) { error in
            guard case StringCalculatorError.negativeError(let message) = error else {
                return XCTFail("wrong error")
            }

            XCTAssertTrue(message == errorMessage, message, file: file, line: line)
        }
    }
}
