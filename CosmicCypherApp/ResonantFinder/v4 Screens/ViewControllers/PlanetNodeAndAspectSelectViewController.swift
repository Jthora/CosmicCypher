//
//  PlanetNodeAndAspectSelectViewController.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 6/23/22.
//

import Foundation
import UIKit

class PlanetNodeAndAspectSelectViewController: UIViewController {
    
    var selectionContext:SelectionContext = .starChart
    var onDismiss:(()->())? = nil
    static func presentModally(over presentingViewController: UIViewController, selectionContext: SelectionContext, onDismiss: (()->())? = nil) {
        guard let vc = UIStoryboard(name: "PlanetNodeAndAspectSelect", bundle: nil).instantiateViewController(withIdentifier: "PlanetNodeAndAspectSelectViewController") as? PlanetNodeAndAspectSelectViewController else {
            return
        }
        vc.selectionContext = selectionContext
        vc.onDismiss = onDismiss
        presentingViewController.present(vc, animated: true) {
            
        }
    }
    
    @IBOutlet weak var planetCollectionView: UICollectionView!
    @IBOutlet weak var aspectCollectionView: UICollectionView!
    
    var initialSelectedAspectAngles: [CoreAstrology.AspectRelationType] = []
    var initialSelectedNodeTypes: [CoreAstrology.AspectBody.NodeType] = []
    
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
    
    override func viewDidDisappear(_ animated: Bool) {
        DispatchQueue.main.async {
            ResonanceReportViewController.current?.update()
        }
    }
    
    func createGridLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                             heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalWidth(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension PlanetNodeAndAspectSelectViewController: UICollectionViewDelegate {
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

extension PlanetNodeAndAspectSelectViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == planetCollectionView {
            return CoreAstrology.AspectBody.NodeType.allCases.count
        } else {
            return CoreAstrology.AspectRelationType.allCases.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == planetCollectionView {
            if let cell: PlanetNodeSelectCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanetNodeSelectCollectionViewCell", for: indexPath) as? PlanetNodeSelectCollectionViewCell {
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
                let cell = PlanetNodeSelectCollectionViewCell()
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
            if let cell: AspectSelectCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AspectSelectCollectionViewCell", for: indexPath) as? AspectSelectCollectionViewCell {
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
                let cell = AspectSelectCollectionViewCell()
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


extension PlanetNodeAndAspectSelectViewController {
    enum SelectionContext {
        case starChart
        case scanner
    }
}
