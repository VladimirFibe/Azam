import CoreData

@objc(BudgetCategory)
public class BudgetCategory: NSManagedObject {
    var transactionsTotal: Double {
        let transactionsArray: [Transaction] = transactions?.toArray() ?? []
        return transactionsArray.reduce(0) { partialResult, transaction in
            partialResult + transaction.amount
        }
    }
    
    var remainigAmount: Double {
        amount - transactionsTotal
    }
}
