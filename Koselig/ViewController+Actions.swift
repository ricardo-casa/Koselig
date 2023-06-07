//
//  ViewController+Actions.swift
//  ARKitBasics
//
//  Created by Ricardo Carrillo  on 22/05/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

@available(iOS 13.0, *)
extension ViewController: UIGestureRecognizerDelegate {
    
    enum SegueIdentifier: String, CaseIterable {
        case showObjects
        case showWallMaterials
        case showFloorMaterials
    }
    
    // MARK: - UI Actions
    /// Valid Segue Identifiers in UI
    @IBAction func showVirtualObjectSelectionViewController() {
        performSegue(withIdentifier: SegueIdentifier.showObjects.rawValue, sender: addObjectButton)
    }

    @IBAction func showPlaneWallMaterialSelectionController() {
        performSegue(withIdentifier: SegueIdentifier.showWallMaterials.rawValue, sender: addWallMaterialButton)
    }
    
    @IBAction func showPlaneFloorMaterialSelectionController() {
        performSegue(withIdentifier: SegueIdentifier.showFloorMaterials.rawValue, sender: addFloorMaterialButton)
    }
}

@available(iOS 13.0, *)
extension ViewController: UIPopoverPresentationControllerDelegate {
// MARK: - UIPopoverPresentationControllerDelegate
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /// All menus should be popovers (even on iPhone).
        if let popoverController = segue.destination.popoverPresentationController, let button = sender as? UIButton {
            popoverController.delegate = self
            popoverController.sourceView = button
            popoverController.sourceRect = button.bounds
        }
        
        /// Get identifier of specified segues
        guard let identifier = segue.identifier,
              let segueIdentifer = SegueIdentifier(rawValue: identifier),
              SegueIdentifier.allCases.contains(segueIdentifer) else { return }
        
        /// Acording to the especifies segue, display the matching view controller
        switch (segueIdentifer) {
        case .showObjects:
            let objectsViewController = segue.destination as! VirtualObjectSelectionViewController
            objectsViewController.virtualObjects = VirtualObject.availableObjects
            objectsViewController.delegate = self
            objectsViewController.sceneView = sceneView
            self.objectsViewController = objectsViewController
            /// Check if a loaded object is
            for object in virtualObjectLoader.loadedObjects {
                guard let index = VirtualObject.availableObjects.firstIndex(of: object) else { continue }
                objectsViewController.selectedVirtualObjectRows.insert(index)
            }
            
        case .showWallMaterials:
            let wallMaterialsSelectionViewController = segue.destination as! WallMaterialSelectionViewController
            wallMaterialsSelectionViewController.wallMaterials = PlaneMaterial.availableWallMaterials
            wallMaterialsSelectionViewController.delegate = self
            wallMaterialsSelectionViewController.sceneView = sceneView
            self.wallMaterialsSelectionViewController = wallMaterialsSelectionViewController
            
        case .showFloorMaterials:
            let floorMaterialsSelectionViewController = segue.destination as! FloorMaterialSelectionViewController
            floorMaterialsSelectionViewController.floorMaterials = PlaneMaterial.availableFloorMaterials
            floorMaterialsSelectionViewController.delegate = self
            floorMaterialsSelectionViewController.sceneView = sceneView
            self.floorMaterialsSelectionViewController = floorMaterialsSelectionViewController
        }

    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        objectsViewController = nil
    }
}



