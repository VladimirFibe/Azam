import UIKit
import CoreData

class BudgetCategoriesTableViewController: UITableViewController {

    private var persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
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
        let addBudgetCategoryButton = UIBarButtonItem(
            title: "Add Category",
            style: .done,
            target: self,
            action: #selector(showAddBudgetCategory))
        self.navigationItem.rightBarButtonItem = addBudgetCategoryButton
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Budget"
    }

    @objc func showAddBudgetCategory(_ sender: UIBarButtonItem) {
        let viewController = UINavigationController(
            rootViewController: AddBudgetCategoryViewController(persistantContainer: persistentContainer))
        present(viewController, animated: true)
    }
    
    
}


