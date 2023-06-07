import SceneKit
import ARKit

class PlaneMaterial : SCNMaterial {
    var textureFilename: String
    var image: UIImage
    /// the scales factor in m to repeat the texture
    var scaleX: Float
    var scaleY: Float
    /// must match with plane alignment
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
    [PlaneMaterial(textureFilename: "Void", scaleX: 1, scaleY: 1, allowedAlignment: .vertical),
    
    PlaneMaterial(textureFilename: "Talavera", scaleX: 0.3, scaleY: 0.3, allowedAlignment: .vertical),
         
     PlaneMaterial(textureFilename: "White Bricks", scaleX: 0.35, scaleY: 0.3, allowedAlignment: .vertical),
         
     PlaneMaterial(textureFilename: "Green Tiles", scaleX: 0.3, scaleY: 0.3, allowedAlignment: .vertical),
        
     PlaneMaterial(textureFilename: "Triangles Wallpaper", scaleX: 0.6, scaleY: 0.6, allowedAlignment: .vertical),
     
     PlaneMaterial(textureFilename: "Artdeco Shells", scaleX: 0.282, scaleY: 0.4335, allowedAlignment: .vertical),
     
     PlaneMaterial(textureFilename: "Silver Diamonds", scaleX: 0.42, scaleY: 0.6, allowedAlignment: .vertical),]

    static let availableFloorMaterials: [PlaneMaterial] =
    [PlaneMaterial(textureFilename: "Void", scaleX: 1, scaleY: 1, allowedAlignment: .horizontal),
    
     PlaneMaterial(textureFilename: "Light Parquet", scaleX: 1.2, scaleY: 1.2, allowedAlignment: .horizontal),
     
     PlaneMaterial(textureFilename: "Gray Parquet", scaleX: 0.664, scaleY: 0.373, allowedAlignment: .horizontal),
    
     PlaneMaterial(textureFilename: "Poona Tiles", scaleX: 0.333, scaleY: 0.333, allowedAlignment: .horizontal),
    
     PlaneMaterial(textureFilename: "Travertine Tiles", scaleX: 0.28, scaleY: 0.28, allowedAlignment: .horizontal),
    
     PlaneMaterial(textureFilename: "Triangle Light Parquet", scaleX: 1.213, scaleY: 1.213, allowedAlignment: .horizontal),
     
     PlaneMaterial(textureFilename: "Abstract Mosaic", scaleX: 0.3, scaleY: 0.3, allowedAlignment: .horizontal),]
}
