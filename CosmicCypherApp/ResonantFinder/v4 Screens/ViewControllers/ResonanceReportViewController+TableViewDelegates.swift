//
//  ResonanceReportViewController+TableViewDelegates.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 8/5/22.
//

import UIKit

// MARK: UITableView Delegate and DataSource
extension ResonanceReportViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == aspectsResultsTableView {
            return StarChart.Core.current.sortedAspects(selectedNodeTypes: StarChart.Core.selectedNodeTypes,
                                                       selectedAspects: StarChart.Core.selectedAspects).count
//        } else if tableView == self.timeStreamTableView {
//            return TimeStream.Core.compositeCount + 1 //currentComposites.count + 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == aspectsResultsTableView {
            guard let cell = aspectsResultsTableView.dequeueReusableCell(withIdentifier: "ResonanceReportTableViewCell") as? ResonanceReportTableViewCell else { return UITableViewCell() }
            
            let aspects = StarChart.Core.sortedAspects
            guard indexPath.row < aspects.count else {return UITableViewCell()}
            let aspect = aspects[indexPath.row]
            guard let pLong = StarChart.Core.current.planetNodes[aspect.primaryBody.type]?.longitude,
                  let sLong = StarChart.Core.current.planetNodes[aspect.secondaryBody.type]?.longitude else { return cell }
            
            cell.setup(with: aspect, primaryBodyLongitude: pLong, secondaryBodyLongitude: sLong)
            
            return cell
            
//        } else if tableView == timeStreamTableView {
//            // Add New Cell
//            if indexPath.row >= TimeStream.Core.compositeCount {
//                guard let cell = timeStreamTableView.dequeueReusableCell(withIdentifier: "TimeStreamAddNewCompositeTableViewCell") as? TimeStreamAddNewCompositeTableViewCell else {
//                    let cell = TimeStreamAddNewCompositeTableViewCell()
//                    return cell
//                }
//                return cell
//            }
//
//            // Existing TimeStream Cell
//            guard let cell = timeStreamTableView.dequeueReusableCell(withIdentifier: "TimeStreamCompositeTableViewCell") as? TimeStreamCompositeTableViewCell else {
//                let cell = TimeStreamCompositeTableViewCell()
//
//                cell.timeStreamComposite = TimeStream.Core.composite(for: indexPath)
//                cell.uuid = TimeStream.Core.compositeUUID(for: indexPath)
//                cell.update()
//
//                return cell
//            }
//
//            cell.timeStreamComposite = TimeStream.Core.composite(for: indexPath)
//            cell.uuid = TimeStream.Core.compositeUUID(for: indexPath)
//            cell.update()
//            /// Setup TimeStream Visualization
//            /// Composites
//            /// SpriteNodes
//
//            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if tableView == timeStreamTableView {
//            if indexPath.row >= TimeStream.Core.compositeCount {
//                // Add New Timestream
//                TimeStreamSelectViewController.presentModally(over: self)
//                return
//            } else if let cell = tableView.cellForRow(at: indexPath) as? TimeStreamCompositeTableViewCell,
//                      let planets = cell.timeStreamComposite?.configuration.nodeTypes {
//                DispatchQueue.main.async {
//                    StarChart.Core.selectedNodeTypes = planets
//                    let point = cell.currentPoint
//                    StarChart.Core.current = StarChartRegistry.main.getStarChart(point: point!)
//                    ResonanceReportViewController.current?.update()
//                    self.update()
//                }
//            }
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if tableView == timeStreamTableView {
//            if indexPath.row >= TimeStream.Core.compositeCount {
//                return 2*tableView.frame.size.height/3
//            }
//            return tableView.frame.size.height
//        } else
        if tableView == aspectsResultsTableView {
            return tableView.contentSize.width
        } else {
            return tableView.rowHeight
        }
    }
    
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        if tableView == timeStreamTableView {
//            /// Update Data Model
//            ///
//            /// Reference TimeStreamCore for Centralized Data Model - single source of truth
////            let mover = currentTimeStreams.remove(at: sourceIndexPath.row)
////            currentTimeStreams.insert(mover, at: destinationIndexPath.row)
//        }
    }
//
//    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        if tableView == timeStreamTableView { // TimeStream Composite
//            /// TimeStream Composite Cell
//            let contextItemEdit = UIContextualAction(style: .normal, title: " Edit \n🛠 ") {  (contextualAction, view, boolValue) in
//                /// Duplicate TimeStream Composite
//                TimeStreamSettingsViewController.presentModally(over: self)
//
//                // TODO: Pre-Focus on Edited TimeStream Composite
//            }
//            let contextItemDelete = UIContextualAction(style: .destructive, title: " Delete \n✖️ ") {  (contextualAction, view, boolValue) in
//                /// Delete TimeStream Composite
//                //TimeStreamCore.deleteTimeStreamComposite()
//                guard let cell = tableView.cellForRow(at: indexPath) as? TimeStreamCompositeTableViewCell,
//                      let composite = cell.timeStreamComposite else {
//                    print("ERROR: missing composite for delete swipe action")
//                    return
//                }
//                TimeStream.Core.delete(timeStreamComposite: composite)
//                DispatchQueue.main.async {
//                    ResonanceReportViewController.current?.timeStreamTableView.reloadData()
//                }
//            }
//            return UISwipeActionsConfiguration(actions: [contextItemEdit, contextItemDelete])
//        } else {
//            return UISwipeActionsConfiguration(actions: [])
//        }
//    }

//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        if tableView == timeStreamTableView {
//            /// TimeStream Composite Cell
//            let contextItemDelete = UIContextualAction(style: .destructive, title: " Delete \n✖️ ") {  (contextualAction, view, boolValue) in
//                /// Delete TimeStream Composite
//                //TimeStreamCore.deleteTimeStreamComposite()
//                guard let cell = tableView.cellForRow(at: indexPath) as? TimeStreamCompositeTableViewCell,
//                      let composite = cell.timeStreamComposite else {
//                    print("ERROR: missing composite for delete swipe action")
//                    return
//                }
//
//                TimeStream.Core.delete(timeStreamComposite: composite)
//            }
//            return UISwipeActionsConfiguration(actions: [contextItemDelete])
//        } else {
//            return UISwipeActionsConfiguration(actions: [])
//        }
//    }

}


