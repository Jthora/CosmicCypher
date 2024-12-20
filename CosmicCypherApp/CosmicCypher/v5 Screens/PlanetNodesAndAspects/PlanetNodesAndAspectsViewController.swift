//
//  PlanetNodesAndAspectsViewController.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/19/23.
//

import Foundation
import UIKit

class PlanetNodesAndAspectsViewController: UIViewController {
    
    // MARK: Present View
    var selectionContext:SelectionContext = .starChart
    var onDismiss:(()->())? = nil
    static func presentModally(over presentingViewController: UIViewController, selectionContext: SelectionContext, onDismiss: (()->())? = nil) {
        guard let vc = UIStoryboard(name: "PlanetNodesAndAspects", bundle: nil).instantiateViewController(withIdentifier: "PlanetNodesAndAspectsViewController") as? PlanetNodesAndAspectsViewController else {
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
    @IBOutlet weak var aspectCollectionView: UICollectionView!
    
    // MARK: Properties
    // PlanetNodes and Aspects
    var initialSelectedAspectAngles: [CoreAstrology.AspectRelationType] = []
    var initialSelectedNodeTypes: [CoreAstrology.AspectBody.NodeType] = []
    
    // MARK: View Life Cycle
    // View Did Load
    override func viewDidLoad() {
        planetCollectionView.delegate = self
        aspectCollectionView.delegate = self
        
        planetCollectionView.dataSource = self
        aspectCollectionView.dataSource = self
        
        planetCollectionView.collectionViewLayout = createGridLayout()
        aspectCollectionView.collectionViewLayout = createGridLayout()
        
        switch selectionContext {
        case .starChart:
            initialSelectedAspectAngles = StarChart.Core.selectedAspects
            initialSelectedNodeTypes = StarChart.Core.selectedNodeTypes
        case .scanner:
            initialSelectedAspectAngles = CelestialEventScanner.Core.aspectAngles
            initialSelectedNodeTypes = CelestialEventScanner.Core.planetsAndNodes
        }
    }
    
    // View Will Disappear
    override func viewWillDisappear(_ animated: Bool) {
        switch selectionContext {
        case .starChart:
            DispatchQueue.main.async {
                ResonanceReportViewController.current?.renderStarChart()
            }
        case .scanner:
            if initialSelectedAspectAngles != CelestialEventScanner.Core.aspectAngles {
                DispatchQueue.main.async {
                    CelestialEventScanner.Core.console.updatedAspectAngles()
                }
            }
            if initialSelectedNodeTypes != CelestialEventScanner.Core.planetsAndNodes {
                DispatchQueue.main.async {
                    CelestialEventScanner.Core.console.updatedPlanetsAndNodes()
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
extension PlanetNodesAndAspectsViewController: UICollectionViewDelegate {
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
        case .scanner: ()
        }
    }
}

// UICollectionViewDataSource
extension PlanetNodesAndAspectsViewController: UICollectionViewDataSource {
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
                    case .scanner:
                        cell.planetSelected = CelestialEventScanner.Core.planetsAndNodes.contains(planet)
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
                    case .scanner:
                        cell.planetSelected = CelestialEventScanner.Core.planetsAndNodes.contains(planet)
                    }
                    cell.setSelectedState(selected: cell.planetSelected)
                }
                return cell
            }
        } else if collectionView == aspectCollectionView {
            if let cell: AspectCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AspectCollectionViewCell", for: indexPath) as? AspectCollectionViewCell {
                cell.selectionContext = selectionContext
                cell.aspectRelationType = CoreAstrology.AspectRelationType.allCases[indexPath.row]
                if let aspectRelationType = cell.aspectRelationType {
                    switch selectionContext {
                    case .starChart:
                        cell.aspectSelected = StarChart.Core.selectedAspects.contains(aspectRelationType)
                    case .scanner:
                        cell.aspectSelected = CelestialEventScanner.Core.aspectAngles.contains(aspectRelationType)
                    }
                    cell.setSelectedState(selected: cell.aspectSelected)
                }
                return cell
            } else {
                let cell = AspectCollectionViewCell()
                cell.selectionContext = selectionContext
                cell.aspectRelationType = CoreAstrology.AspectRelationType.allCases[indexPath.row]
                if let aspectRelationType = cell.aspectRelationType {
                    switch selectionContext {
                    case .starChart:
                        cell.aspectSelected = StarChart.Core.selectedAspects.contains(aspectRelationType)
                    case .scanner:
                        cell.aspectSelected = CelestialEventScanner.Core.aspectAngles.contains(aspectRelationType)
                    }
                    cell.setSelectedState(selected: cell.aspectSelected)
                }
                return cell
            }
        } else {
            let cell = UICollectionViewCell()
            return cell
        }
    }
}

// MARK: Selection Context
// Selection Context
extension PlanetNodesAndAspectsViewController {
    enum SelectionContext {
        case starChart
        case scanner
    }
}
