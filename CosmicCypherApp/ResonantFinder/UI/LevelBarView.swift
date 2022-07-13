//
//  LevelBarView.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 7/12/22.
//

import UIKit

class LevelBarView: UIView {
    
    enum SideAlignment {
        case left
        case right
    }

    @IBInspectable var progress: Float = 0 {
        didSet {
            updateProgressView()
        }
    }
    
    func setProgress(_ progress: Float, animated: Bool? = false) {
        self.progress = progress
    }

    private let progressView = UIView()
    private var progressViewWidthConstraint: NSLayoutConstraint?
    var sideAlignment:SideAlignment

    init(frame: CGRect, sideAlignment:SideAlignment) {
        self.sideAlignment = sideAlignment
        super.init(frame: frame)

        clipsToBounds = true
        backgroundColor = .lightGray

        addSubview(progressView)

        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        progressView.borderWidth = 1
        progressView.borderColor = .black
        
        switch sideAlignment {
        case .left:
            progressView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        case .right:
            progressView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        }
        
        progressView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        progressViewWidthConstraint = progressView.widthAnchor.constraint(equalToConstant: 140)
        progressViewWidthConstraint?.isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        updateProgressView()
    }
    
    func setBarColor(uiColor: UIColor) {
        progressView.backgroundColor = uiColor
    }

    func updateProgressView() {
        let isCompleted = progress >= 1.0

        self.backgroundColor = .clear
        progressViewWidthConstraint?.constant = bounds.width * CGFloat(progress)
    }
}
