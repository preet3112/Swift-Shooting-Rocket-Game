import UIKit
import CoreData

class ViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var Uid: UITextField!
    
    @IBOutlet weak var Password: UITextField!
    
    @IBAction func CreateAccountButtonAction(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "CreateViewController")
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "gameOverBG.png")!)

    }
    
    @IBAction func login_btn(_ sender: UIButton) {
        login()
    }
    
    func login() {
        
        if Uid.text! == "" || Password.text! == "" {
            let alert = UIAlertController(title: "Error!", message: "Please enter data", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else {
            fetchCoreData()
        }
    }
    
    func fetchCoreData() {
        
        var userID : String?
        var password : String?
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Score")
        request.predicate = NSPredicate(format: "userID like %@", Uid.text! )
        request.predicate = NSPredicate(format: "password like %@", Password.text! )
        request.returnsObjectsAsFaults = false

        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for row in results as! [NSManagedObject] {
                    if let uID = row.value(forKey: "userID") as? String {
                        userID = uID
                        print("User ID: " + userID!)
                    }
                    if let pass = row.value(forKey: "password") as? String {
                        password = pass
                        print("Password: " + password!)
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "GameViewController")
                    self.present(controller, animated: true, completion: nil)
                }
            }
            print("Result found: \(results.count)")
            if results.count == 0 {
                let alert = UIAlertController(title: "", message: "Incorrect Credientials", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
        catch {
            print("Error!")
            let alert = UIAlertController(title: "Account Not Fount", message: "Incorrect Credientials", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
