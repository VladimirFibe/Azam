import SwiftUI

final class AddProductViewController: UIViewController {
    lazy var titleTextField = UITextField().then {
        $0.placeholder = "Enter title"
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        $0.leftViewMode = .always
        $0.borderStyle = .roundedRect
    }
    
    lazy var priceTextField = UITextField().then {
        $0.placeholder = "Enter price"
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        $0.leftViewMode = .always
        $0.borderStyle = .roundedRect
        $0.keyboardType = .numberPad
    }
    
    lazy var imageURLTextField = UITextField().then {
        $0.placeholder = "Enter image URL"
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        $0.leftViewMode = .always
        $0.borderStyle = .roundedRect
    }
    
    lazy var descriptionTextView = UITextView().then {
        $0.contentInsetAdjustmentBehavior = .automatic
        $0.backgroundColor = .lightGray
    }
    
    var selectedCatergory: Category?
    
    lazy var categoryPickerView = CategoryPickerView { [weak self] category in
        print(category)
        self?.selectedCatergory = category
    }
    
    lazy var hostingController = UIHostingController(rootView: categoryPickerView)
    
    lazy var contentView = UIStackView(arrangedSubviews: [
        titleTextField,
        priceTextField,
        imageURLTextField,
        descriptionTextView,
        hostingController.view,
        UIView()]).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = UIStackView.spacingUseSystem
        $0.isLayoutMarginsRelativeArrangement = true
        $0.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        layoutViews()
        configureAppearance()
    }
}

struct AddProductViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> AddProductViewController {
        AddProductViewController()
    }
    
    func updateUIViewController(_ uiViewController: AddProductViewController, context: Context) {
        
    }
}

struct AddProductViewController_Previews: PreviewProvider {
    static var previews: some View {
        AddProductViewControllerRepresentable()
        .padding()
    }
}

extension AddProductViewController {
    func setupViews() {
        view.addSubview(contentView)
        addChild(hostingController)
        hostingController.didMove(toParent: self)
    }
    
    func layoutViews() {
        let margin = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: margin.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: margin.bottomAnchor),
            
            descriptionTextView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func configureAppearance() {
    }
}
