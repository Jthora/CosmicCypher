//
//  StarKitImage.swift
//  StarKit
//
//  Created by Jordan Trana on 1/19/22.
//

import Foundation

#if os(OSX)
    import AppKit
    public typealias StarKitImage=NSImage
#else
    import UIKit
    public typealias StarKitImage=UIImage
#endif
