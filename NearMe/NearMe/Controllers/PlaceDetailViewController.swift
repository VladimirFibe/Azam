import UIKit

final class PlaceDetailViewController: UIViewController {

    let place: PlaceAnnotation
    
    lazy var nameLabel: UILabel = {
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .left
        $0.font = UIFont.preferredFont(forTextStyle: .title1)
        return $0
    }(UILabel())
    
    lazy var addressLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .left
        $0.font = UIFont.preferredFont(forTextStyle: .body)
        $0.alpha = 0.4
        return $0
    }(UILabel())
    
    var directionsButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Directions", for: .normal)
        return button
    }()
    
    var callButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Call", for: .normal)
        return button
    }()
    
    init(place: PlaceAnnotation) {
        self.place = place
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = place.name
        view.backgroundColor = .systemBackground
    }
    
    @objc private func directionButtonTapped() {
        let coordinate = place.location.coordinate
        guard let url = URL(string: "http://maps.apple.com/?daddr=\(coordinate.latitude),\(coordinate.longitude)")
        else { return }
        UIApplication.shared.open(url)
    }
    
    @objc private func callButtonTapped() {
        guard let url = URL(string: "\(place.phone.formatPhoneForCall)") else { return }
        UIApplication.shared.open(url)
    }

    private func setupUI() {
        let buttonsStack = UIStackView(arrangedSubviews: [directionsButton, callButton])
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = UIStackView.spacingUseSystem
        
        directionsButton.addTarget(self, action: #selector(directionButtonTapped), for: .primaryActionTriggered)
        callButton.addTarget(self, action: #selector(callButtonTapped), for: .primaryActionTriggered)
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, addressLabel, buttonsStack])
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        nameLabel.text = place.name
        addressLabel.text = place.address
        view.addSubview(stackView)
    }
}
