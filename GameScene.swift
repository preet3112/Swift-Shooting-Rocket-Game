import SpriteKit
import GameplayKit
import CoreData

class GameScene: SKScene, SKPhysicsContactDelegate {

    var mainPlayer: SKSpriteNode?
    var explosion: SKSpriteNode?
    var planeTimer: Timer?
    var planeOneTimer: Timer?
    var bulletTimer: Timer?
    var islandTimer: Timer?
    var cloudTimer: Timer?
    var cloudOneTimer: Timer?
    let playerCategory: UInt32 = 2
    let planeCategory: UInt32 = 4
    let bulletCategory: UInt32 = 16
    var score: Int = 0
    var scoreLabel: SKLabelNode?
    var heartOne: SKSpriteNode?
    var heartTwo: SKSpriteNode?
    var heartThree: SKSpriteNode?
    var heartFour: SKSpriteNode?
    var heartFive: SKSpriteNode?
    var count: Int = 0
    var possiblePlanes = ["enemy1", "enemy2", "enemy3"]
    
    override func sceneDidLoad() {
        
        physicsWorld.contactDelegate = self
        
        mainPlayer = childNode(withName: "player") as? SKSpriteNode
        mainPlayer?.size = CGSize(width: 160, height: 160)
        scoreLabel = childNode(withName: "score") as? SKLabelNode
        heartOne = childNode(withName: "heart1") as? SKSpriteNode
        heartTwo = childNode(withName: "heart2") as? SKSpriteNode
        heartThree = childNode(withName: "heart3") as? SKSpriteNode
        heartFour = childNode(withName: "heart4") as? SKSpriteNode
        heartFive = childNode(withName: "heart5") as? SKSpriteNode
        
        var mainPlayerPlane: [SKTexture] = []
        for i in 1...10 {
            mainPlayerPlane.append(SKTexture(imageNamed: "plane\(i)"))
        }
        
        mainPlayer?.run(SKAction.repeatForever(SKAction.animate(with: mainPlayerPlane, timePerFrame: 0.03)))
        mainPlayer?.physicsBody?.categoryBitMask = playerCategory
        mainPlayer?.physicsBody?.contactTestBitMask = planeCategory
        islandTimer = Timer.scheduledTimer(withTimeInterval: 2.2, repeats: true, block: {(timer) in self.createIsland()})
        cloudTimer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true, block: {(timer) in self.createCloud()})
        cloudOneTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: {(timer) in self.createCloudOne()})
        planeTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true, block: {(timer) in self.createPlane()})
        bulletTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: {(timer) in self.spawnBullets()})
    }
    
    //Create islands
    //
    func createIsland() {
        
        let island = SKSpriteNode(imageNamed: "island")
        addChild(island)
        island.size = CGSize(width: 300, height: 300)
        let highY = size.height/2 - island.size.height/2
        let lowY = -size.height/2 + island.size.height/2
        let range = highY - lowY
        let spawnHeight = highY - CGFloat(arc4random_uniform(UInt32(range)))
        island.position = CGPoint(x: spawnHeight , y: size.height/2 + island.size.height/2)
        island.zPosition = -2
        let moveDown = SKAction.moveBy(x: 0, y: -size.height - island.size.height, duration: 6.5)
        island.run(SKAction.sequence([moveDown, SKAction.removeFromParent()]))
    }
    
    //Create first layer of clouds
    //
    func createCloud() {
        
        let cloud = SKSpriteNode(imageNamed: "cloud")
        addChild(cloud)
        cloud.size = CGSize(width: 700, height: 350)
        let highY = size.height/2 - cloud.size.height/2
        let lowY = -size.height/2 + cloud.size.height/2
        let range = highY - lowY
        let spawnHeight = highY - CGFloat(arc4random_uniform(UInt32(range)))
        cloud.position = CGPoint(x: spawnHeight , y: size.height/2 + cloud.size.height/2)
        cloud.zPosition = -1
        cloud.alpha = 0.7
        let moveDown = SKAction.moveBy(x: 0, y: -size.height - cloud.size.height, duration: 5.5)
        cloud.run(SKAction.sequence([moveDown, SKAction.removeFromParent()]))
    }
    
    //Create second layer of clouds
    //
    func createCloudOne() {
        
        let cloudOne = SKSpriteNode(imageNamed: "cloud1")
        addChild(cloudOne)
        cloudOne.size = CGSize(width: 400, height: 200)
        let highY = size.height/2 - cloudOne.size.height/2
        let lowY = -size.height/2 + cloudOne.size.height/2
        let range = highY - lowY
        let spawnHeight = highY - CGFloat(arc4random_uniform(UInt32(range)))
        cloudOne.position = CGPoint(x: spawnHeight , y: size.height/2 + cloudOne.size.height/2)
        cloudOne.zPosition = -1
        cloudOne.alpha = 0.8
        let moveDown = SKAction.moveBy(x: 0, y: -size.height - cloudOne.size.height, duration: 6)
        cloudOne.run(SKAction.sequence([moveDown, SKAction.removeFromParent()]))
    }
    
    //Create planes
    //
    func createPlane() {
        possiblePlanes = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possiblePlanes) as! [String]
        let plane = SKSpriteNode(imageNamed: possiblePlanes[0])
        plane.size = CGSize(width: 140, height: 140)
        let highY = size.height/2 - plane.size.height/2
        let lowY = -size.height/2 + plane.size.height/2
        let range = highY - lowY
        let spawnHeight = highY - CGFloat(arc4random_uniform(UInt32(range)))
        plane.position = CGPoint(x: spawnHeight , y: size.height/2 + plane.size.height/2)
        let moveDown = SKAction.moveBy(x: 0, y: -size.height - plane.size.height, duration: 2.7)
        plane.run(SKAction.sequence([moveDown, SKAction.removeFromParent()]))
        plane.zPosition = 0
        plane.physicsBody = SKPhysicsBody(rectangleOf: plane.size)
        plane.physicsBody?.categoryBitMask = planeCategory
        plane.physicsBody?.contactTestBitMask = bulletCategory
        plane.physicsBody?.affectedByGravity = false
        plane.physicsBody?.isDynamic = true
        plane.physicsBody?.collisionBitMask = 0
        plane.physicsBody?.usesPreciseCollisionDetection = true
        self.addChild(plane)
    }
    
    //Create bullets function
    //
    func spawnBullets() {
        
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.size = CGSize(width: 15, height: 80)
        bullet.position = mainPlayer!.position
        bullet.position.y += 5
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width / 2)
        let action = SKAction.moveTo(y: self.size.height + 30, duration: 1.2)
        bullet.run(SKAction.sequence([action, SKAction.removeFromParent()]))
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody?.categoryBitMask = bulletCategory
        bullet.physicsBody?.contactTestBitMask = planeCategory
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        self.addChild(bullet)
    }
    
    //Explosion function
    //
    func explosion (first:SKSpriteNode, second:SKSpriteNode) {
       
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = second.position
        self.addChild(explosion)
        first.removeFromParent()
        second.removeFromParent()
        self.run(SKAction.wait(forDuration: 1)) {
        explosion.removeFromParent()
        }
    }
    
    func explosionOne (first:SKSpriteNode) {
       
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = first.position
        self.addChild(explosion)
        first.removeFromParent()
        self.run(SKAction.wait(forDuration: 1)) {
        explosion.removeFromParent()
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        //Plane contacts bullets
        //
        if (contact.bodyA.categoryBitMask & planeCategory) != 0 && (contact.bodyB.categoryBitMask & bulletCategory) != 0 {
            explosion(first: (contact.bodyB.node as! SKSpriteNode), second: (contact.bodyA.node as! SKSpriteNode))
            score += 1
        }
        
        if (contact.bodyA.categoryBitMask & bulletCategory) != 0 && (contact.bodyB.categoryBitMask & planeCategory) != 0 {
            explosion(first: (contact.bodyB.node as! SKSpriteNode), second: (contact.bodyA.node as! SKSpriteNode))
            score += 1
        }
     
        
        //Plane contacts player
        //
        if (contact.bodyA.categoryBitMask == planeCategory && contact.bodyB.categoryBitMask == playerCategory) {
            explosionOne(first: (contact.bodyA.node as! SKSpriteNode))
            count += 1
            gameOver()
        }
        
        if (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == planeCategory) {
            explosionOne(first: (contact.bodyB.node as! SKSpriteNode))
            count += 1
            gameOver()
        }
        
        scoreLabel?.text = "Score: \(score)"
    }
    
    func gameOver() {
        
        if count == 1 {
            heartFive?.removeFromParent()
        }
        else if count == 2 {
            heartFour?.removeFromParent()
        }
        else if count == 3 {
            heartThree?.removeFromParent()
        }
        else if count == 4 {
            heartTwo?.removeFromParent()
        }
        else if count == 5 {
            heartOne?.removeFromParent()
            saveScore()
            self.view?.presentScene(SKScene(fileNamed: "GameOverScene"))
        }
    }
    
    func saveScore() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let s1 = NSEntityDescription.insertNewObject(forEntityName: "Score", into: context)
        s1.setValue(score, forKey: "score")
        
        do {
            try context.save()
            print("Data saved successfully!!")
        }
        catch {
            print("Some error occured when storing the data!!")
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            let location = touch.location(in: self)
            mainPlayer?.position.x = location.x
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            let location = touch.location(in: self)
            mainPlayer?.position.x = location.x
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
}
