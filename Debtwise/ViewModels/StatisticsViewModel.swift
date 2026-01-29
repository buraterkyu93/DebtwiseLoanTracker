import Foundation
import Combine

final class StatisticsViewModel: ObservableObject {
    @Published private(set) var debts: [Debt] = []
    @Published private(set) var totalDebt: Double = 0
    @Published private(set) var averageInterest: Double = 0
    @Published private(set) var activeCount: Int = 0
    @Published private(set) var monthlyPayment: Double = 0
    @Published private(set) var averagePaymentPerDebt: Double = 0
    @Published private(set) var monthsUntilDebtFree: Int = 0
    @Published private(set) var largestDebt: Debt?
    @Published private(set) var smallestDebt: Debt?
    @Published private(set) var nearestDueDate: Debt?
    
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
        activeCount = debts.count
        
        if !debts.isEmpty {
            averageInterest = debts.reduce(0) { $0 + $1.interestRate } / Double(debts.count)
            monthlyPayment = calculateMonthlyPayment(from: debts)
            averagePaymentPerDebt = monthlyPayment / Double(debts.count)
            monthsUntilDebtFree = calculateMonthsUntilDebtFree(from: debts)
            largestDebt = debts.max(by: { $0.amount < $1.amount })
            smallestDebt = debts.min(by: { $0.amount < $1.amount })
            nearestDueDate = debts.min(by: { $0.dueDate < $1.dueDate })
        } else {
            averageInterest = 0
            monthlyPayment = 0
            averagePaymentPerDebt = 0
            monthsUntilDebtFree = 0
            largestDebt = nil
            smallestDebt = nil
            nearestDueDate = nil
        }
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
    
    private func calculateMonthsUntilDebtFree(from debts: [Debt]) -> Int {
        guard !debts.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        let now = Date()
        
        var maxMonths = 0
        for debt in debts {
            let components = calendar.dateComponents([.month], from: now, to: debt.dueDate)
            let months = max(1, components.month ?? 1)
            maxMonths = max(maxMonths, months)
        }
        
        return maxMonths
    }
    
    var formattedTotalDebt: String {
        String(format: "$%.2f", totalDebt)
    }
    
    var formattedAverageInterest: String {
        String(format: "%.1f%%", averageInterest)
    }
    
    var formattedMonthlyPayment: String {
        String(format: "$%.2f", monthlyPayment)
    }
    
    var formattedAveragePaymentPerDebt: String {
        String(format: "$%.2f", averagePaymentPerDebt)
    }
    
    var formattedMonthsUntilDebtFree: String {
        if monthsUntilDebtFree == 1 {
            return "1 month"
        }
        return "\(monthsUntilDebtFree) months"
    }
    
    var isEmpty: Bool {
        debts.isEmpty
    }
}
