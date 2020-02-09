// Copyright Keefer Taylor, 2018

import TezosKit
import XCTest

class RevealOperationTest: XCTestCase {
<<<<<<< HEAD
  public func testDictionaryRepresentation() {
    let publicKey = FakePublicKey.testPublicKey

    guard case let .success(operation) = OperationFactory.testFactory.revealOperation(
      from: publicKey.publicKeyHash,
      publicKey: publicKey,
      operationFeePolicy: .default,
      signatureProvider: FakeSignatureProvider.testSignatureProvider
    ) else {
      XCTFail()
      return
    }
    let dictionary = operation.dictionaryRepresentation

    XCTAssertNotNil(dictionary["source"])
    XCTAssertEqual(dictionary["source"] as? String, publicKey.publicKeyHash)

    XCTAssertNotNil(dictionary["public_key"])
    XCTAssertEqual(dictionary["public_key"] as? String, publicKey.base58CheckRepresentation)
  }
=======
//  public func testDictionaryRepresentation() {
//    let source = "tz1abc"
//    let publicKey = FakePublicKey(base58CheckRepresentation: "edpkXYZ", signingCurve: .ed25519)
//
//    let operation = OperationFactory.testFactory.revealOperation(
//      from: source,
//      publicKey: publicKey,
//      operationFeePolicy: .default,
//      signatureProvider: FakeSignatureProvider.testSignatureProvider
//    )!
//    let dictionary = operation.dictionaryRepresentation
//
//    XCTAssertNotNil(dictionary["source"])
//    XCTAssertEqual(dictionary["source"] as? String, source)
//
//    XCTAssertNotNil(dictionary["public_key"])
//    XCTAssertEqual(dictionary["public_key"] as? String, publicKey.base58CheckRepresentation)
//  }
>>>>>>> master
}
