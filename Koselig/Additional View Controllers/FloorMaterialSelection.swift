//
//  FloorMaterialSelection.swift
//  Koselig
//
//  Created by Ricardo Carrillo  on 06/06/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation
import ARKit
// MARK: - ObjectCell
@available(iOS 13.0, *)
class FloorMaterialCell: UITableViewCell {
    static let reuseIdentifier = "FloorMaterialCell"
    
    @IBOutlet weak var floorMaterialTitleLabel: UILabel!
    
    var floorMaterialName = "" {
        didSet { floorMaterialTitleLabel.text = floorMaterialName.capitalized }
    }    
}
// MARK: - FloorMaterialSelectionViewControllerDelegate

/// A protocol for reporting which material have been selected.
@available(iOS 13.0, *)
protocol FloorMaterialSelectionViewControllerDelegate: AnyObject {
    /// Gets the selected material by the view controller
    func floorMaterialSelectionViewController(_ selectionViewController: FloorMaterialSelectionViewController, didSelectMaterial: PlaneMaterial)
    /// Gets the deselected material by the view controller
    func floorMaterialSelectionViewController(_ selectionViewController: FloorMaterialSelectionViewController, didDeselectMaterial: PlaneMaterial)
}


class FloorMaterialSelectionViewController: UITableViewController {
    
    /// Reference to the loaded floor materials from `PlaneMaterial` static value
    var floorMaterials = [PlaneMaterial]()
    /// Index of the selected `PlaneMaterial`
    var selectedFloorMaterial : Int = -1
    /// A reference of the main scene view
    weak var sceneView: ARSCNView?
    /// Reference to protocol
    weak var delegate: FloorMaterialSelectionViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// Dynamic layout
    override func viewWillLayoutSubviews() {
        //preferredContentSize = CGSize(width: 250, height: tableView.contentSize.height)
    }
    
    // MARK: - UITableViewDataSource
    /// create a number of cells equal to the number of materials
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return floorMaterials.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //create a cell of type floor material cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FloorMaterialCell.reuseIdentifier, for: indexPath) as? FloorMaterialCell else {
            fatalError("Expected `\(FloorMaterialCell.self)` type for reuseIdentifier \(FloorMaterialCell.reuseIdentifier). Check the configuration in Main.storyboard.")
        }
        /// Set the cell's name by the materal name
        cell.floorMaterialName = floorMaterials[indexPath.row].textureFilename
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
            self.selectedFloorMaterial = 0
        }
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFloorMaterial = indexPath.row
        let floorMaterial = floorMaterials[indexPath.row]
        delegate?.floorMaterialSelectionViewController(self, didSelectMaterial: floorMaterial)
        dismiss(animated: true, completion: nil)
    }
    
    
}
