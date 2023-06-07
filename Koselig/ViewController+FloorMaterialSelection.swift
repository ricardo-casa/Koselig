//
//  ViewController+FloorMaterialSelection.swift
//  Koselig
//
//  Created by Ricardo Carrillo  on 06/06/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

extension ViewController: FloorMaterialSelectionViewControllerDelegate {
// MARK: - FloorMaterialSelectionViewControllerDelegate
    /// - Tag: Change Material to the selected in FloorlMaterialSelectionViewController
    func floorMaterialSelectionViewController(_ selectionViewController: FloorMaterialSelectionViewController, didSelectMaterial floorMaterial: PlaneMaterial) {
        /// Changing the default material to new planes
        self.defaultFloorPlanesMaterial = floorMaterial
        /// Updating material of the detected planes as long as the anchor alignment is vertical
        for plane in self.planes {
            if plane.anchor.alignment == .horizontal{
                plane.updatePlaneMaterial(material_: floorMaterial)
            }
        }
    }
    /// - Tag: Change Material to the none, this will apply a material with full transparency as planes always need a material
    func floorMaterialSelectionViewController(_ selectionViewController: FloorMaterialSelectionViewController, didDeselectMaterial floorMaterial: PlaneMaterial) {
        
    }
}
