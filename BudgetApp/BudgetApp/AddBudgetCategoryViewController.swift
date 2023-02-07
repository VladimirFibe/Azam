import UIKit
import CoreData
class AddBudgetCategoryViewController: UIViewController {

    private var persistantContainer: NSPersistentContainer
    
    lazy var nameTextField: UITextField = {
        $0.placeholder = "Budget name"
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        $0.leftViewMode = .always
        $0.borderStyle = .roundedRect
        return $0
    }(UITextField())
    
    lazy var amountTextField: UITextField = {
        $0.placeholder = "Budget amount"
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        $0.leftViewMode = .always
        $0.borderStyle = .roundedRect
        return $0
    }(UITextField())
    
    lazy var addBudgetButton: UIButton = {
        var configuration = UIButton.Configuration.bordered()
        let button = UIButton(configuration: configuration)
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(addBudgetButtonPressed), for: .primaryActionTriggered)
        return button
    }()
    
    lazy var errorMessageLabel: UILabel = {
        $0.textColor = .red
        $0.text = ""
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    lazy var stackView: UIStackView = {
        $0.alignment = .fill
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = UIStackView.spacingUseSystem
        $0.isLayoutMarginsRelativeArrangement = true
        $0.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        return $0
    }(UIStackView(arrangedSubviews: [nameTextField, amountTextField, addBudgetButton, errorMessageLabel]))
    
    init(persistantContainer: NSPersistentContainer ) {
        self.persistantContainer = persistantContainer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(stackView)
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Add Budget"
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func addBudgetButtonPressed(_ sender: UIButton) {
        
    }
}
