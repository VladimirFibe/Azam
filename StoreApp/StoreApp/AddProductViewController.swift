import SwiftUI

enum AddProductTextFieldType: Int {
    case title
    case price
    case imageUrl
}

struct AddProductFormState {
    var title = false
    var price = false
    var imageUrl = false
    var description = false
    var isValid: Bool {
        title && price && imageUrl && description
    }
}

protocol AddProductViewControllerDelegate {
    func addProductViewControllerDidCancel(_ controller: AddProductViewController)
    func addProductViewControllerDidSave(_ controller: AddProductViewController, with product: Product)
}

final class AddProductViewController: UIViewController {
    var addProductFormState = AddProductFormState()
    var delegate: AddProductViewControllerDelegate?
    lazy var titleTextField = UITextField().then {
        $0.placeholder = "Enter title"
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        $0.leftViewMode = .always
        $0.borderStyle = .roundedRect
        $0.tag = AddProductTextFieldType.title.rawValue
        $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    lazy var priceTextField = UITextField().then {
        $0.placeholder = "Enter price"
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        $0.leftViewMode = .always
        $0.borderStyle = .roundedRect
        $0.keyboardType = .numberPad
        $0.tag = AddProductTextFieldType.price.rawValue
        $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    lazy var imageURLTextField = UITextField().then {
        $0.placeholder = "Enter image URL"
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        $0.leftViewMode = .always
        $0.borderStyle = .roundedRect
        $0.tag = AddProductTextFieldType.imageUrl.rawValue
        $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    lazy var descriptionTextView = UITextView().then {
        $0.contentInsetAdjustmentBehavior = .automatic
        $0.backgroundColor = .lightGray
        $0.delegate = self
    }
    
    var selectedCatergory: Category?
    
    lazy var categoryPickerView = CategoryPickerView { [weak self] category in
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
    
    lazy var cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed))
    
    lazy var saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonPressed)).then {
        $0.isEnabled = false
    }
    
        
    @objc func saveButtonPressed(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text,
              let text = priceTextField.text,
              let price = Double(text),
              let imageUrl = imageURLTextField.text,
              let productImageUrl = URL(string: imageUrl),
              let category = selectedCatergory,
              let description = descriptionTextView.text
        else { return }
        let product = Product(id: nil, title: title, price: price, description: description, images: [productImageUrl], category: category)
        delegate?.addProductViewControllerDidSave(self, with: product)
    }
    
    @objc func cancelButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.addProductViewControllerDidCancel(self)
    }
    
    @objc func textFieldDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
        guard let type = AddProductTextFieldType(rawValue: sender.tag) else { return }
        switch type {
        case .title:
            addProductFormState.title = !text.isEmpty
        case .price:
            addProductFormState.price = Double(text) != nil
        case .imageUrl:
            addProductFormState.imageUrl = !text.isEmpty
        }
        saveBarButtonItem.isEnabled = addProductFormState.isValid
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        layoutViews()
        configureAppearance()
    }
}

struct AddProductViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        UINavigationController(rootViewController: AddProductViewController())
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
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
        title = "Add"
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = saveBarButtonItem
    }
}

extension AddProductViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        addProductFormState.description = !textView.text.isEmpty
        saveBarButtonItem.isEnabled = addProductFormState.isValid
    }
}
