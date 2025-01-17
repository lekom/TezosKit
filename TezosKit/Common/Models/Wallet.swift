// Copyright Keefer Taylor, 2018

import Base58Swift
import Foundation
import Sodium

/// A model of a wallet in the Tezos ecosystem.
///
/// Clients can create a new wallet by calling the empty initializer. Clients can also restore an existing wallet by
/// providing an mnemonic and optional passphrase.
///
/// - Warning: This class stores a secret key in memory. It is possible that memory can be compromised and that the secret key can be read, even after this
///            object is deallocated. For more information, see Apple's guidelines on password handling:
///            https://developer.apple.com/library/archive/documentation/Security/Conceptual/SecureCodingGuide/SecurityDevelopmentChecklists/SecurityDevelopmentChecklists.html#//apple_ref/doc/uid/TP40002415-CH1-SW6
///
public struct Wallet {
  /// Keys for the wallet.
  public let publicKey: PublicKeyProtocol
  internal let secretKey: SecretKey

  /// A base58check encoded public key hash for the wallet, prefixed with "tz1" which represents an address in the Tezos
  /// ecosystem.
  public let address: Address

  /// If this wallet was gnerated from a mnemonic, a space delimited string of english mnemonic words
  /// used to generate the wallet with the BIP39 specification, otherwise nil.
  public let mnemonic: String?

  /// Create a new wallet by generating a mnemonic and encrypted with an optional passphrase.
  ///
  ///- Parameter
  ///   - passphrase: An optional passphrase used for encryption.
  ///   - signingCurve: The curve to use. Default is ed25519.
  public init?(passphrase: String = "", signingCurve: EllipticalCurve = .ed25519) {
    guard let mnemonic = MnemonicUtil.generateMnemonic() else {
      return nil
    }
    self.init(mnemonic: mnemonic, passphrase: passphrase, signingCurve: signingCurve)
  }

  /// Create a new wallet with the given mnemonic and encrypted with an optional passphrase.
  ///
  /// - Parameters:
  ///   - mnemonic: A space delimited string of english mnemonic words from the BIP39
  ///   - passphrase: An optional passphrase used for encryption.
  ///   - signingCurve: The curve to use. Default is ed25519.
  public init?(mnemonic: String, passphrase: String = "", signingCurve: EllipticalCurve = .ed25519) {
    guard
      let seedString = MnemonicUtil.seedString(from: mnemonic, passphrase: passphrase),
      let secretKey = SecretKey(seedString: seedString, signingCurve: signingCurve),
      let publicKey = PublicKey(secretKey: secretKey)
    else {
      return nil
    }

    let address = publicKey.publicKeyHash
    self.init(address: address, publicKey: publicKey, secretKey: secretKey, mnemonic: mnemonic)
  }

  /// Create a new fundraiser-style wallet with the given mnemonic and encrypted with an email and password
  ///
  /// - Parameters:
  ///   - email: Email address associated with the wallet, for example: `leko@test.com`
  ///   - password: The password associated with the email address
  ///   - mnemonic: A space delimited string of english mnemonic words from the BIP39
  public init?(email: String, password: String, mnemonic: String, signingCurve: EllipticalCurve = .ed25519) {
    // ref: https://github.com/murbard/pytezos/blob/a228a67fbc94b11dd7dbc7ff0df9e996d0ff5f01/pytezos/crypto.py#L40
    let passphrase = String("\(email)\(password)".utf8).decomposedStringWithCompatibilityMapping
    self.init(mnemonic: mnemonic, passphrase: passphrase, signingCurve: signingCurve)
  }

  /// Create a wallet with a given secret key.
  ///
  /// - Parameter
  ///   - secretKey: A base58check encoded secret key, prefixed with "edsk".
  ///   - signingCurve: The curve to use. Default is ed25519.
  public init?(secretKey secretKeyBase58: String, signingCurve: EllipticalCurve = .ed25519) {
    guard
      let secretKey = SecretKey(secretKeyBase58, signingCurve: signingCurve),
      let publicKey = PublicKey(secretKey: secretKey)
    else {
      return nil
    }

    let address = publicKey.publicKeyHash
    self.init(address: address, publicKey: publicKey, secretKey: secretKey)
  }

  /// Create an ed25519 wallet from a  base58check encoded seed.
  ///
  /// - Parameter seedBase58: A base58check encoded secret key, prefixed with "edsk".
  public init?(seedBase58: String) {
    guard
      let seedBytes = Base58.base58CheckDecodeWithPrefix(string: seedBase58, prefix: Prefix.Keys.Ed25519.seed),
      let keyPair = Sodium.shared.sign.keyPair(seed: seedBytes)
    else {
      return nil
    }

    let secretKeyBase58 = Base58.encode(message: keyPair.secretKey, prefix: Prefix.Keys.Ed25519.secret)
    self.init(secretKey: secretKeyBase58, signingCurve: .ed25519)
  }

  /// Create a wallet with the given address and keys.
  ///
  /// This initializer is particularly useful for creating KT1 wallets.
  ///
  /// - Parameters:
  ///   - address: The address of the originated account.
  ///   - publicKey: The public key.
  ///   - secretKey: The secret key.
  ///   - mnemonic: An optional mnemonic used to generate the wallet.
  private init(address: Address, publicKey: PublicKey, secretKey: SecretKey, mnemonic: String? = nil) {
    JailbreakUtils.crashIfJailbroken()

    self.secretKey = secretKey
    self.publicKey = publicKey
    self.address = address
    self.mnemonic = mnemonic
  }
}

extension Wallet: Equatable {
  public static func == (lhs: Wallet, rhs: Wallet) -> Bool {
    return lhs.publicKey.base58CheckRepresentation == rhs.publicKey.base58CheckRepresentation &&
      lhs.secretKey == rhs.secretKey
  }
}

extension Wallet: SignatureProvider {
  public func sign(_ hex: String) -> [UInt8]? {
    return secretKey.sign(hex: hex)
  }
}
