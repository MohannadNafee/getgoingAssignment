import UIKit
import MapKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var shopImageview: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    let radius = 5000
    var place: PlaceOfInterest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMap()
        if let id = place?.placeId {
            fetchDetail(placeId: id) { (detail) in
                DispatchQueue.main.async {
                    self.descriptionLabel.text = "\(detail.name)\nPh: \(detail.formatted_phone_number)\nWebsite: \(detail.website)"
                }
            }
        }
        if let photRef = place?.photoReference {
            // build image url from photo reference
            let urlString = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=500&photoreference=\(photRef)&key=\(Constants.apiKey)"
            // download and set image
            if let url = URL(string: urlString), let dataContents = try? Data(contentsOf: url), let src = UIImage(data: dataContents) {
                shopImageview.image = src
            }
        }
//        https://maps.googleapis.com/maps/api/place/photo?maxwidth=500&photoreference=CmRaAAAAjlwzTYbXRoLn_7MHKew_hrkvz1A8xzeJd6U63gfW_4DRCZsYwkre-qUizwZTm8ycH0JwrfW0-nue2frC7jSo2k8se7ZQaOAKlTqS72ASpixQmAHdv-tsuuDG0_-rO_CMEhA5b42_MSNfl-uGRHGhhGHqGhQ5_LnKF8LzarlNEWZwsxBgsh5Qcw&key=AIzaSyD2eysOOF0jIjDqYwrVOgQ9Bicgckr_1Qc
        
    }
    func setMap(){
        if let coordinate = place?.location?.coordinate {
            let annotation = MKPointAnnotation()
            annotation.title = place?.name
            annotation.coordinate = coordinate // set coordinate to annotation
            mapView.addAnnotation(annotation)
            //set region
            let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, CLLocationDistance(Double(radius) * 2.0), CLLocationDistance(Double(radius) * 2.0))
            mapView.setRegion(region, animated: true)
        }
    }
    func fetchDetail(placeId: String, completion: @escaping (_ detail: PlaceDetail) -> Void ){
        let urlString = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeId)&fields=formatted_phone_number,website,name&key=\(Constants.apiKey)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) {
            (data, response, err) in
            guard let data = data else { return }
            do {
                
                if  let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                    if let result = jsonObject!["result"] as? [String:Any] {
                        let jsonData = try? JSONSerialization.data(withJSONObject:result) // convert data to json
                        let detail  = try JSONDecoder().decode(PlaceDetail.self, from: jsonData!) // decode PlaceDetail
                        completion(detail)
                    }
                }
            } catch {
                print("Some error has been occured while processing API request!")
            }
            
            }.resume()
    }
}
extension DetailVC : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "reusePin")
        view.canShowCallout = true
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
        view.pinTintColor = UIColor.blue
        
        return view
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let launchingOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        if let coordinate = view.annotation?.coordinate {
            let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.openInMaps(launchOptions: launchingOptions)
        }
    }
}
