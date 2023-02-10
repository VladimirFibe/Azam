import SwiftUI

class BudgetTableViewCell: UITableViewCell {

    lazy var nameLabel: UILabel = {
        $0.text = "Hi"
       return $0
    }(UILabel())
    
    lazy var amountLabel: UILabel = {
        $0.text = "500.0"
       return $0
    }(UILabel())
    
    lazy var remainingLabel: UILabel = {
        $0.text = "25.0"
        $0.font = .systemFont(ofSize: 14)
        $0.alpha = 0.5
       return $0
    }(UILabel())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ budget: BudgetCategory) {
        nameLabel.text = budget.name
        amountLabel.text = budget.amount.formatAsCurrency()
        remainingLabel.text = budget.remainigAmount.formatAsCurrency()
    }
    
    private func setupUI() {
        
        let vStackView = UIStackView(arrangedSubviews: [amountLabel, remainingLabel])
        vStackView.alignment = .trailing
        vStackView.axis = .vertical
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, vStackView])
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 44)
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
            contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
}

struct BudgetTableViewCellReapresentable_Previews: PreviewProvider {
    static var previews: some View {
        BudgetTableViewCellReapresentable()
    }
}
