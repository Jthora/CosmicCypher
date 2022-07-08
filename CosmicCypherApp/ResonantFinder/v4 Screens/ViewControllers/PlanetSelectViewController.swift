//
//  PlanetSelectViewController.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 6/23/22.
//

import Foundation
import UIKit

class PlanetSelectViewController: UIViewController {
    
    static func presentModally(over presentingViewController: UIViewController) {
        guard let vc = UIStoryboard(name: "PlanetSelect", bundle: nil).instantiateViewController(withIdentifier: "PlanetSelectViewController") as? PlanetSelectViewController else {
            return
        }
        presentingViewController.present(vc, animated: true) {
            
        }
    }
    
    @IBOutlet weak var planetCollectionView: UICollectionView!
    @IBOutlet weak var aspectCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        planetCollectionView.delegate = self
        aspectCollectionView.delegate = self
        
        planetCollectionView.dataSource = self
        aspectCollectionView.dataSource = self
        
        planetCollectionView.collectionViewLayout = createGridLayout()
        aspectCollectionView.collectionViewLayout = createGridLayout()
    }
    override func viewWillDisappear(_ animated: Bool) {
        DispatchQueue.main.async {
            ResonanceReportViewController.current?.renderStarChart()
        }
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

extension PlanetSelectViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            print("PlanetCollectionViewCell error: no cell for indexPath.row \(indexPath.row)")
            return
        }
        DispatchQueue.main.async {
            ResonanceReportViewController.current?.update()
        }
    }
}

extension PlanetSelectViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == planetCollectionView {
            return CoreAstrology.AspectBody.NodeType.allCases.count
        } else {
            return CoreAstrology.AspectRelationType.allCases.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == planetCollectionView {
            if let cell: PlanetCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanetCollectionViewCell", for: indexPath) as? PlanetCollectionViewCell {
                cell.planet = CoreAstrology.AspectBody.NodeType.allCases[indexPath.row]
                if let planet = cell.planet {
                    cell.planetSelected = StarChart.Core.selectedNodeTypes.contains(planet)
                    cell.setSelectedState(selected: cell.planetSelected)
                }
                return cell
            } else {
                let cell = PlanetCollectionViewCell()
                cell.planet = CoreAstrology.AspectBody.NodeType.allCases[indexPath.row]
                if let planet = cell.planet {
                    cell.planetSelected = StarChart.Core.selectedNodeTypes.contains(planet)
                    cell.setSelectedState(selected: cell.planetSelected)
                }
                return cell
            }
        } else if collectionView == aspectCollectionView {
            if let cell: AspectCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AspectCollectionViewCell", for: indexPath) as? AspectCollectionViewCell {
                cell.aspectRelationType = CoreAstrology.AspectRelationType.allCases[indexPath.row]
                if let aspectRelationType = cell.aspectRelationType {
                    cell.aspectSelected = StarChart.Core.selectedAspects.contains(aspectRelationType)
                    cell.setSelectedState(selected: cell.aspectSelected)
                }
                return cell
            } else {
                let cell = AspectCollectionViewCell()
                cell.aspectRelationType = CoreAstrology.AspectRelationType.allCases[indexPath.row]
                if let aspectRelationType = cell.aspectRelationType {
                    cell.aspectSelected = StarChart.Core.selectedAspects.contains(aspectRelationType)
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
