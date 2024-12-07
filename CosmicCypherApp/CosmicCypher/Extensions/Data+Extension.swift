//
//  Data+Extension.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 6/9/22.
//

import Foundation
//import BinaryCodable


// https://gist.github.com/tannernelson/73d0923efdee50e6c38f

extension Data {
    var uint8: UInt8 {
        get {
            var number: UInt8 = 0
            self.copyBytes(to: &number, count: MemoryLayout<UInt8>.size)
            return number
        }
    }
}

//extension Data {
//    var uint16: UInt16 {
//        get {
//            var number: UInt16 = 0
//            self.copyBytes(to: &number, count: MemoryLayout<UInt16>.size)
//            return number
//        }
//    }
//}
//
//extension Data {
//    var uint32: UInt32 {
//        get {
//            var number: UInt32 = 0
//            self.copyBytes
//            self.copyBytes(to: &number, count: MemoryLayout<UInt32>.size)
//            return number
//        }
//    }
//}
//
//extension Data {
//    var uuid: NSUUID? {
//        get {
//            var bytes = [UInt8](count: self.count, repeatedValue: 0)
//            self.copyBytes(to: &bytes, count: self.count * MemoryLayout<UInt8>.size)
//            return NSUUID(UUIDBytes: bytes)
//        }
//    }
//}

extension Data {
    var stringASCII: String? {
        get {
            return NSString(data: self, encoding: String.Encoding.ascii.rawValue) as String?
        }
    }
}

extension Data {
    var stringUTF8: String? {
        get {
            return NSString(data: self, encoding: String.Encoding.utf8.rawValue) as String?
        }
    }
}

extension Int {
    var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<Int>.size)
    }
}

extension UInt8 {
    var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<UInt8>.size)
    }
}

extension UInt16 {
    var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<UInt16>.size)
    }
}

extension UInt32 {
    var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<UInt32>.size)
    }
}
//
//extension NSUUID {
//    var data: Data {
//        var uuid = [UInt8](count: 16, repeatedValue: 0)
//        self.getUUIDBytes(&uuid)
//        return Data(bytes: &uuid, length: 16)
//    }
//}

extension String {
    var dataUTF8: Data? {
        return self.data(using: String.Encoding.utf8)
    }
}

extension NSString {
    var dataASCII: Data? {
        return self.data(using: String.Encoding.ascii.rawValue)
    }
}