// TODO: Drag and Drop Support

// will require timeStreamAddNewCompositeRow reference

//// MARK: DRAG
//extension ResonanceReportViewController: UITableViewDragDelegate {
//    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        if tableView == timeStreamTableView {
//
//            if indexPath.row == timeStreamAddNewCompositeRow {
//                // ADD
//                return []
//            } else {
//                // DRAG
//                let hashString:String = TimeStream.Core.currentComposites[indexPath.row].hashKey
//                guard let data = hashString.data(using: .utf8) else { return [] }
//                let itemProvider = NSItemProvider(item: data as NSData, typeIdentifier: "app.cosmiccypher.timestreamcomposite")
//                let dragItem = UIDragItem(itemProvider: itemProvider)
//                //dragItem.localObject = data[indexPath.row] // TimeStream
//                return [ dragItem ]
//            }
//        } else if tableView == timeStreamConfigurationTableView {
//            if indexPath.row == timeStreamAddNewRow {
//                // ADD
//                return []
//            } else {
//                // DRAG
//                let string = "timestream x"//currentTimeStreams[indexPath.row]
//                guard let data = string.data(using: .utf8) else { return [] }
//                let itemProvider = NSItemProvider(item: data as NSData, typeIdentifier: "app.cosmiccypher.timestream")
//                let dragItem = UIDragItem(itemProvider: itemProvider)
//                //dragItem.localObject = data[indexPath.row] // TimeStream
//                return [ dragItem ]
//            }
//        } else {
//            return []
//        }
//    }
//
//
//}
//
//// MARK: DROP
//extension TimeStreamSettingsViewController: UITableViewDropDelegate {
//    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
//
//        let destinationIndexPath: IndexPath
//
//        if tableView == timeStreamCompositeTableView {
//
//            if let indexPath = coordinator.destinationIndexPath {
//                destinationIndexPath = indexPath
//            } else {
//                let section = tableView.numberOfSections - 1
//                let row = tableView.numberOfRows(inSection: section)
//                destinationIndexPath = IndexPath(row: row, section: section)
//            }
//
////            guard timeStreamAddNewCompositeRow != destinationIndexPath.row else {
////                return
////            }
//
//            // attempt to load strings from the drop coordinator
//            coordinator.session.loadObjects(ofClass: NSString.self) { items in
//                // convert the item provider array to a string array or bail out
//                guard let strings = items as? [String] else { return }
//
//                // create an empty array to track rows we've copied
//                var indexPaths = [IndexPath]()
//
//                // loop over all the strings we received
//                for (index, string) in strings.enumerated() {
//                    // create an index path for this new row, moving it down depending on how many we've already inserted
//                    let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
//
//                    // insert the copy into the correct array
////                    TimeStreamCompositeRegistry.main.hashList.insert(string, at: indexPath.row)
////                    TimeStream.Core.currentComposites[indexPath.row].hashKey
//
//                    // keep track of this new row
//                    indexPaths.append(indexPath)
//                }
//
//                // insert them all into the table view at once
//                tableView.insertRows(at: indexPaths, with: .automatic)
//            }
//        } else if tableView == timeStreamConfigurationTableView {
//
//            if let indexPath = coordinator.destinationIndexPath {
//                destinationIndexPath = indexPath
//            } else {
//                let section = tableView.numberOfSections - 1
//                let row = tableView.numberOfRows(inSection: section)
//                destinationIndexPath = IndexPath(row: row, section: section)
//            }
//
////            guard timeStreamAddNewRow != destinationIndexPath.row else {
////                return
////            }
//
//            // attempt to load strings from the drop coordinator
//            coordinator.session.loadObjects(ofClass: NSString.self) { items in
//                // convert the item provider array to a string array or bail out
//                guard let strings = items as? [String] else { return }
//
//                // create an empty array to track rows we've copied
//                var indexPaths = [IndexPath]()
//
//                // loop over all the strings we received
//                for (index, string) in strings.enumerated() {
//                    // create an index path for this new row, moving it down depending on how many we've already inserted
//                    let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
//
//                    // insert the copy into the correct array
////                    self.currentTimeStreams.insert(string, at: indexPath.row)
//
//                    // keep track of this new row
//                    indexPaths.append(indexPath)
//                }
//
//                // insert them all into the table view at once
//                tableView.insertRows(at: indexPaths, with: .automatic)
//            }
//        } else {
//        }
//    }
//
//}
