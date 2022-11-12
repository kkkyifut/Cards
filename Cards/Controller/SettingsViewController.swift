import UIKit

class SettingsViewController: UIViewController {
    let keyRed = "keyRed"
    let keyGreen = "keyGreen"
    let keyBlue = "keyBlue"
    let keyAlpha = "keyAlpha"
    let userDefaults = UserDefaults.standard
    
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0

    lazy var colorBoard = getColor()
    var chosenDifficulty = ""
    var difficulties = ["Easy": 4, "Default": 8, "Hard": 16, "Hardcore": 32, "Extreme": 64]
    
    @IBOutlet weak var segmentGameDifficulty: UISegmentedControl!
    @IBOutlet weak var colorScene: UIColorWell?
    
    @IBAction func toPreviousScene(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func changeGameDifficulty(_ sender: AnyObject) {
        userDefaults.set(segmentGameDifficulty.selectedSegmentIndex, forKey: "chosenOption")
        chosenDifficulty = segmentGameDifficulty.titleForSegment(at: segmentGameDifficulty.selectedSegmentIndex)!
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        if let value = userDefaults.value(forKey: "chosenOption") {
            let selectedIndex = value as! Int
            segmentGameDifficulty.selectedSegmentIndex = selectedIndex
        }

        colorScene?.selectedColor = colorBoard
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        colorScene?.selectedColor?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        userDefaults.set(red, forKey: keyRed)
        userDefaults.set(green, forKey: keyGreen)
        userDefaults.set(blue, forKey: keyBlue)
        if alpha > 0.7 {
            alpha = 0.7
        }
        userDefaults.set(alpha, forKey: keyAlpha)
    }
    
    func getColor() -> UIColor {
        let keyRed = userDefaults.double(forKey: keyRed)
        let keyGreen = userDefaults.double(forKey: keyGreen)
        let keyBlue = userDefaults.double(forKey: keyBlue)
        let keyAlpha = userDefaults.double(forKey: keyAlpha)

        let color = UIColor(red: keyRed, green: keyGreen, blue: keyBlue, alpha: keyAlpha)
        
        return color
    }
}
