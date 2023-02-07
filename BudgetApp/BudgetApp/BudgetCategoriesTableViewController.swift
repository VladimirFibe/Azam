import UIKit
import CoreData

class BudgetCategoriesTableViewController: UITableViewController {

    private var persistentContainer: NSPersistentContainer
    private var fetchedResultsController: NSFetchedResultsController<BudgetCategory>!
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        super.init(nibName: nil, bundle: nil)
        let request = BudgetCategory.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BudgetTableViewCell")
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ( fetchedResultsController.fetchedObjects ?? [] ).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetTableViewCell", for: indexPath)
        let budget = fetchedResultsController.object(at: indexPath)
        var configuration = cell.defaultContentConfiguration()
        configuration.text = budget.name
        cell.contentConfiguration = configuration
        return cell
    }
}

extension BudgetCategoriesTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
