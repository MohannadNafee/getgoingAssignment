import UIKit

protocol FilterSettingsDelegate {
    func getQueryItems(rank: Rank,radius: String, isOpenNow: Bool)
}
