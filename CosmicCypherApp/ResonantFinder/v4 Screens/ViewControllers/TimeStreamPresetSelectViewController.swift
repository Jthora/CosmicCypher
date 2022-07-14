//
//  TimeStreamPresetSelectViewController.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 6/30/22.
//

import UIKit

class TimeStreamPresetSelectViewController: UIViewController {
    
    static func presentModally(over presentingViewController: UIViewController) {
        guard let vc = UIStoryboard(name: "TimeStreamSelect", bundle: nil).instantiateViewController(withIdentifier: "TimeStreamPresetSelectViewController") as? TimeStreamPresetSelectViewController else {
            return
        }
        presentingViewController.present(vc, animated: true) {
            
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
}


extension TimeStreamPresetSelectViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TimeStream.Preset.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TimeStreamPresetTableViewCell") as? TimeStreamPresetTableViewCell else {
            let cell = TimeStreamPresetTableViewCell()
            cell.titleLabel.text = TimeStream.Preset.allCases[indexPath.row].titleText
            cell.subTitleLabel.text = TimeStream.Preset.allCases[indexPath.row].subTitleText
            return cell
        }
        cell.titleLabel.text = TimeStream.Preset.allCases[indexPath.row].titleText
        cell.subTitleLabel.text = TimeStream.Preset.allCases[indexPath.row].subTitleText
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let preset = TimeStream.Preset(rawValue: indexPath.row) else {
            print("ERROR: No TimeStream.Preset for indexPath.row: [\(indexPath.row)]")
            return
        }
        let uuid = UUID()
        dismissAllViewControllers(animated: true) {
            DispatchQueue.global().async {
                TimeStream.Core.addNewComposite(uuid: uuid, preset: preset)
                DispatchQueue.main.async {
                    ResonanceReportViewController.current?.timeStreamTableView.reloadData()
                    ResonanceReportViewController.current?.loadingTimeStreamsSpinner.stopAnimating()
                }
            }
        }
    }
    
}
