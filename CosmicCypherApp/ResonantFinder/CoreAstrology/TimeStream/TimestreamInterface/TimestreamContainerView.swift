//
//  TimestreamContainerView.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 9/18/23.
//

import UIKit
import SwiftUI


class TimestreamContainerView: UIView {
    private var swiftUIView: UIView?

    var content: AnyView? {
        didSet {
            // Remove any existing SwiftUI content
            swiftUIView?.removeFromSuperview()

            if let content = content {
                // Create a UIHostingController to host the SwiftUI view
                let hostingController = UIHostingController(rootView: content)
                addSubview(hostingController.view)
                hostingController.view.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    hostingController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
                    hostingController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
                    hostingController.view.topAnchor.constraint(equalTo: topAnchor),
                    hostingController.view.bottomAnchor.constraint(equalTo: bottomAnchor),
                ])

                swiftUIView = hostingController.view
            } else {
                swiftUIView = nil
            }
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
