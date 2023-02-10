//
//  BudgetTableViewCellReapresentable.swift
//  BudgetApp
//
//  Created by Vladimir Fibe on 2/9/23.
//

import SwiftUI

struct BudgetTableViewCellReapresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> BudgetTableViewCell {
        BudgetTableViewCell(style: .default, reuseIdentifier: "Cell")
    }
    func updateUIView(_ uiView: BudgetTableViewCell, context: Context) {
        
    }
}

