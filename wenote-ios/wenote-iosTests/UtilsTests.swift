//
//  UtilsTests.swift
//  wenote-iosTests
//
//  Created by Yan Cheng Cheok on 20/09/2021.
//

import XCTest
@testable import wenote_ios

class UtilsTests: XCTestCase {

    func testGetInvalidOrder() {
        XCTAssertEqual(0, Utils.getInvalidOrder())
    }
    
    func testIsValidOrder() {
        XCTAssertTrue(Utils.isValidOrder(1))
        XCTAssertTrue(Utils.isValidOrder(2))
        XCTAssertTrue(Utils.isValidOrder(3))
        
        XCTAssertTrue(Utils.isValidOrder(-1))
        XCTAssertTrue(Utils.isValidOrder(-2))
        XCTAssertTrue(Utils.isValidOrder(-3))
        
        XCTAssertFalse(Utils.isValidOrder(0))
    }

    func testGenerateSearchedStringWithLocked() {
        generateSearchedString(locked: false)
    }

    func testGenerateSearchedStringWithoutLocked() {
        generateSearchedString(locked: true)
    }
    
    private func generateSearchedString(locked: Bool) {

        //
        // NULL STRING
        //
        var body: String? = nil
        var type: PlainNote.Kind = .text
        var expected: String? = locked ? nil : nil
        var output = Utils.generateSearchedString(body: body, kind: type, locked: locked)
        XCTAssertEqual(expected, output)
        
        body = nil
        type = .checklist
        expected = locked ? nil : nil
        output = Utils.generateSearchedString(body: body, kind: type, locked: locked)
        XCTAssertEqual(expected, output)

        //
        // EMPTY STRING
        //
        body = ""
        type = .text
        expected = nil
        output = Utils.generateSearchedString(body: body, kind: type, locked: locked)
        XCTAssertEqual(expected, output)

        body = ""
        type = .checklist
        expected = locked ? nil : ""
        output = Utils.generateSearchedString(body: body, kind: type, locked: locked)
        XCTAssertEqual(expected, output)

        //
        // NON-EMPTY STRING
        //
        body = "hello"
        type = .text
        expected = nil
        output = Utils.generateSearchedString(body: body, kind: type, locked: locked)
        XCTAssertEqual(expected, output)

        body = "[{\"i\":1,\"t\":\"hello\",\"c\":true},{\"i\":2,\"t\":\"world\",\"c\":false},{\"i\":3,\"t\":\"good bye\",\"c\":true}]"
        type = .checklist
        expected = locked ? nil : "hello\nworld\ngood bye"
        output = Utils.generateSearchedString(body: body, kind: type, locked: locked)
        XCTAssertEqual(expected, output)

        //
        // SPECIAL NULL/ EMPTY STRING HANDLING IN CHECKLISTS.
        //
        body = "[{\"i\":1,\"t\":\"hello\",\"c\":true},{\"i\":2,\"t\":null,\"c\":false},{\"i\":3,\"t\":\"good bye\",\"c\":true}]"
        type = .checklist
        expected = locked ? nil : "hello\ngood bye"
        output = Utils.generateSearchedString(body: body, kind: type, locked: locked)
        XCTAssertEqual(expected, output)

        body = "[{\"i\":1,\"t\":\"hello\",\"c\":true},{\"i\":2,\"c\":false},{\"i\":3,\"t\":\"good bye\",\"c\":true}]"
        type = .checklist
        expected = locked ? nil : "hello\ngood bye"
        output = Utils.generateSearchedString(body: body, kind: type, locked: locked)
        XCTAssertEqual(expected, output)

        body = "[{\"i\":1,\"t\":\"hello\",\"c\":true},{\"i\":2,\"t\":\"\",\"c\":false},{\"i\":3,\"t\":\"good bye\",\"c\":true}]"
        type = .checklist
        expected = locked ? nil : "hello\n\ngood bye"
        output = Utils.generateSearchedString(body: body, kind: type, locked: locked)
        XCTAssertEqual(expected, output)

        body = "[{\"i\":1,\"t\":\"hello\",\"c\":true},{\"i\":2,\"t\":\" \",\"c\":false},{\"i\":3,\"t\":\"good bye\",\"c\":true}]"
        type = .checklist
        expected = locked ? nil : "hello\n \ngood bye"
        output = Utils.generateSearchedString(body: body, kind: type, locked: locked)
        XCTAssertEqual(expected, output)

        //
        // 1, 2 checklists
        //
        body = "[{\"i\":1,\"t\":\"hello\",\"c\":true}]"
        type = .checklist
        expected = locked ? nil : "hello"
        output = Utils.generateSearchedString(body: body, kind: type, locked: locked)
        XCTAssertEqual(expected, output)

        body = "[{\"i\":1,\"t\":\"hello\",\"c\":true},{\"i\":2,\"t\":\"world\",\"c\":false}]"
        type = .checklist
        expected = locked ? nil : "hello\nworld"
        output = Utils.generateSearchedString(body: body, kind: type, locked: locked)
        XCTAssertEqual(expected, output)
    }
    
