import UIKit

class ResultsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBAction func sortSgChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            allPlaces = allPlaces.sorted { $0.name < $1.name }
        } else {
            allPlaces = allPlaces.sorted { $0.rating < $1.rating }
        }
        tableView.reloadData()
    }
    
    @IBOutlet weak var tableView: UITableView!
    let identifier = "PlaceTableViewCell"
    var allPlaces: [PlaceOfInterest] = []
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPlaces.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! PlaceTableViewCell
        cell.titleLabel.text = allPlaces[indexPath.row].name
        if let imageUrl = allPlaces[indexPath.row].icon, let url = URL(string: imageUrl), let dataContents = try? Data(contentsOf: url), let src = UIImage(data: dataContents) {
            cell.shopImageView.image = src
            
        }
        cell.addressLabel.text = allPlaces[indexPath.row].formattedAddress
        
        cell.ratingLabel.text = "\(getStar(rating: allPlaces[indexPath.row].rating))"
        
        return cell
    }
    // show details by clicking row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let s = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        s.place = allPlaces[indexPath.row]
        self.navigationController?.pushViewController(s, animated: true)
    }
    // set star based on rating
    func getStar(rating: Double) -> String {
        let noStar = "☆ ☆ ☆ ☆ ☆"
        let star1 = "☆ ☆ ☆ ☆ ★"
        let star2 = "☆ ☆ ☆ ★ ★"
        let star3 = "☆ ☆ ★ ★ ★"
        let star4 = "☆ ★ ★ ★ ★"
        let star5 = "★ ★ ★ ★ ★"
        switch rating {
        case 0:
            return noStar
        case 1:
            return star1
        case 2:
            return star2
        case 3:
            return star3
        case 4:
            return star4
        default:
            return star5
        }
    }
}
