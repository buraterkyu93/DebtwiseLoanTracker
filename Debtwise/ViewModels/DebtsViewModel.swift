import Foundation
import Combine

final class DebtsViewModel: ObservableObject {
    @Published private(set) var debts: [Debt] = []
    
    private let repository: DebtRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: DebtRepositoryProtocol = DebtRepository.shared) {
        self.repository = repository
        setupBindings()
    }
    
    private func setupBindings() {
        repository.debtsPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$debts)
    }
    
    func deleteDebt(at offsets: IndexSet) {
        repository.removeDebt(at: offsets)
    }
    
    var isEmpty: Bool {
        debts.isEmpty
    }
}
