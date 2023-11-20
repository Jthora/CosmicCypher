//
//  PlanetNodesViewController.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/19/23.
//

import Foundation

import Foundation
import UIKit

// MARK: View Controller
// Planet Nodes View Controller
class PlanetNodesViewController: UIViewController {
    // MARK: Present View
    var selectionContext:PlanetNodesAndAspectsViewController.SelectionContext = .starChart
    var onDismiss:(()->())? = nil
    static func presentModally(over presentingViewController: UIViewController, selectionContext: PlanetNodesAndAspectsViewController.SelectionContext, onDismiss: (()->())? = nil) {
        guard let vc = UIStoryboard(name: "PlanetNodes", bundle: nil).instantiateViewController(withIdentifier: "PlanetNodesViewController") as? PlanetNodesViewController else {
            return
        }
        vc.selectionContext = selectionContext
        vc.onDismiss = onDismiss
        presentingViewController.present(vc, animated: true) {
            
        }
    }
    
    // MARK: Outlets
    // Collection Views
    @IBOutlet weak var planetCollectionView: UICollectionView!
    
    
    // MARK: Properties
    // PlanetNodes
    var initialSelectedNodeTypes: [CoreAstrology.AspectBody.NodeType] = []
    
    // MARK: View Life Cycle
    // View Did Load
    override func viewDidLoad() {
        planetCollectionView.delegate = self
        
        planetCollectionView.dataSource = self
        
        planetCollectionView.collectionViewLayout = createGridLayout()
        
        switch selectionContext {
        case .starChart:
            initialSelectedNodeTypes = StarChart.Core.selectedNodeTypes
        case .aspectScanner:
            initialSelectedNodeTypes = AspectEventScanner.Core.planetsAndNodes
        }
    }
    
    // View Will Disappear
    override func viewWillDisappear(_ animated: Bool) {
        switch selectionContext {
        case .starChart:
            DispatchQueue.main.async {
                ResonanceReportViewController.current?.renderStarChart()
            }
        case .aspectScanner:
            if initialSelectedNodeTypes != AspectEventScanner.Core.planetsAndNodes {
                DispatchQueue.main.async {
                    AspectEventScanner.Core.console.updatedPlanetsAndNodes()
                }
            }
        }
        onDismiss?()
    }
    
    // View Did Disappear
    override func viewDidDisappear(_ animated: Bool) {
        DispatchQueue.main.async {
            ResonanceReportViewController.current?.update()
        }
    }
    
    func createGridLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                             heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

// UICollectionViewDelegate
extension PlanetNodesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            print("PlanetCollectionViewCell error: no cell for indexPath.row \(indexPath.row)")
            return
        }
        switch selectionContext {
        case .starChart:
            DispatchQueue.main.async {
                ResonanceReportViewController.current?.update()
            }
        case .aspectScanner: ()
        }
    }
}

// UICollectionViewDataSource
extension PlanetNodesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == planetCollectionView {
            return CoreAstrology.AspectBody.NodeType.allCases.count
        } else {
            return CoreAstrology.AspectRelationType.allCases.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == planetCollectionView {
            if let cell: PlanetNodeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanetNodeCollectionViewCell", for: indexPath) as? PlanetNodeCollectionViewCell {
                cell.selectionContext = selectionContext
                cell.planet = CoreAstrology.AspectBody.NodeType.allCases[indexPath.row]
                if let planet = cell.planet {
                    switch selectionContext {
                    case .starChart:
                        cell.planetSelected = StarChart.Core.selectedNodeTypes.contains(planet)
                    case .aspectScanner:
                        cell.planetSelected = AspectEventScanner.Core.planetsAndNodes.contains(planet)
                    }
                    cell.setSelectedState(selected: cell.planetSelected)
                }
                return cell
            } else {
                let cell = PlanetNodeCollectionViewCell()
                cell.selectionContext = selectionContext
                cell.planet = CoreAstrology.AspectBody.NodeType.allCases[indexPath.row]
                if let planet = cell.planet {
                    switch selectionContext {
                    case .starChart:
                        cell.planetSelected = StarChart.Core.selectedNodeTypes.contains(planet)
                    case .aspectScanner:
                        cell.planetSelected = AspectEventScanner.Core.planetsAndNodes.contains(planet)
                    }
                    cell.setSelectedState(selected: cell.planetSelected)
                }
                return cell
            }
        } else {
            let cell = UICollectionViewCell()
            return cell
        }
    }
}
