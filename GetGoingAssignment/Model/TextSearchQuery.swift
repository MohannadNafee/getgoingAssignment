import UIKit
import CoreLocation

struct TextSearchQuery {
    var queryString: String
    var rank: Rank
    var radius: String
    var isOpenNow: Bool
}
struct LocationSearchQuery {
    var location: CLLocation
    var rank: Rank
    var radius: String
    var isOpenNow: Bool
}
