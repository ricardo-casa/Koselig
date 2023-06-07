/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Convenience class for visualizing Plane extent and geometry
*/

import ARKit
import SceneKit

// Convenience extension for colors defined in asset catalog.
extension UIColor {
    static let planeColor = UIColor(named: "planeColor")!
}

class Plane: SCNNode {
    let meshNode: SCNNode
    let extentNode: SCNNode
    var material: PlaneMaterial
    let extentPlane: SCNPlane
    let anchor: ARPlaneAnchor
    
    /// - Tag: VisualizePlane
    init(anchor: ARPlaneAnchor, in sceneView: ARSCNView, material: PlaneMaterial) {
        
        #if targetEnvironment(simulator)
        #error("ARKit is not supported in iOS Simulator. Connect a physical iOS device and select it as your Xcode run destination, or select Generic iOS Device as a build-only destination.")
        #else
        
        self.anchor = anchor
        
        /// Create a mesh to visualize the estimated shape of the plane.
        guard let meshGeometry = ARSCNPlaneGeometry(device: sceneView.device!)
            else { fatalError("Can't create plane geometry") }
        meshGeometry.update(from: anchor.geometry)
        meshNode = SCNNode(geometry: meshGeometry)
        
        /// Create a node to visualize the plane's bounding rectangle.
        self.extentPlane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        
        extentNode = SCNNode(geometry: extentPlane)
        extentNode.simdPosition = anchor.center
    
        /// `SCNPlane` is vertically oriented in its local coordinate space, so
        /// rotate it to match the orientation of `ARPlaneAnchor`.
        extentNode.eulerAngles.x = -.pi / 2
        
        ///adding material
        self.material = material
       
        super.init()
        
        ///adding scale of material
        self.setupMeshVisualStyle()
        self.setupExtentVisualStyle()

        /// Add the plane extent and plane geometry as child nodes so they appear in the scene.
        addChildNode(meshNode)
        addChildNode(extentNode)
        
        #endif
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Public Methods
    func updatePlaneMaterial(material_: PlaneMaterial) {
        self.material = material_
        self.setupMeshVisualStyle()
    }
    
    
// MARK: - Private Methods
    /// - Tag: Plane Visuals
    private func setupMeshVisualStyle() {
        // Make the plane visualization semitransparent to clearly show real-world placement.
        meshNode.opacity = 0.8
        
        /// - Tag: Setting scale factors
        /// Every material has different pixel density/meter so every time plane changes its size
        /// a new scale factor is needed.
        let widthScale = (Float(self.extentPlane.width)  / self.material.scaleX).rounded()
        
        let heigthScale = (Float(self.extentPlane.height)  / self.material.scaleY).rounded()
        
        /// Material Settings Could be different, this case is only repeats the material by given a
        /// scale factor
        material.diffuse.contentsTransform = SCNMatrix4MakeScale(widthScale, heigthScale, 0)
        material.diffuse.wrapS = .repeat
        material.diffuse.wrapT = .repeat
        meshNode.geometry?.materials = [material]
    }
    
    private func setupExtentVisualStyle() {
        // Make the extent visualization semitransparent to clearly show real-world placement.
        extentNode.opacity = 0.7
    
        guard let material = extentNode.geometry?.firstMaterial
            else { fatalError("SCNPlane always has one material") }
        
        material.diffuse.contents = UIColor.planeColor

        /// Use a SceneKit shader modifier to render only the borders of the plane.
        guard let path = Bundle.main.path(forResource: "wireframe_shader", ofType: "metal", inDirectory: "Assets.scnassets")
            else { fatalError("Can't find wireframe shader") }
        do {
            let shader = try String(contentsOfFile: path, encoding: .utf8)
            material.shaderModifiers = [.surface: shader]
        } catch {
            fatalError("Can't load wireframe shader: \(error)")
        }
    }
}
