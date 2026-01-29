import Foundation
import Combine

final class DashboardViewModel: ObservableObject {
    @Published private(set) var debts: [Debt] = []
    @Published private(set) var totalDebt: Double = 0
    @Published private(set) var monthlyPayment: Double = 0
    @Published private(set) var activeDebtsCount: Int = 0
    
    @Published var selectedDebt: Debt?
    @Published var showPaymentSheet: Bool = false
    @Published var paymentAmount: String = ""
    @Published var showPaymentSuccess: Bool = false
    
    private let repository: DebtRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: DebtRepositoryProtocol = DebtRepository.shared) {
        self.repository = repository
        setupBindings()
    }
    
    private func setupBindings() {
        repository.debtsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] debts in
                self?.debts = debts
                self?.calculateStats(from: debts)
            }
            .store(in: &cancellables)
    }
    
    private func calculateStats(from debts: [Debt]) {
        totalDebt = debts.reduce(0) { $0 + $1.amount }
        monthlyPayment = calculateMonthlyPayment(from: debts)
        activeDebtsCount = debts.count
    }
    
    private func calculateMonthlyPayment(from debts: [Debt]) -> Double {
        let calendar = Calendar.current
        let now = Date()
        
        return debts.reduce(0) { total, debt in
            let components = calendar.dateComponents([.month], from: now, to: debt.dueDate)
            let monthsRemaining = max(1, components.month ?? 1)
            let monthlyForDebt = debt.amount / Double(monthsRemaining)
            return total + monthlyForDebt
        }
    }
    
    var formattedTotalDebt: String {
        String(format: "$%.2f", totalDebt)
    }
    
    var formattedMonthlyPayment: String {
        String(format: "$%.2f", monthlyPayment)
    }
    
    var isEmpty: Bool {
        debts.isEmpty
    }
    
    func selectDebtForPayment(_ debt: Debt) {
        selectedDebt = debt
        paymentAmount = ""
        showPaymentSheet = true
    }
    
    func makePayment() {
        guard let debt = selectedDebt,
              let amount = Double(paymentAmount),
              amount > 0 else { return }
        
        repository.makePayment(debtId: debt.id, amount: amount)
        showPaymentSheet = false
        paymentAmount = ""
        selectedDebt = nil
        showPaymentSuccess = true
    }
    
    var isPaymentValid: Bool {
        guard let amount = Double(paymentAmount),
              let debt = selectedDebt else { return false }
        return amount > 0 && amount <= debt.amount
    }
}
