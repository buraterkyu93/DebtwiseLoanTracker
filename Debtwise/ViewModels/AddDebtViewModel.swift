import Foundation
import Combine

final class AddDebtViewModel: ObservableObject {
    @Published var debtName: String = ""
    @Published var amount: String = ""
    @Published var interestRate: String = ""
    @Published var selectedType: DebtType = .creditCard
    @Published var dueDate: Date = Date()
    @Published var showAlert: Bool = false
    
    private let repository: DebtRepositoryProtocol
    
    init(repository: DebtRepositoryProtocol = DebtRepository.shared) {
        self.repository = repository
    }
    
    var isFormValid: Bool {
        !debtName.isEmpty && !amount.isEmpty && Double(amount) != nil
    }
    
    func saveDebt() {
        guard let amountValue = Double(amount) else { return }
        let interestValue = Double(interestRate) ?? 0.0
        
        let newDebt = Debt(
            name: debtName,
            amount: amountValue,
            interestRate: interestValue,
            dueDate: dueDate,
            type: selectedType
        )
        
        repository.addDebt(newDebt)
        showAlert = true
    }
    
    func resetForm() {
        debtName = ""
        amount = ""
        interestRate = ""
        selectedType = .creditCard
        dueDate = Date()
    }
}
