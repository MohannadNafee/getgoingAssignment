import Foundation

class APIParser {
    class func parserAPIResponse(json: [String: Any]) -> [PlaceOfInterest] {
        var places: [PlaceOfInterest] = []
        if let results = json["results"] as? [[String:Any]] {
            for result in results{
                if let newPlace = PlaceOfInterest(json: result){
                    places.append(newPlace)
                }
            }
        }
        return places
    }
}
