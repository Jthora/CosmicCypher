//
//  TimeStreamSettingsViewController+TableView.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 9/20/23.
//

import Foundation




//        if tableView == timeStreamTableView {
//            /// Update Data Model
//            ///
//            /// Reference TimeStreamCore for Centralized Data Model - single source of truth
////            let mover = currentTimeStreams.remove(at: sourceIndexPath.row)
////            currentTimeStreams.insert(mover, at: destinationIndexPath.row)
//        }
//    }
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
//}


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
