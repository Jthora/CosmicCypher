//
//  TimestreamInterface.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 9/18/23.
//

import SwiftUI
import UIKit

struct TimestreamInterface: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct TimestreamInterface_Previews: PreviewProvider {
    static var previews: some View {
        TimestreamInterface()
    }
}

@available(iOS 14.0, *)
struct SwiftUIWrapper<Content: View>: UIViewRepresentable {
    let content: Content
    let backgroundColor: UIColor?
    
    init(_ content: Content, backgroundColor: UIColor? = nil) {
        self.content = content
        self.backgroundColor = backgroundColor
    }
    
    func makeUIView(context: Context) -> UIView {
        let hostingController = UIHostingController(rootView: content)
        if let backgroundColor = backgroundColor {
            hostingController.view.backgroundColor = backgroundColor
        }
        return hostingController.view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Update any properties here if needed
    }
}
