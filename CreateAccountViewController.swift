import UIKit
import CoreData

class CreateAccountViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var CreateUid: UITextField!
    
    @IBOutlet weak var Password: UITextField!
    
    @IBAction func CreateButtonAction(_ sender: Any) {
        createAccount()
    }
    
    @IBAction func backButton(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ViewController")
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "gameOverBG.png")!)
        
    }
    
    func createAccount() {
        
        if CreateUid.text! == "" || Password.text! == "" {
            let alert = UIAlertController(title: "Please enter data", message: "Enter a valid user ID or Password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else {
            checkDB()
        }
    }
    
    func createAccInDB() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let s1 = NSEntityDescription.insertNewObject(forEntityName: "Score", into: context)
        s1.setValue((String(CreateUid.text!)), forKey: "userID")
        s1.setValue((String(Password.text!)), forKey: "password")
        
        do {
            try context.save()
            let alert = UIAlertController(title: "Account created", message: "Click continue to play the game", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {action in self.jump()}))
            self.present(alert, animated: true)
            print("Data saved successfully!!")
        }
        catch {
            print("Some error occured when storing the data!!")
        }
    }
    
    func jump() {
        fetchCoreData()
    }
    
    func checkDB() {
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Score")
        request.predicate = NSPredicate(format: "userID like %@", CreateUid.text! )
        request.returnsObjectsAsFaults = false

        do {
            let results = try context.fetch(request)

            if results.count > 0 {
                let alert = UIAlertController(title: "Account ID", message: "Already Taken", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                self.CreateUid.text = ""
                self.Password.text = ""
            }
            else{
                createAccInDB()
            }
        }
        catch {
            print("Error!")
        }
    }
    
    func fetchCoreData() {
        
        var userCID : String?
        var password : String?
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Score")
        request.predicate = NSPredicate(format: "userID like %@", CreateUid.text! )
        request.predicate = NSPredicate(format: "password like %@", Password.text! )
        request.returnsObjectsAsFaults = false

        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for row in results as! [NSManagedObject] {
                    if let uID = row.value(forKey: "userID") as? String {
                        userCID = uID
                        print(userCID!)
                    }
                    if let pass = row.value(forKey: "password") as? String {
                        password = pass
                        print(password!)
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "GameViewController")
                self.present(controller, animated: true, completion: nil)
            }
        }
        catch {
            print("Error!")
        }
    }
}
