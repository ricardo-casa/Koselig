//
//  PlaneMaterialSelector.swift
//  Koselig
//
//  Created by Ricardo Carrillo  on 04/06/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import UIKit
import ARKit
// MARK: - ObjectCell
@available(iOS 13.0, *)
class WallMaterialCell: UITableViewCell {
    static let reuseIdentifier = "WallMaterialCell"
    
    @IBOutlet weak var wallMaterialTitleLabel : UILabel!
    
    var wallMaterialName = "" {
        didSet { wallMaterialTitleLabel.text = wallMaterialName.capitalized
        }
    }
}
// MARK: - WallMaterialSelectionViewControllerDelegate

/// A protocol for reporting which material have been selected.
@available(iOS 13.0, *)
protocol WallMaterialSelectionViewControllerDelegate: AnyObject {
    func wallMaterialSelectionViewController(_ selectionViewController: WallMaterialSelectionViewController, didSelectMaterial: PlaneMaterial)
    
    func wallMaterialSelectionViewController(_ selectionViewController: WallMaterialSelectionViewController, didDeselectMaterial: PlaneMaterial)
}

class WallMaterialSelectionViewController: UITableViewController {
     
    /// Reference to the loaded wall materials from `PlaneMaterial` static value
    var wallMaterials = [PlaneMaterial]()
    /// Index of the selected `PlaneMaterial`
    var selectedWallMaterial : Int = -1
    /// A reference of the main scene view
    weak var sceneView: ARSCNView?
    
    weak var delegate: WallMaterialSelectionViewControllerDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Dynamic layout
    override func viewWillLayoutSubviews() {
        //preferredContentSize = CGSize(width: 250, height: tableView.contentSize.height)
    }
    
    // MARK: - UITableViewDataSource
    //create a number of cells equal to the number of materials
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wallMaterials.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //create a cell of type wall material cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WallMaterialCell.reuseIdentifier, for: indexPath) as? WallMaterialCell else {
            fatalError("Expected `\(WallMaterialCell.self)` type for reuseIdentifier \(WallMaterialCell.reuseIdentifier). Check the configuration in Main.storyboard.")
        }
        
        //Set the cell name by the materal name
        cell.wallMaterialName = wallMaterials[indexPath.row].textureFilename
        
        if indexPath.row == selectedWallMaterial{
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
            self.selectedWallMaterial = 0
            //print("selected material nc\(wallMaterials[selectedWallMaterial].textureFilename)")

        }
    }

    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            selectedWallMaterial = indexPath.row
            let wallMaterial = wallMaterials[selectedWallMaterial]
            delegate?.wallMaterialSelectionViewController(self, didSelectMaterial: wallMaterial)
            dismiss(animated: true, completion: nil)
    }
}
