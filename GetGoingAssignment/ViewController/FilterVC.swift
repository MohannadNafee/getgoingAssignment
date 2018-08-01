import UIKit

class FilterVC: UIViewController {
    
    // set picker values
    var pickerComponents: [String] = ["5000","10000","15000","20000","25000","30000", "35000", "40000", "45000", "50000"]
    var radius = "25000"
    var delegate: FilterSettingsDelegate?
    var rank = Rank.prominence
    @IBOutlet weak var openNowSwitch: UISwitch!
    
    @IBOutlet weak var radiusPickerView: UIPickerView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        radiusPickerView.selectRow(4, inComponent: 0, animated: true)
    }
    // get rank
    @IBAction func rankSgChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            rank = Rank.prominence
        } else {
            rank = Rank.distance
        }
    }
    
    // apply filter action
    @IBAction func applyAction(_ sender: Any) {
        delegate?.getQueryItems(rank: rank, radius: radius, isOpenNow: openNowSwitch.isOn) // set query items
        navigationController?.popViewController(animated: true) // go back to main page
    }
}
// initiate radius pickerview
extension FilterVC: UIPickerViewDataSource , UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerComponents.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerComponents[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        radius = pickerComponents[row]
    }
}
