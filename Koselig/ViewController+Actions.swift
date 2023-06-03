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
    
    enum SegueIdentifier: String {
        case showObjects
    }
    
    // MARK: - UI Actions
    
    @IBAction func showVirtualObjectSelectionViewController() {
        // Ensure adding objects is an available action and we are not loading another object (to avoid concurrent modifications of the scene).
        //guard !addObjectButton.isHidden && !virtualObjectLoader.isLoading else { return }
        
        //statusViewController.cancelScheduledMessage(for: .contentPlacement)
        
        performSegue(withIdentifier: SegueIdentifier.showObjects.rawValue, sender: addObjectButton)
    }
    
    
    // MARK: - Gestures
    func addGestures () {
        let tapped = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        sceneView.addGestureRecognizer(tapped)
    }
    
    @objc func tapGesture (sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: sceneView)
        //let hitTest = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
        
        let raycastQuery: ARRaycastQuery? = sceneView.raycastQuery(
            from: location, allowing: .existingPlaneInfinite, alignment: .any)
        
        let rcQueryResults: [ARRaycastResult] = sceneView.session.raycast(raycastQuery!)
        
        if rcQueryResults.isEmpty {
            print("No Plane Detected")
            return
        } else {
            
            let intersections = rcQueryResults.count
            print("I hit \(intersections) plane " )
            
            switch rcQueryResults.first!.targetAlignment {
            case .horizontal :
                print("horizontal")
                
                guard let scene = SCNScene(named: "candle.scn", inDirectory: "Assets.scnassets/Models/candle")
                else { fatalError("Unable to load scene file.") }
                
                let node = scene.rootNode.childNode(withName: "candle", recursively: false)
                
                let columns = rcQueryResults.first?.worldTransform.columns.3
                
                node!.position = SCNVector3(x: columns!.x, y: columns!.y, z: columns!.z)
                
                sceneView.scene.rootNode.addChildNode(node!)
                
                
            case .vertical:
                print("vertical")
                
            case .any:
                break
            @unknown default:
                break
            }
        }
    }
}

@available(iOS 13.0, *)
extension ViewController: UIPopoverPresentationControllerDelegate {
// MARK: - UIPopoverPresentationControllerDelegate
    
    //Dynamic presentetion for popover table view
    /*
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // All menus should be popovers (even on iPhone).
        if let popoverController = segue.destination.popoverPresentationController, let button = sender as? UIButton {
            popoverController.delegate = self
            popoverController.sourceView = button
            popoverController.sourceRect = button.bounds
        }
        
        guard let identifier = segue.identifier,
              let segueIdentifer = SegueIdentifier(rawValue: identifier),
              segueIdentifer == .showObjects else { return }
        
        let objectsViewController = segue.destination as! VirtualObjectSelectionViewController
        objectsViewController.virtualObjects = VirtualObject.availableObjects
        objectsViewController.delegate = self
        objectsViewController.sceneView = sceneView
        self.objectsViewController = objectsViewController
        
        // Set all rows of currently placed objects to selected.
        for object in virtualObjectLoader.loadedObjects {
            guard let index = VirtualObject.availableObjects.firstIndex(of: object) else { continue }
            objectsViewController.selectedVirtualObjectRows.insert(index)
        }
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        objectsViewController = nil
    }
}



