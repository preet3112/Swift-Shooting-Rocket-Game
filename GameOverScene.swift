import SpriteKit
import GameplayKit
import CoreData

class GameOverScene: SKScene {

    var gameOver: SKSpriteNode?
    var currentScoreLabel: SKLabelNode?
    var highestScoreLabel: SKLabelNode?
    var scoreList = [Int]()
    var highestscoreList = [Int]()
    
    override func sceneDidLoad() {
        
        gameOver = childNode(withName: "gameover") as? SKSpriteNode
        currentScoreLabel = childNode(withName: "final_score") as? SKLabelNode
        highestScoreLabel = childNode(withName: "highest_score") as? SKLabelNode
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let query = NSFetchRequest<NSFetchRequestResult>(entityName: "Score")
        query.returnsObjectsAsFaults = false;
        
        do {
            let results = try context.fetch(query)
            if (results.count > 0) {
                for row in results as! [NSManagedObject]{
                    if let score = row.value(forKey: "score") as? Int32 {
                        scoreList.append(Int(score))
                        currentScoreLabel?.text = "Current score: \(String(score))"
                    }
                }
            }
            else {
                print("Nothing is found!!")
            }
        }
        catch {
            print("Some error occured when fetching the data!!")
        }
        
        if scoreList.count == 1 {
            highestscoreList = scoreList.sorted(){ $0 > $1}
            self.highestScoreLabel?.numberOfLines = 0
            highestScoreLabel?.text = "High scores:\n1:\n2:\n3"
        }
        else if scoreList.count == 2 {
            highestscoreList = scoreList.sorted(){ $0 > $1}
            self.highestScoreLabel?.numberOfLines = 0
            highestScoreLabel?.text = "High scores:\n1: \(String(highestscoreList[0])) \n2: 0\n3: 0"
        }
        else if scoreList.count == 3 {
            highestscoreList = scoreList.sorted(){ $0 > $1}
            self.highestScoreLabel?.numberOfLines = 0
            highestScoreLabel?.text = "High scores:\n1: \(String(highestscoreList[0])) \n2: \(String(highestscoreList[1])) \n3: 0"
        }
        else if scoreList.count > 3 {
            highestscoreList = scoreList.sorted(){ $0 > $1}
            self.highestScoreLabel?.numberOfLines = 0
            highestScoreLabel?.text = "High scores:\n1: \(String(highestscoreList[0])) \n2: \(String(highestscoreList[1])) \n3: \(String(highestscoreList[2]))"
        }
    }
}
