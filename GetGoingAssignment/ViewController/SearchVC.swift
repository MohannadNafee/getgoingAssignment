import UIKit
import CoreLocation

class SearchVC: UIViewController {
    var textSearchQuery: TextSearchQuery?
    var locationSearchQuery: LocationSearchQuery?
    var currentLocation: CLLocation?
    
    @IBOutlet weak var searchSg: UISegmentedControl!
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
        if searchSg.selectedSegmentIndex == 0 {
            if let inputValue = searchTextField.text {
                textSearchQuery = TextSearchQuery(queryString: inputValue, rank: Rank.prominence, radius: "", isOpenNow: false)
                GooglePlaceAPI.searchByText(textQuery: textSearchQuery!, completionHandler: {(status, json) in
                    if let jsonObj = json {
                        let places = APIParser.parserAPIResponse(json: jsonObj)
                        // Dispatch date to main queue
                        DispatchQueue.main.async {
                            if places.count > 0 {
                                print("search count \(places.count)")
                                let s = self.storyboard?.instantiateViewController(withIdentifier: "ResultsVC") as! ResultsVC
                                s.allPlaces = places
                                self.navigationController?.pushViewController(s, animated: true)
                            } else {
                                self.generalAlert("Error", "No results found")
                            }
                        }
                    } else {
                        self.generalAlert("Error", "An errorparsing json")
                    }
                })
            } else {
                
                generalAlert("Error", "An error has occurred")
            }
        }
        else {
            guard let curLocation = currentLocation  else { return }
            locationSearchQuery = LocationSearchQuery(location: curLocation, rank: Rank.prominence, radius: "", isOpenNow: false)
            GooglePlaceAPI.searchByCoreLocation(locationQuery: locationSearchQuery!,  completionHandler: {(status, json) in
                if let jsonObj = json {
                    let places = APIParser.parserAPIResponse(json: jsonObj)
                    // Dispatch date to main queue
                    DispatchQueue.main.async {
                        if places.count > 0 {
                            print("search count \(places.count)")
                            let s = self.storyboard?.instantiateViewController(withIdentifier: "ResultsVC") as! ResultsVC
                            s.allPlaces = places
                            self.navigationController?.pushViewController(s, animated: true)
                        } else {
                            self.generalAlert("Something wrong", "No results found")
                        }
                    }
                } else {
                    self.generalAlert("Something Wrong", "An errorparsing json")
                }
            })
        }
    }
    // alert controller for showing error message
    func generalAlert(_ title: String,_ message: String?) {
        let alertController = UIAlertController(title:title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default) {(action)
            in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true) // present alert to user
    }
    
    // get current location when selected index changed
    @IBAction func searchSgChanged(_ sender: UISegmentedControl) {
        if searchSg.selectedSegmentIndex == 1 {
            LocationService.sharedInstane.delegate = self
            LocationService.sharedInstane.startUpdatingLocation()
        }
    }
}
extension SearchVC: LocationServiceDelegate {
    func tracingLocation(_ currentLocation: CLLocation) {
        self.currentLocation = currentLocation
    }
    func tracingLocationDidFailWithError(_error: Error) {
        generalAlert("Location Erro", "Error occurred while trying to get current location")
    }
}


