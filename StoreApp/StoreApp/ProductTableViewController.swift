import SwiftUI

class ProductTableViewController: UITableViewController {

    private var category: Category
    private var client = StoreHTTPClient()
    private var products: [Product] = []
    
    lazy var addProductBarItemButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addProductButtonPressed))
    override func viewDidLoad() {
        super.viewDidLoad()
        title = category.name
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProductCell")
        navigationItem.rightBarButtonItem = addProductBarItemButton
        Task {
            await populateProducts()
        }
    }

    init(category: Category) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addProductButtonPressed(_ sender: UIBarButtonItem) {
        let controller = AddProductViewController()
        present(UINavigationController(rootViewController: controller), animated: true)
    }
    private func populateProducts() async {
        do {
            products = try await client.getProductsByCategory(categoryId: category.id)
            tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath)
        let product = products[indexPath.row]
        cell.contentConfiguration = UIHostingConfiguration {
            ProductCellView(product: product)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewcontroller = ProductDetatilViewController()
        self.navigationController?.pushViewController(viewcontroller, animated: true)
    }
}
