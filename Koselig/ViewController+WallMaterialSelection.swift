//
//  ViewController+WallMaterialSelection.swift
//  Koselig
//
//  Created by Ricardo Carrillo  on 05/06/23.
//  Copyright © 2023 Apple. All rights reserved.
//
import Foundation
import ARKit

extension ViewController: WallMaterialSelectionViewControllerDelegate{
// MARK: - WallMaterialSelectionViewControllerDelegate
    /// - Tag: Change Material to the selected in WallMaterialSelectionViewController
    func wallMaterialSelectionViewController(_ selectionViewController: WallMaterialSelectionViewController, didSelectMaterial wallMaterial: PlaneMaterial) {
        /// Changing the default material to new planes
        self.defaultWallPlanesMaterial = wallMaterial
        /// Updating material of the detected planes as long as the anchor alignment is vertical
        for plane in self.planes{
            if plane.anchor.alignment == .vertical{
                plane.updatePlaneMaterial(material_: wallMaterial)
            }
        }
    }
    /// - Tag: Change Material to the none, this will apply a material with full transparency as planes always need a material
    func wallMaterialSelectionViewController(_ selectionViewController: WallMaterialSelectionViewController, didDeselectMaterial wallMaterial: PlaneMaterial) {
        
    }
}
