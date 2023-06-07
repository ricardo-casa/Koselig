/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Main view controller for the AR experience.
*/

import UIKit
import SceneKit
import ARKit

@available(iOS 13.0, *)
class ViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet weak var sessionInfoView: UIView!
    
    @IBOutlet weak var sessionInfoLabel: UILabel!
    
    @IBOutlet var sceneView: VirtualObjectARView!
        
    @IBOutlet weak var addObjectButton: UIButton!
    
    @IBOutlet weak var addWallMaterialButton: UIButton!
    
    @IBOutlet weak var addFloorMaterialButton: UIButton!
    
    
    // MARK: - UI Elements
    
    /// The view controller that displays the virtual object selection menu.
    var objectsViewController: VirtualObjectSelectionViewController?
    ///The view Controller that displays the available wall Materials
    var wallMaterialsSelectionViewController: WallMaterialSelectionViewController?
    ///The view Controller that displays the available floor Materials
    var floorMaterialsSelectionViewController: FloorMaterialSelectionViewController?
    /// A type of crosshair that focus a specific point in planes
    var focusSquare = FocusSquare()
    /// An array that stores all the found planes
    var planes : [Plane] = []
    /// Default material to apply to new detected vertical Planes
    var defaultWallPlanesMaterial : PlaneMaterial = PlaneMaterial.availableWallMaterials[0]
    /// Default material to apply to new detected horizontal Planes
    var defaultFloorPlanesMaterial : PlaneMaterial = PlaneMaterial.availableFloorMaterials[0]
    /// Flag to detect a single horizontal plane ("floor")
    var floorDetected = false

    // MARK: - AR configuration properties
    /// Coordinates the loading and unloading of reference nodes for virtual objects.
    let virtualObjectLoader = VirtualObjectLoader()
    /// A serial queue used to coordinate adding or removing nodes from the scene.
    let updateQueue = DispatchQueue(label: "com.example.apple-samplecode.arkitexample.serialSceneKitQueue")
    /// A type which manages gesture manipulation of virtual content in the scene.
    lazy var virtualObjectInteraction = VirtualObjectInteraction(sceneView: sceneView, viewController: self)
    /// Convenience accessor for the session owned by ARSCNView.
    var session: ARSession {
        return sceneView.session
    }
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        /// Set up scene content.
        /// First Node in Scene
        sceneView.scene.rootNode.addChildNode(focusSquare)
        
        /// Adding a single directional light to scene
        let directionalLight = SCNNode()
            directionalLight.light = SCNLight()
            directionalLight.light!.type = .directional
            directionalLight.light!.color = UIColor(white: 1.0, alpha: 1.0)
            directionalLight.eulerAngles = SCNVector3(x: 0, y: 0, z: 0)
        sceneView.scene.rootNode.addChildNode(directionalLight)
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's AR session.
        sceneView.session.pause()
    }
    
    // MARK: - Focus Square
    func updateFocusSquare(isObjectVisible: Bool) {
        
        /// Perform a raycast whenever the camera is in a normal state
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
            objectsViewController?.dismiss(animated: false, completion: nil)
        }
    }
}
