import UIKit

class SettingsViewController: UIViewController {
    var colorBoard = UIColor(red: 0.1, green: 0.9, blue: 0.7, alpha: 0.5)
    var chosenDifficulty = ""
    var difficulties = ["Easy": 4, "Default": 8, "Hard": 16, "Hardcore": 32, "Extreme": 64]
    
    @IBOutlet weak var segmentGameDifficulty: UISegmentedControl!
    @IBOutlet weak var colorScene: UIColorWell!
    
    @IBAction func toPreviousScene(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func changeGameDifficulty(_ sender: AnyObject) {
        UserDefaults.standard.set(segmentGameDifficulty.selectedSegmentIndex, forKey: "chosenOption")
        chosenDifficulty = segmentGameDifficulty.titleForSegment(at: segmentGameDifficulty.selectedSegmentIndex)!
        print(chosenDifficulty)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        if let value = UserDefaults.standard.value(forKey: "chosenOption") {
            let selectedIndex = value as! Int
            segmentGameDifficulty.selectedSegmentIndex = selectedIndex
        }
        colorScene.selectedColor = colorBoard
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let color = colorScene.selectedColor {
            colorBoard = color
        }
        print(chosenDifficulty)
    }
}
