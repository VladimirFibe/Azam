import UIKit
import CoreData

class BudgetDetailViewController: UIViewController {
    private var persistentContainer: NSPersistentContainer
    private var fetchedResultController: NSFetchedResultsController<Transaction>!
    private var budgetCategory: BudgetCategory
    
    lazy var nameTextField: UITextField = {
        $0.placeholder = "Transaction name"
        $0.leftView = UIView(
            frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        $0.leftViewMode = .always
        $0.borderStyle = .roundedRect
        return $0
    }(UITextField())

    lazy var amountTextField: UITextField = {
        $0.placeholder = "Transaction amount"
        $0.leftView = UIView(
            frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        $0.leftViewMode = .always
        $0.borderStyle = .roundedRect
        return $0
    }(UITextField())
    
    lazy var tableView: UITableView = {
        $0.delegate = self
        $0.dataSource = self
        $0.register(UITableViewCell.self,
                    forCellReuseIdentifier: "TransactionTableViewCell")
        return $0
    }(UITableView())
    
    lazy var saveTransactionButton: UIButton = {
        var configuration = UIButton.Configuration.bordered()
        let button = UIButton(configuration: configuration)
        button.setTitle("Save Transaction", for: .normal)
        button.addTarget(self,
                         action: #selector(saveTransactionButtonPressed),
                         for: .primaryActionTriggered)
        return button
    }()
    
    lazy var errorMessageLabel: UILabel = {
        $0.textColor = .red
        $0.text = ""
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    lazy var amountLabel: UILabel = {
        $0.text = budgetCategory.amount.formatted()
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    lazy var transactionsTotalLabel: UILabel = {
        $0.text = "0.0"
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private func updateTransactionsTotal() {
        transactionsTotalLabel.text = budgetCategory.transactionsTotal.formatAsCurrency()
    }
    
    private func resetForm() {
        amountTextField.text = ""
        nameTextField.text = ""
        errorMessageLabel.text = ""
    }
    
    lazy var stackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = UIStackView.spacingUseSystem
        $0.isLayoutMarginsRelativeArrangement = true
        $0.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 0, leading: 20, bottom: 0, trailing: 20)
        return $0
    }(UIStackView(arrangedSubviews: [
        amountLabel,
        nameTextField,
        amountTextField,
        saveTransactionButton,
        errorMessageLabel,
        transactionsTotalLabel,
        tableView]))
    
    
    init(persistentContainer: NSPersistentContainer,
         budgetCategory: BudgetCategory) {
        self.persistentContainer = persistentContainer
        self.budgetCategory = budgetCategory
        let request = Transaction.fetchRequest()
        request.predicate = NSPredicate(format: "category = %@", budgetCategory)
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        super.init(nibName: nil, bundle: nil)
        fetchedResultController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch {
            errorMessageLabel.text = "Unable to fetch transactions."
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateTransactionsTotal()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        title = budgetCategory.name
        view.addSubview(stackView)
        stackView.setCustomSpacing(50, after: amountLabel)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func saveTransactionButtonPressed(_ sender: UIButton) {
        guard let name = nameTextField.text,
              let text = amountTextField.text,
              let amount = Double(text)
        else {
            errorMessageLabel.text = "Unable to save Transaction. Transaction name and amount is required."
            return }
        saveTransaction(name: name, amount: amount)
    }
    
    private func deleteTransaction(_ transaction: Transaction) {
        persistentContainer.viewContext.delete(transaction)
        do {
            try persistentContainer.viewContext.save()
        } catch {
            errorMessageLabel.text = "Unable to delete Transaction"
        }
    }
    
    private func saveTransaction(name: String, amount: Double) {
        let transaction = Transaction(context: persistentContainer.viewContext)
        transaction.name = name
        transaction.amount = amount
        transaction.dateCreated = Date()
        transaction.category = budgetCategory
        
        do {
            try persistentContainer.viewContext.save()
            resetForm()
        } catch {
            errorMessageLabel.text = "Unable to save transaction"
        }
        
    }
}

extension BudgetDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        (fetchedResultController.fetchedObjects ?? []).count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "TransactionTableViewCell",
            for: indexPath)
        let transaction = fetchedResultController.object(at: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = transaction.name
        content.secondaryText = transaction.amount.formatAsCurrency()
        cell.contentConfiguration = content
        return cell
    }
}

extension BudgetDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let transaction = fetchedResultController.object(at: indexPath)
            deleteTransaction(transaction)
        }
    }
}

extension BudgetDetailViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateTransactionsTotal()
        tableView.reloadData()
    }
}
