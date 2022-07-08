//
//  TimeStreamSettingsViewController.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 6/2/22.
//

import Foundation
import UIKit
import UniformTypeIdentifiers

class TimeStreamSettingsViewController: UIViewController, TimeStreamCoreReactive {
    
    
    func timeStreamCore(didAction action: TimeStream.Core.Action) {
        switch action {
        case .update(let updateAction):
            switch updateAction {
            case .composites:
                DispatchQueue.main.async { [weak self] in
                    self?.timeStreamCompositeTableView.reloadData()
                }
            }
        case .onLoadTimeStream(loadTimeStreamAction: let loadTimeStreamAction):
            switch loadTimeStreamAction {
            case .progress(completion: let completion):
                print("onLoadTimeStream progress: \(completion)")
            case .complete:
                print("onLoadTimeStream complete")
            case .start(uuid: _, name: let name, configuration: _):
                print("onLoadTimeStream start [\(name)]")
            }
        }
    }
    
    
    static func presentModally(over presentingViewController: UIViewController) {
        guard let vc = UIStoryboard(name: "v4", bundle: nil).instantiateViewController(withIdentifier: "TimeStreamSettingsViewController") as? TimeStreamSettingsViewController else {
            return
        }
        presentingViewController.present(vc, animated: true) {
            //vc.delegate = delegate
        }
        
    }
    
    @IBOutlet weak var timeStreamCompositeTableView: UITableView!
    @IBOutlet weak var timeStreamConfigurationTableView: UITableView!
    
    // Add New TimeStream Composite Row
    var addNewTimeStreamCompositeCustomRow: Int? = nil
    var timeStreamAddNewCompositeRow: Int {
        return addNewTimeStreamCompositeCustomRow ?? TimeStream.Core.currentComposites.count-1
    }
    
    // Add New TimeStream Row
    var addNewTimeStreamCustomRow: Int? = nil
    var timeStreamAddNewRow: Int {
        return addNewTimeStreamCustomRow ?? TimeStream.Core.currentComposites.count-1
    }
    
    override func viewDidLoad() {
        /// TableView Delegate
        timeStreamCompositeTableView.delegate = self
        timeStreamConfigurationTableView.delegate = self
        
        /// TableView DataSource
        timeStreamCompositeTableView.dataSource = self
        timeStreamConfigurationTableView.dataSource = self
        
        /// TableView Drag and Drop
        timeStreamCompositeTableView.dragDelegate = self
        timeStreamCompositeTableView.dropDelegate = self
        timeStreamCompositeTableView.dragInteractionEnabled = true
        timeStreamConfigurationTableView.dropDelegate = self
        timeStreamConfigurationTableView.dragDelegate = self
        timeStreamConfigurationTableView.dragInteractionEnabled = true
        
        TimeStream.Core.add(reactive: self)
    }
    
    func editTimeStream() {
        /// Inject Star Chart Composite
        EditTimeStreamViewController.presentModally(over: self)
    }
    
}

// MARK: INTERFACE ACTIONS
extension TimeStreamSettingsViewController {
    
    func duplicateTimeStreamComposite() {
        print("Duplicate TimeStream Composite")
        // TODO: functionality for Duplicate TimeStream Composite
        
    }
    
    func deleteTimeStreamComposite() {
        print("Delete TimeStream Composite")
        // TODO: functionality for Delete TimeStream Composite
        
    }
    
    func addNewTimeStreamComposite() {
        print("Add New TimeStream Composite")
        // TODO: functionality for Add New TimeStream Composite
        
    }
    
    func selectTimeStreamComposite() {
        print("Select TimeStream Composite")
        // TODO: functionality for Select TimeStream Composite
        
    }
    
    func exportTimeStreamComposite() {
        print("Export New TimeStream Composite")
        // TODO: functionality for Export TimeStream Composite
        
    }
    
    func duplicateTimeStream() {
        print("Duplicate New TimeStream")
        // TODO: functionality for Duplicate TimeStream
        
    }
    
    func deleteTimeStream() {
        print("Delete New TimeStream")
        // TODO: functionality for Delete TimeStream
        
    }
    
    func addNewTimeStream() {
        print("Add New TimeStream")
        // TODO: functionality for Add New TimeStream
        
    }
    
