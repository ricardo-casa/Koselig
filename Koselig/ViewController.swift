/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Main view controller for the AR experience.
*/

import UIKit
import SceneKit
import ARKit

// MARK: - Globals
var segmentIndex: Int = 0


// MARK: -
@available(iOS 13.0, *)
class ViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet weak var sessionInfoView: UIView!
    @IBOutlet weak var sessionInfoLabel: UILabel!
    
    
    @IBOutlet var sceneView: VirtualObjectARView!
    
    @IBOutlet var segmentControlButton: UISegmentedControl!
    @IBOutlet weak var addObjectButton: UIButton!

    // MARK: - UI Elements
    
    /// The view controller that displays the virtual object selection menu.
    var objectsViewController: VirtualObjectSelectionViewController?
    
    var focusSquare = FocusSquare()

    
    // MARK: - AR configuration properties
    
    /// Coordinates the loading and unloading of reference nodes for virtual objects.
    let virtualObjectLoader = VirtualObjectLoader()
    
    /// A serial queue used to coordinate adding or removing nodes from the scene.
    let updateQueue = DispatchQueue(label: "com.example.apple-samplecode.arkitexample.serialSceneKitQueue")
    
    /// A type which manages gesture manipulation of virtual content in the scene.
    //lazy var virtualObjectInteraction = VirtualObjectInteraction(sceneView: sceneView, viewController: self)
    
    /// Convenience accessor for the session owned by ARSCNView.
    var session: ARSession {
        return sceneView.session
    }
    
    // MARK: - Other variables
    let wallMaterials: [Material] = [
        Material(textureFilename: "tales", scaleX: 15, scaleY: 5),
        Material(textureFilename: "white-bricks-1.1", scaleX: 15, scaleY: 15),
        Material(textureFilename: "green-tiles-1.1", scaleX: 15, scaleY: 5)
    ]
    
    let floorMaterials: [Material] = [
        Material(textureFilename: "woodFloor", scaleX: 10, scaleY: 10),
    ]
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        // Set up scene content.
        sceneView.scene.rootNode.addChildNode(focusSquare)
    }
    /// - Tag: StartARSession
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Start the view's AR session with a configuration that uses the rear camera,
        // device position and orientation tracking, and plane detection.
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.vertical, .horizontal ]
        sceneView.session.run(configuration)
        
        // Set a delegate to track the number of plane anchors for providing UI feedback.
        sceneView.session.delegate = self
        
        // Prevent the screen from being dimmed after a while as users will likely
        // have long periods of interaction without touching the screen or buttons.
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Show debug UI to view performance metrics (e.g. frames per second).
        sceneView.showsStatistics = true
        
        addGestures()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's AR session.
        sceneView.session.pause()
    }
    
    // MARK: - Focus Square

    func updateFocusSquare(isObjectVisible: Bool) {
           
        /*
        if isObjectVisible {
            focusSquare.hide()
        } else {
            focusSquare.unhide()
        }
         */
        
        // Realizamos un raycast siempre que la camara se encuentre en un estado normal
        if let camera = session.currentFrame?.camera, case .normal = camera.trackingState,
            let query = sceneView.getRaycastQuery(),
            let result = sceneView.castRay(for: query).first {
            
            updateQueue.async {
                self.sceneView.scene.rootNode.addChildNode(self.focusSquare)
                self.focusSquare.state = .detecting(raycastResult: result, camera: camera)
            }
            
        } else {
            updateQueue.async {
                self.focusSquare.state = .initializing
                self.sceneView.pointOfView?.addChildNode(self.focusSquare)
            }
            //addObjectButton.isHidden = true
            objectsViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
    // MARK: - IBActions
    
    // SegmentControl Action
    @IBAction func stepper(_ sender: UISegmentedControl){
        segmentIndex = Int(sender.selectedSegmentIndex)
    }
}
