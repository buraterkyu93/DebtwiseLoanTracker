import Foundation
import Combine
import SwiftUI

protocol DebtRepositoryProtocol {
    var debts: [Debt] { get }
    var debtsPublisher: Published<[Debt]>.Publisher { get }
    func addDebt(_ debt: Debt)
    func removeDebt(at offsets: IndexSet)
    func updateDebt(_ debt: Debt)
    func makePayment(debtId: UUID, amount: Double)
    func clearAll()
}

final class DebtRepository: ObservableObject, DebtRepositoryProtocol {
    static let shared = DebtRepository()
    
    @Published private(set) var debts: [Debt] = []
    var debtsPublisher: Published<[Debt]>.Publisher { $debts }
    
    private let debtsKey = "savedDebts"
    
    private init() {
        loadDebts()
    }
    
    func addDebt(_ debt: Debt) {
        debts.append(debt)
        saveDebts()
    }
    
    func removeDebt(at offsets: IndexSet) {
        debts.remove(atOffsets: offsets)
        saveDebts()
    }
    
    func updateDebt(_ debt: Debt) {
        if let index = debts.firstIndex(where: { $0.id == debt.id }) {
            debts[index] = debt
            saveDebts()
        }
    }
    
    func makePayment(debtId: UUID, amount: Double) {
        if let index = debts.firstIndex(where: { $0.id == debtId }) {
            let oldDebt = debts[index]
            let newAmount = max(0, oldDebt.amount - amount)
            
            if newAmount == 0 {
                debts.remove(at: index)
            } else {
                let updatedDebt = Debt(
                    id: oldDebt.id,
                    name: oldDebt.name,
                    amount: newAmount,
                    interestRate: oldDebt.interestRate,
                    dueDate: oldDebt.dueDate,
                    type: oldDebt.type
                )
                debts[index] = updatedDebt
            }
            saveDebts()
        }
    }
    
    func clearAll() {
        debts.removeAll()
        saveDebts()
    }
    
    private func saveDebts() {
        if let encoded = try? JSONEncoder().encode(debts) {
            UserDefaults.standard.set(encoded, forKey: debtsKey)
        }
    }
    
    private func loadDebts() {
        if let data = UserDefaults.standard.data(forKey: debtsKey),
           let decoded = try? JSONDecoder().decode([Debt].self, from: data) {
            debts = decoded
        }
    }
}