    func selectTimeStream() {
        print("Select TimeStream")
        // TODO: functionality for Select TimeStream
        
    }
    
    func exportTimeStream() {
        print("Export New TimeStream Composite")
        // TODO: functionality for Export TimeStream
        
    }

}

// MARK: DATASOURCE
extension TimeStreamSettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == timeStreamCompositeTableView {
            return TimeStream.Core.currentComposites.count
        } else if tableView == timeStreamConfigurationTableView {
            return TimeStream.Core.currentComposites.count /// Number of Time Streams Selected to be Monitored
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == timeStreamCompositeTableView {
            
            if indexPath.row == timeStreamAddNewCompositeRow {
                guard let cell = timeStreamCompositeTableView.dequeueReusableCell(withIdentifier: "TimeStreamAddNewCompositeTableViewCell") as? TimeStreamAddNewCompositeTableViewCell else {
                    let cell = TimeStreamAddNewCompositeTableViewCell()
                    return cell
                }
                return cell
            } else {
                guard let cell = timeStreamCompositeTableView.dequeueReusableCell(withIdentifier: "TimeStreamCompositeTableViewCell") as? TimeStreamCompositeTableViewCell else {
                    let cell = TimeStreamCompositeTableViewCell()
                    cell.timeStreamComposite = TimeStream.Core.currentComposites[indexPath.row]
                    cell.update()
                    return cell
                }
                cell.timeStreamComposite = TimeStream.Core.currentComposites[indexPath.row]
                cell.update()
                return cell
            }
        } else if tableView == timeStreamConfigurationTableView {
            if indexPath.row == timeStreamAddNewRow {
                guard let cell = timeStreamConfigurationTableView.dequeueReusableCell(withIdentifier: "TimeStreamAddNewConfigurationTableViewCell") as? TimeStreamAddNewConfigurationTableViewCell else {
                    let cell = TimeStreamAddNewConfigurationTableViewCell()
                    return cell
                }
                return cell
            } else {
                guard let cell = timeStreamCompositeTableView.dequeueReusableCell(withIdentifier: "TimeStreamConfigurationTableViewCell") as? TimeStreamConfigurationTableViewCell else {
                    let cell = TimeStreamConfigurationTableViewCell()
                    cell.hashString = TimeStream.Core.currentComposites[indexPath.row].hashKey
                    return cell
                }
                cell.hashString = TimeStream.Core.currentComposites[indexPath.row].hashKey
                return cell
            }
        } else {
            return UITableViewCell()
        }
    }
}

