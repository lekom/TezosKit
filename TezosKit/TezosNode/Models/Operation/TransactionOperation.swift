// Copyright Keefer Taylor, 2018

import Foundation

/// An operation to transact XTZ between addresses.
public class TransactionOperation: AbstractOperation {
  private enum JSON {
    public enum Keys {
      public static let amount = "amount"
      public static let entrypoint = "entrypoint"
      public static let destination = "destination"
      public static let parameters = "parameters"
      public static let value = "value"
    }
    public enum Values {
      public static let `default` = "default"
    }
  }

  private let amount: Tez
  private let destination: Address
  private let parameter: MichelsonParameter?

  public override var dictionaryRepresentation: [String: Any] {
    var operation = super.dictionaryRepresentation
    operation[TransactionOperation.JSON.Keys.amount] = amount.rpcRepresentation
    operation[TransactionOperation.JSON.Keys.destination] = destination

    if let parameter = self.parameter {
      let parameters: [String: Any] = [
        TransactionOperation.JSON.Keys.entrypoint: TransactionOperation.JSON.Values.default,
        TransactionOperation.JSON.Keys.value: parameter.networkRepresentation
      ]
      operation[TransactionOperation.JSON.Keys.parameters] = parameters
    }

    return operation
  }

  /// - Parameters:
  ///   - amount: The amount of XTZ to transact.
  ///   - parameter: An optional parameter to include in the transaction if the call is being made to a smart contract.
  ///   - from: The address that is sending the XTZ.
  ///   - to: The address that is receiving the XTZ.
  ///   - operationFees: OperationFees for the transaction.
  public init(
    amount: Tez,
    parameter: MichelsonParameter? = nil,
    source: Address,
    destination: Address,
    operationFees: OperationFees
  ) {
    self.amount = amount
    self.destination = destination
    self.parameter = parameter

    super.init(source: source, kind: .transaction, operationFees: operationFees)
  }

  public override func mutableCopy(with zone: NSZone? = nil) -> Any {
    return TransactionOperation(
      amount: amount,
      parameter: parameter,
      source: source,
      destination: destination,
      operationFees: operationFees
    )
  }
}