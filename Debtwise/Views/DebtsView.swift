import SwiftUI

struct DebtsView: View {
    @StateObject private var viewModel = DebtsViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isEmpty {
                    EmptyStateView(
                        icon: "list.bullet.rectangle",
                        title: "No Debts",
                        message: "You haven't added any debts yet. Tap the Add tab to get started."
                    )
                } else {
                    List {
                        ForEach(viewModel.debts) { debt in
                            DebtRowView(debt: debt)
                        }
                        .onDelete { offsets in
                            viewModel.deleteDebt(at: offsets)
                        }
                    }
                }
            }
            .navigationTitle("My Debts")
        }
    }
}
