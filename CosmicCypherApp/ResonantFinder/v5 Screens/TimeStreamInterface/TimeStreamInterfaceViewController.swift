//
//  TimeStreamInterfaceViewController.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 9/18/23.
//

import SwiftUI
import UIKit

class TimeStreamInterfaceViewController: UIViewController {
    
    
    // Playback Buttons
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var skipForwardButton: UIButton!
    @IBOutlet weak var skipBackwardButton: UIButton!
    @IBOutlet weak var playForwardButton: UIButton!
    @IBOutlet weak var playBackwardButton: UIButton!
    @IBOutlet weak var fastForwardButton: UIButton!
    @IBOutlet weak var fastBackwardButton: UIButton!
    
    @IBOutlet weak var timeStreamProgressBar: UIProgressView!
    @IBOutlet weak var timeStreamHorizontalSlider: UISlider!
    
    @IBOutlet weak var imageMapView: UIImageView!
    
    
    // Global Instance
    static var global:TimeStreamInterfaceViewController? = {
        guard let viewController = UIStoryboard(name: "TimeStreamInterface", bundle: nil).instantiateViewController(withIdentifier: "TimeStreamInterfaceViewController") as? TimeStreamInterfaceViewController else {
            return nil
        }
        return viewController
    }()
    
    // Present the TimeStreamInterfaceViewController from a view controller
    static func present(from parentViewController: UIViewController? = nil) {
        guard let viewController = global else {return}
        if let presentingViewController = parentViewController ?? UIApplication.shared.keyWindow?.rootViewController {
            presentingViewController.present(viewController, animated: true, completion: nil)
        }
    }
    
    // Present the TimeStreamInterfaceViewController within a container view
    static func present(in containerView: UIView) {
        guard let viewController = global else {return}
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupUI()
    }

    private func setupUI() {
        // Create SwiftUI content
        let swiftUIContent = AnyView(
            VStack {
                Text("Hello, World!")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                Button(action: {
                    // Handle button tap
                }) {
                    Text("Tap Me")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
        )

        // Create a UIHostingController to host the SwiftUI content
        let hostingController = UIHostingController(rootView: swiftUIContent)
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        hostingController.didMove(toParent: self)
    }
}
