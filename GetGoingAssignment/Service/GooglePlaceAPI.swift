import Foundation

class GooglePlaceAPI {
    
    static let radiusString = "radius"
    static let isOpenString = "opennow"
    static let nearbySearchApiString = "/maps/api/place/nearbysearch/json"
    
    // get location date based on search String
    class func searchByText(textQuery: TextSearchQuery, completionHandler: @escaping ( _ statusCode: Int, _ json: [String: Any]?) -> Void) {
        // initialize url components
        var urlComp = URLComponents()
        urlComp.scheme = Constants.scheme
        urlComp.host = Constants.host
        urlComp.path = Constants.textPlaceSearch
        urlComp.queryItems = [
            URLQueryItem(name: "query", value: textQuery.queryString),
            URLQueryItem(name: "key", value: Constants.apiKey),
        ]
        if textQuery.rank != Rank.prominence  {
            urlComp.queryItems?.append(URLQueryItem(name: radiusString, value: textQuery.radius))
        }
        if textQuery.isOpenNow {
            urlComp.queryItems?.append(URLQueryItem(name: isOpenString, value: "\(textQuery.isOpenNow)"))
        }
        NetworkingLayer.getRequest(with: urlComp) { (statusCode, data) in
            if let jsonData = data, let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] {
                completionHandler(statusCode, jsonObject)
            } else {
                completionHandler(statusCode, nil)
            }
        }
    }
    // get location date based on coordinate
    class func searchByCoreLocation(locationQuery: LocationSearchQuery, completionHandler: @escaping(_ statusCode: Int, _ json: [String: Any]?) -> Void){
        // initialize url components
        var urlComp = URLComponents()
        urlComp.scheme = Constants.scheme
        urlComp.host = Constants.host
        urlComp.path = nearbySearchApiString
        
        urlComp.queryItems = [
            URLQueryItem(name: "location", value: "\(locationQuery.location.coordinate.latitude),\(locationQuery.location.coordinate.longitude)"),
            URLQueryItem(name: "key", value: Constants.apiKey)
        ]
        // check if rank is distance otherwise set radius to default 1000 value
        if locationQuery.rank == Rank.distance {
            urlComp.queryItems?.append(URLQueryItem(name: radiusString, value: locationQuery.radius))
        } else {
            urlComp.queryItems?.append(URLQueryItem(name: "radius", value: "1000"))
        }
        if locationQuery.isOpenNow {
            urlComp.queryItems?.append(URLQueryItem(name: isOpenString, value: "\(locationQuery.isOpenNow)"))
        }
        
        NetworkingLayer.getRequest(with: urlComp) { (statusCode, data) in
            if let jsonData = data,
                let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] {
                completionHandler(statusCode, jsonObject)
            } else {
                completionHandler(statusCode, nil)
            }
        }
        
    }
}
