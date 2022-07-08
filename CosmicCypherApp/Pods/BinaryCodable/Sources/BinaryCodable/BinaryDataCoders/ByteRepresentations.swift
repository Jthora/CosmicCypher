// Copyright 2019-present the BinaryCodable authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation

extension FixedWidthInteger {
  /**
   Returns a byte array representation of a fixed-width integer in little endian format.
   */
  public var bytes: [UInt8] {
    let bitWidth = type(of: self).bitWidth
    return stride(from: 0, to: bitWidth, by: 8).map { UInt8((self >> $0) & 0xFF) }
  }
}

extension BinaryFloatingPoint {
  /**
   Returns a byte array representation of a floating point number.
   */
  public var bytes: [UInt8] {
    return [UInt8](withUnsafeBytes(of: self) { Data($0) })
  }
}
