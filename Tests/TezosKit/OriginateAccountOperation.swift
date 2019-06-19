// Copyright Keefer Taylor, 2018

import TezosKit
import XCTest

class OriginationOperation: XCTestCase {
  public func testDictionaryRepresentation() {
    let address = "tz1abc123"
    let operation = OperationFactory.testFactory.originateOperation(address: address)
    let dictionary = operation.dictionaryRepresentation

    XCTAssertNotNil(dictionary["manager_pubkey"])
    XCTAssertEqual(dictionary["manager_pubkey"] as? String, address)

    XCTAssertNotNil(dictionary["balance"])
    XCTAssertEqual(dictionary["balance"] as? String, "0")
  }
}
