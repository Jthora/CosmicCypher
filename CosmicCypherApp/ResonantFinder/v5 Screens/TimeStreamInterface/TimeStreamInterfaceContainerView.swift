//
//  TimestreamContainerView.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 9/18/23.
//

import UIKit
import SwiftUI


class TimeStreamInterfaceContainerView: UIView {
    private var contentViewController: UIViewController? {
        willSet {
            contentViewController?.willMove(toParent: nil)
            contentViewController?.view.removeFromSuperview()
            contentViewController?.removeFromParent()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .clear
    }
}
