import UIKit

class CategoresTableViewController: UITableViewController {
    private var categories: [Category] = []
    private var client = StoreHTTPClient()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Categories"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        Task {
            await populateCategories()
            tableView.reloadData()
        }
    }

    private func populateCategories() async {
        do {
           categories = try await client.getAllCategories()
        } catch {
            
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        let category = categories[indexPath.row]
        var configuration = cell.defaultContentConfiguration()
        configuration.text = category.name
        if let url = URL(string: category.image) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        configuration.image = image
                        configuration.imageProperties.maximumSize = CGSize(width: 75, height: 75)
                        cell.contentConfiguration = configuration
                    }
                }
            }
        }
        return cell
    }
}

