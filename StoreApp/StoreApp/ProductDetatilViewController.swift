import SwiftUI

class ProductDetatilViewController: UIViewController {

    let product: Product
    
    lazy var descriptionLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    
    lazy var priceLabel = UILabel()
    
    lazy var deleteProductButton = UIButton(type: .system).then {
        $0.setTitle("Delete", for: .normal)
    }
    
    lazy var loadingIndicatorView = UIActivityIndicatorView().then {
        $0.style = .large
    }
    
    lazy var contentView = UIStackView(arrangedSubviews: [loadingIndicatorView, descriptionLabel, priceLabel, deleteProductButton, UIView()]).then {
        $0.axis = .vertical
    }
    
    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var button: UIButton = {
        $0.setTitle("Try Again", for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(buttonTapped), for: .primaryActionTriggered)
        return $0
    }(UIButton(type: .system))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        layoutViews()
        configureAppearance()
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension ProductDetatilViewController {
    func setupViews() {
        view.addSubview(contentView)
        Task {
            loadingIndicatorView.startAnimating()
            var images: [UIImage] = []
            for imageURL in (product.images ?? []) {
                guard let downloadedImage = await ImageLoader.load(url: imageURL) else { return }
                images.append(downloadedImage)
            }
            let productImageListVC = UIHostingController(rootView: ProuductImageListView(images: images))
            guard let productImageListView = productImageListVC.view else { return }
            contentView.insertArrangedSubview(productImageListView, at: 0)
            addChild(productImageListVC)
            productImageListVC.didMove(toParent: self)
            loadingIndicatorView.stopAnimating()
        }
    }
    
    func layoutViews() {
        let margin = view.layoutMarginsGuide
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: margin.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: margin.bottomAnchor)
        ])
    }
    
    func configureAppearance() {
        view.backgroundColor = .systemBackground
        title = product.title
        descriptionLabel.text = product.description
        priceLabel.text = product.price.formatAsCurrency()
        
    }
}