// MARK: DELEGATE
extension TimeStreamSettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == timeStreamCompositeTableView {
            if indexPath.row == timeStreamAddNewCompositeRow {
                return 64
            } else {
                return 128
            }
        } else if tableView == timeStreamConfigurationTableView {
            if indexPath.row == timeStreamAddNewRow {
                return 64
            } else {
                return 128
            }
        }
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == timeStreamCompositeTableView {
            if indexPath.row == timeStreamAddNewCompositeRow {
                // ADD
                addNewTimeStreamComposite()
            } else {
                // EDIT (selected)
                selectTimeStreamComposite()
            }
        } else if tableView == timeStreamConfigurationTableView {
            if indexPath.row == timeStreamAddNewRow {
                // ADD
                addNewTimeStream()
            } else {
                // EDIT (selected)
                selectTimeStream()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView == timeStreamCompositeTableView { // TimeStream Composite
            if indexPath.row == timeStreamAddNewCompositeRow {
                /// Add New TimeStream Composite Cell
                return UISwipeActionsConfiguration(actions: [])
            } else {
                /// TimeStream Composite Cell
                let contextItemDuplicate = UIContextualAction(style: .normal, title: " Duplicate \n📄 ") {  (contextualAction, view, boolValue) in
                    /// Delete TimeStream Composite
                    TimeStream.Core.duplicateTimeStreamComposite()
                }
                let contextItemAddNew = UIContextualAction(style: .normal, title: " Add New \n➕ ") {  (contextualAction, view, boolValue) in
                    /// Duplicate TimeStream Composite
                    //TimeStream.Core.addNewTimeStreamComposite()
                }
                let contextItemExport = UIContextualAction(style: .normal, title: " Export \n📲 ") {  (contextualAction, view, boolValue) in
                    /// Duplicate TimeStream Composite
                    //TimeStream.Core.exportTimeStreamComposite()
                }
                return UISwipeActionsConfiguration(actions: [contextItemDuplicate, contextItemAddNew, contextItemExport])
            }
        } else if tableView == timeStreamConfigurationTableView { // TimeStream Configuration
            if indexPath.row == timeStreamAddNewRow {
                /// Add New TimeStream Configuration Cell
                return UISwipeActionsConfiguration(actions: [])
            } else {
                /// TimeStream Configuration Cell
                let contextItemEdit = UIContextualAction(style: .normal, title: " Edit \n🛠 ") {  (contextualAction, view, boolValue) in
                    /// Duplicate TimeStream Composite
                    EditTimeStreamViewController.presentModally(over: self)
                    // TODO: Pre-Focus on Edited TimeStream Composite
                }
                let contextItemDuplicate = UIContextualAction(style: .normal, title: " Duplicate \n📄 ") {  (contextualAction, view, boolValue) in
                    /// Delete TimeStream Composite
                    //TimeStream.Core.duplicateTimeStream()
                }
                let contextItemAddNew = UIContextualAction(style: .normal, title: " Add New \n➕ ") {  (contextualAction, view, boolValue) in
                    /// Duplicate TimeStream Composite
                    //TimeStream.Core.addNewTimeStream()
                }
                let contextItemExport = UIContextualAction(style: .normal, title: " Export \n📲 ") {  (contextualAction, view, boolValue) in
                    /// Duplicate TimeStream Composite
                    //TimeStream.Core.exportTimeStream()
                }
                return UISwipeActionsConfiguration(actions: [contextItemEdit, contextItemDuplicate, contextItemAddNew, contextItemExport])
            }
        } else {
            return UISwipeActionsConfiguration(actions: [])
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView == timeStreamCompositeTableView {
            if indexPath.row == timeStreamAddNewCompositeRow {
                /// Add New TimeStream Composite Cell
                return UISwipeActionsConfiguration(actions: [])
            } else {
                /// TimeStream Composite Cell
                let contextItemDelete = UIContextualAction(style: .destructive, title: " Delete \n✖️ ") {  (contextualAction, view, boolValue) in
                    /// Delete TimeStream Composite
                    self.deleteTimeStreamComposite()
                }
                return UISwipeActionsConfiguration(actions: [contextItemDelete])
            }
        } else if tableView == timeStreamConfigurationTableView {
            if indexPath.row == timeStreamAddNewRow {
                /// Add New TimeStream Configuration Cell
                return UISwipeActionsConfiguration(actions: [])
            } else {
                /// TimeStream Configuration Cell
                let contextItemDelete = UIContextualAction(style: .destructive, title: " Delete \n✖️ ") {  (contextualAction, view, boolValue) in
                    /// Delete TimeStream Composite
                    self.deleteTimeStream()
                }
                return UISwipeActionsConfiguration(actions: [contextItemDelete])
            }
        } else {
            return UISwipeActionsConfiguration(actions: [])
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if tableView == timeStreamCompositeTableView {
            if indexPath.row == timeStreamAddNewCompositeRow {
                return false
            }
        } else if tableView == timeStreamConfigurationTableView {
            if indexPath.row == timeStreamAddNewRow {
                return false
            }
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if tableView == timeStreamCompositeTableView {
            /// Cell is Add Button
            if destinationIndexPath.row == timeStreamAddNewCompositeRow {
                return
                //addNewTimeStreamCompositeCustomRow = destinationIndexPath.row
            }
            
            /// Update Data Model
            let mover = TimeStreamCompositeRegistry.main.uuidList.remove(at: sourceIndexPath.row)
            TimeStreamCompositeRegistry.main.uuidList.insert(mover, at: destinationIndexPath.row)
        } else if tableView == timeStreamConfigurationTableView {
            /// Cell is Add Button
            if destinationIndexPath.row == timeStreamAddNewRow {
                return
                //addNewTimeStreamCustomRow = destinationIndexPath.row
            }
            /// Update Data Model
//            let mover = currentTimeStreams.remove(at: sourceIndexPath.row)
//            currentTimeStreams.insert(mover, at: destinationIndexPath.row)
        }
    }
}

// MARK: DRAG
extension TimeStreamSettingsViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if tableView == timeStreamCompositeTableView {
            
            if indexPath.row == timeStreamAddNewCompositeRow {
                // ADD
                return []
            } else {
                // DRAG
                let hashString:String = TimeStream.Core.currentComposites[indexPath.row].hashKey
                guard let data = hashString.data(using: .utf8) else { return [] }
                let itemProvider = NSItemProvider(item: data as NSData, typeIdentifier: "app.cosmiccypher.timestreamcomposite")
                let dragItem = UIDragItem(itemProvider: itemProvider)
                //dragItem.localObject = data[indexPath.row] // TimeStream
                return [ dragItem ]
            }
        } else if tableView == timeStreamConfigurationTableView {
            if indexPath.row == timeStreamAddNewRow {
                // ADD
                return []
            } else {
                // DRAG
                let string = "timestream x"//currentTimeStreams[indexPath.row]
                guard let data = string.data(using: .utf8) else { return [] }
                let itemProvider = NSItemProvider(item: data as NSData, typeIdentifier: "app.cosmiccypher.timestream")
                let dragItem = UIDragItem(itemProvider: itemProvider)
                //dragItem.localObject = data[indexPath.row] // TimeStream
                return [ dragItem ]
            }
        } else {
            return []
        }
    }
    
    
}

// MARK: DROP
extension TimeStreamSettingsViewController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
        let destinationIndexPath: IndexPath
        
        if tableView == timeStreamCompositeTableView {
            
            if let indexPath = coordinator.destinationIndexPath {
                destinationIndexPath = indexPath
            } else {
                let section = tableView.numberOfSections - 1
                let row = tableView.numberOfRows(inSection: section)
                destinationIndexPath = IndexPath(row: row, section: section)
            }
            
//            guard timeStreamAddNewCompositeRow != destinationIndexPath.row else {
//                return
//            }
            
            // attempt to load strings from the drop coordinator
            coordinator.session.loadObjects(ofClass: NSString.self) { items in
                // convert the item provider array to a string array or bail out
                guard let strings = items as? [String] else { return }

                // create an empty array to track rows we've copied
                var indexPaths = [IndexPath]()

                // loop over all the strings we received
                for (index, string) in strings.enumerated() {
                    // create an index path for this new row, moving it down depending on how many we've already inserted
                    let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)

                    // insert the copy into the correct array
//                    TimeStreamCompositeRegistry.main.hashList.insert(string, at: indexPath.row)
//                    TimeStream.Core.currentComposites[indexPath.row].hashKey

                    // keep track of this new row
                    indexPaths.append(indexPath)
                }

                // insert them all into the table view at once
                tableView.insertRows(at: indexPaths, with: .automatic)
            }
        } else if tableView == timeStreamConfigurationTableView {
            
            if let indexPath = coordinator.destinationIndexPath {
                destinationIndexPath = indexPath
            } else {
                let section = tableView.numberOfSections - 1
                let row = tableView.numberOfRows(inSection: section)
                destinationIndexPath = IndexPath(row: row, section: section)
            }
            
//            guard timeStreamAddNewRow != destinationIndexPath.row else {
//                return
//            }
            
            // attempt to load strings from the drop coordinator
            coordinator.session.loadObjects(ofClass: NSString.self) { items in
                // convert the item provider array to a string array or bail out
                guard let strings = items as? [String] else { return }

                // create an empty array to track rows we've copied
                var indexPaths = [IndexPath]()

                // loop over all the strings we received
                for (index, string) in strings.enumerated() {
                    // create an index path for this new row, moving it down depending on how many we've already inserted
                    let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)

                    // insert the copy into the correct array
//                    self.currentTimeStreams.insert(string, at: indexPath.row)

                    // keep track of this new row
                    indexPaths.append(indexPath)
                }

                // insert them all into the table view at once
                tableView.insertRows(at: indexPaths, with: .automatic)
            }
        } else {
        }
    }
    
}
