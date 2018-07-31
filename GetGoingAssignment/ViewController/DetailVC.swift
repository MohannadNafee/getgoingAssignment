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
        
        if let id = place?.placeId {
            fetchDetail(placeId: id) { (detail) in
                self.descriptionLabel.text = "\(detail.name)\nPh: \(detail.formatted_phone_number)\nWebsite: \(detail.website)"
            }
        }
        setMapViewCoordinate()
    }
    func setMapViewCoordinate(){
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
