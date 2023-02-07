import UIKit
import MapKit

class PlacesTableViewController: UITableViewController {

    var userLocation: CLLocation
    var places: [PlaceAnnotation]
    
    private var indexForSelectedRow: Int? {
        self.places.firstIndex(where: { $0.isSelected })
    }
    
    init(userLocation: CLLocation, places: [PlaceAnnotation]) {
        self.userLocation = userLocation
        self.places = places
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PlaceCell")
        self.places.swapAt(indexForSelectedRow ?? 0, 0)
    }

    private func calculateDistance(from location1: CLLocation, to location2: CLLocation) -> CLLocationDistance {
        location1.distance(from: location2)
    }
    
    private func formatDistanceForDisplay(_ distance: CLLocationDistance) -> String {
        let meters = Measurement(value: distance, unit: UnitLength.meters)
        return meters.converted(to: .miles).formatted()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath)
        let place = places[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = place.name
        content.secondaryText = formatDistanceForDisplay(calculateDistance(from: userLocation, to: place.location))
//        content.directionalLayoutMargins.leading = -50
        cell.contentConfiguration = content
        cell.backgroundColor = place.isSelected ? .lightGray : .clear
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = places[indexPath.row]
        let controller = PlaceDetailViewController(place: place)
        present(controller, animated: true)
    }
}