    func testSizeToString() {
        var input: Int64 = 1023
        var use2DecimalPlacesIfPossible = false
        var expected = "1,023 B"
        var output = Utils.sizeToString(size: input, use2DecimalPlacesIfPossible: use2DecimalPlacesIfPossible)
        XCTAssertEqual(expected, output)

        input = 1025
        use2DecimalPlacesIfPossible = false
        expected = "1 kB"
        output = Utils.sizeToString(size: input, use2DecimalPlacesIfPossible: use2DecimalPlacesIfPossible)
        XCTAssertEqual(expected, output)

        input = 1048575
        use2DecimalPlacesIfPossible = false
        expected = "1,024 kB"
        output = Utils.sizeToString(size: input, use2DecimalPlacesIfPossible: use2DecimalPlacesIfPossible)
        XCTAssertEqual(expected, output)

        input = 1048576
        use2DecimalPlacesIfPossible = false
        expected = "1 MB"
        output = Utils.sizeToString(size: input, use2DecimalPlacesIfPossible: use2DecimalPlacesIfPossible)
        XCTAssertEqual(expected, output)

        input = 1048577
        use2DecimalPlacesIfPossible = false
        expected = "1 MB"
        output = Utils.sizeToString(size: input, use2DecimalPlacesIfPossible: use2DecimalPlacesIfPossible)
        XCTAssertEqual(expected, output)

        input = 9223372036854775807
        use2DecimalPlacesIfPossible = false
        expected = "8,796,093,022,208 MB"
        output = Utils.sizeToString(size: input, use2DecimalPlacesIfPossible: use2DecimalPlacesIfPossible)
        XCTAssertEqual(expected, output)

        input = 1023
        use2DecimalPlacesIfPossible = true
        expected = "1,023 B"
        output = Utils.sizeToString(size: input, use2DecimalPlacesIfPossible: use2DecimalPlacesIfPossible)
        XCTAssertEqual(expected, output)

        input = 1025
        use2DecimalPlacesIfPossible = true
        expected = "1 kB"
        output = Utils.sizeToString(size: input, use2DecimalPlacesIfPossible: use2DecimalPlacesIfPossible)
        XCTAssertEqual(expected, output)

        input = 1048575
        use2DecimalPlacesIfPossible = true
        expected = "1,024 kB"
        output = Utils.sizeToString(size: input, use2DecimalPlacesIfPossible: use2DecimalPlacesIfPossible)
        XCTAssertEqual(expected, output)

        input = 1048576
        use2DecimalPlacesIfPossible = true
        expected = "1.00 MB"
        output = Utils.sizeToString(size: input, use2DecimalPlacesIfPossible: use2DecimalPlacesIfPossible)
        XCTAssertEqual(expected, output)

        input = 1048577
        use2DecimalPlacesIfPossible = true
        expected = "1.00 MB"
        output = Utils.sizeToString(size: input, use2DecimalPlacesIfPossible: use2DecimalPlacesIfPossible)
        XCTAssertEqual(expected, output)

        input = 1148577
        use2DecimalPlacesIfPossible = true
        expected = "1.10 MB"
        output = Utils.sizeToString(size: input, use2DecimalPlacesIfPossible: use2DecimalPlacesIfPossible)
        XCTAssertEqual(expected, output)

        input = 9223372036854775807
        use2DecimalPlacesIfPossible = true
        expected = "8,796,093,022,208.00 MB"
        output = Utils.sizeToString(size: input, use2DecimalPlacesIfPossible: use2DecimalPlacesIfPossible)
        XCTAssertEqual(expected, output)
    }
    
    func testIsValidId() {
        XCTAssertTrue(Utils.isValidId(1))
        XCTAssertTrue(Utils.isValidId(2))
        XCTAssertFalse(Utils.isValidId(0))
        XCTAssertFalse(Utils.isValidId(-1))
        XCTAssertFalse(Utils.isValidId(-2))
    }
}
