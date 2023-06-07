import SceneKit
import ARKit

class PlaneMaterial : SCNMaterial {
    var textureFilename: String
    var image: UIImage
    var scaleX: Float
    var scaleY: Float
    var allowedAlignment: ARRaycastQuery.TargetAlignment
    
    
    init(textureFilename: String, scaleX: Float, scaleY: Float, allowedAlignment: ARRaycastQuery.TargetAlignment){ //texture image
        self.textureFilename = textureFilename
        self.image = UIImage(named: textureFilename)!
        self.scaleX = scaleX
        self.scaleY = scaleY
        
        self.allowedAlignment = allowedAlignment
        
        super.init()
        self.locksAmbientWithDiffuse = false
        /// to avoid lights interaction from scn (3d models)
        self.lightingModel = .constant
        self.isDoubleSided = false
        self.diffuse.contents = image
        self.ambient.contents = UIColor.white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(textureFilename: String, scaleX: Float, scaleY: Float){
        self.image = UIImage(named: textureFilename)!
        self.scaleX = scaleX
        self.scaleY = scaleY
    }
}

extension PlaneMaterial {
    static let availableWallMaterials: [PlaneMaterial] =
        [PlaneMaterial(textureFilename: "tales", scaleX: 15, scaleY: 5, allowedAlignment: .vertical),
         
         PlaneMaterial(textureFilename: "white-bricks-1.1", scaleX: 15, scaleY: 15, allowedAlignment: .vertical),
         
         PlaneMaterial(textureFilename: "green-tiles-1.1", scaleX: 15, scaleY: 5, allowedAlignment: .vertical),]

    static let availableFloorMaterials: [PlaneMaterial] =
        [PlaneMaterial(textureFilename: "woodFloor", scaleX: 10, scaleY: 10, allowedAlignment: .horizontal)]
}
