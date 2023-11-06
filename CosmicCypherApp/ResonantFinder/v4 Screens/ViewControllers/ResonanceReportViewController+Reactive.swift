//
//  ResonanceReportViewController+Reactive.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 8/5/22.
//

import UIKit


extension ResonanceReportViewController: TimeStreamCoreReactive {
    func timeStreamCore(didAction action: TimeStream.Core.Action) {
        switch action {
        case .update(let updateAction):
            switch updateAction {
            case .composites:
                DispatchQueue.main.async {
//                    self.timeStreamTableView.reloadData()
//                    self.loadingTimeStreamsSpinner.stopAnimating()
                }
            default: ()
            }
        case .onLoadTimeStream(loadTimeStreamAction: let loadTimeStreamAction):
            switch loadTimeStreamAction {
                
            case .progress(completion: let completion):
                break
            case .complete:
                break
            case .start(uuid: let uuid, name: let name, configuration: let configuration):
//                self.timeStreamTableView.reloadData()
//                self.loadingTimeStreamsSpinner.startAnimating()
                break
            }
        }
    }
}

extension ResonanceReportViewController: StarChartCoreReactive {
    func starChartCore(didAction action: StarChart.Core.Action) {
        switch action {
        case .renderStart:
            DispatchQueue.main.async {
                //print("renderStart")
                self.renderingProgressBar.isHidden = false
                self.renderingProgressSpinner.isHidden = false
                self.renderingProgressLabel.isHidden = false
                self.renderingProgressAnimation.isHidden = false
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                    self.renderingProgressBar.alpha = 1
                    self.renderingProgressSpinner.alpha = 1
                    self.renderingProgressLabel.alpha = 1
                    self.renderingProgressAnimation.alpha = 1
                } completion: { _ in
                }
            }
            break
        case .renderProgress(let percentageCompleted):
            DispatchQueue.main.async {
                //print("renderProgress")
                self.renderingProgressBar.progress = percentageCompleted
            }
        case .renderComplete(let spriteNode):
            DispatchQueue.main.async {
                //print("renderComplete")
                
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                    self.renderingProgressBar.alpha = 0
                    self.renderingProgressSpinner.alpha = 0
                    self.renderingProgressLabel.alpha = 0
                    self.renderingProgressAnimation.alpha = 0
                } completion: { _ in
                    self.renderingProgressBar.isHidden = true
                    self.renderingProgressSpinner.isHidden = true
                    self.renderingProgressLabel.isHidden = true
                    self.renderingProgressAnimation.isHidden = true
                }
                
                self.scene.backgroundColor = .black
                self.scene.removeAllChildren()
                self.scene.addChild(spriteNode)
                self.spriteKitView.presentScene(self.scene)
                
                self.update()
            }
        case .renderStop:
            DispatchQueue.main.async {
                //print("renderStop")
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                    self.renderingProgressBar.alpha = 0
                    self.renderingProgressSpinner.alpha = 0
                    self.renderingProgressLabel.alpha = 0
                    self.renderingProgressAnimation.alpha = 0
                } completion: { _ in
                    self.renderingProgressBar.isHidden = true
                    self.renderingProgressSpinner.isHidden = true
                    self.renderingProgressLabel.isHidden = true
                    self.renderingProgressAnimation.isHidden = true
                }
            }
        }
    }
}
