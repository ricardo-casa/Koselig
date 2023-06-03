import SceneKit

class Material : SCNMaterial {
    var image: UIImage
    var scaleX: Float
    var scaleY: Float
    
    init(textureFilename: String, scaleX: Float, scaleY: Float){ //texture image
        self.image = UIImage(named: textureFilename)!
        self.scaleX = scaleX
        self.scaleY = scaleY
        super.init()
        self.locksAmbientWithDiffuse = true
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
