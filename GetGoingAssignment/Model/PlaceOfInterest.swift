import CoreLocation
import Foundation

class PlaceOfInterest {
    var id: String
    var name: String
    var rating: Double = 0
    var formattedAddress: String?
    var icon: String?
    var placeId: String?
    var photoReference: String?
    var location: CLLocation?
    
    init?(json: [String: Any]){
        
        guard let id = json["id"] as? String else {
            return nil
            
        }
        self.id = id
        guard let name = json["name"] as? String else {
            return nil
            
        }
        self.name = name
        if let rating = json["rating"] as? Double {
            self.rating = rating
        } else {
            self.rating = 0
        }
        self.formattedAddress = json["formatted_address"] as? String
        self.icon = json["icon"] as? String
        self.placeId = json["place_id"] as? String
        
        if let photo = json["photos"] as? [[String: Any]] {
        
        self.photoReference = photo[0]["photo_reference"] as? String
        }
        
        if let geometry = json["geometry"] as? [String:AnyObject] {
            if let location = geometry["location"] as? [String:Double] {
                self.location = CLLocation(latitude: location["lat"]!, longitude: location["lng"]!) // initialize location
            }
        }

    }
}
