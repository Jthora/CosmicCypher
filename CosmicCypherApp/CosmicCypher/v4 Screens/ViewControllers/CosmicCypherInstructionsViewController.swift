//
//  CosmicCypherInstructionsViewController.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 6/21/22.
//

import UIKit
import WebKit



class CosmicCypherInstructionsViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var backButton: UIButton!
    
    
    static func presentModally(over presentingViewController: UIViewController) {
        guard let vc = UIStoryboard(name: "Instructions", bundle: nil).instantiateViewController(withIdentifier: "CosmicCypherInstructionsViewController") as? CosmicCypherInstructionsViewController else {
            return
        }
        presentingViewController.present(vc, animated: true) {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollView.setZoomScale(2, animated: false)
        centerContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        autoZoomAnimation()
    }
    
    func autoZoomAnimation() {
        let newContentOffsetX: CGFloat = (scrollView.contentSize.width - scrollView.frame.size.width) / 2
        let newContentOffsetY: CGFloat = (scrollView.contentSize.height - scrollView.frame.size.height) / 2
        UIView.animate(withDuration: 1, delay: 0) {
            self.scrollView.contentOffset = CGPoint(x: newContentOffsetX, y: newContentOffsetY)
            self.scrollView.zoomScale = 1
        }
    }
    
    func centerContent(animated: Bool = false) {
        let newContentOffsetX: CGFloat = (scrollView.contentSize.width - scrollView.frame.size.width) / 2
        let newContentOffsetY: CGFloat = (scrollView.contentSize.height - scrollView.frame.size.height) / 2
        self.scrollView.setContentOffset(CGPoint(x: newContentOffsetX, y: newContentOffsetY), animated: animated)
    }
    
    @IBAction func backButtonClick(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    
}
    
extension CosmicCypherInstructionsViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
      }
    func updateMinZoomScaleForSize(_ size: CGSize) {
      let widthScale = size.width / imageView.bounds.width
      let heightScale = size.height / imageView.bounds.height
      let minScale = min(widthScale, heightScale)
        
      scrollView.minimumZoomScale = minScale
      scrollView.zoomScale = minScale
    }
    override func viewWillLayoutSubviews() {
      super.viewWillLayoutSubviews()
      updateMinZoomScaleForSize(view.bounds.size)
    }
    
}
