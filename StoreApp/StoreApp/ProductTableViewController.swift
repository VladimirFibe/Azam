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
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        controller.delegate = self
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
        cell.accessoryType = .disclosureIndicator
        let product = products[indexPath.row]
        cell.contentConfiguration = UIHostingConfiguration {
            ProductCellView(product: product)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        let viewcontroller = ProductDetatilViewController(product: product)
        self.navigationController?.pushViewController(viewcontroller, animated: true)
    }
}

extension ProductTableViewController: AddProductViewControllerDelegate {
    func addProductViewControllerDidCancel(_ controller: AddProductViewController) {
        controller.dismiss(animated: true)
    }
    
    func addProductViewControllerDidSave(_ controller: AddProductViewController, with product: Product) {
        let createProductRequest = CreateProductRequest(product: product)
        Task {
            do {
                let result = try await client.createProduct(with: createProductRequest)
                products.insert(result, at: 0)
                tableView.reloadData()
                controller.dismiss(animated: true)
            } catch  { print("DEBUG: \(error.localizedDescription)")}
        }
    }
    
    
}
