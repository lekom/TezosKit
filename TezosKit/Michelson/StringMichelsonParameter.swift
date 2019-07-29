// Copyright Keefer Taylor, 2019.

import Foundation

/// A representation of a string parameter in Michelson.
public class StringMichelsonParameter: AbstractMichelsonParameter {
  public init(string: String) {
    super.init(networkRepresentation: [MichelineConstants.string: string])
  }
}
