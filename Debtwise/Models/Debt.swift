import SwiftUI

struct Debt: Identifiable, Codable {
    let id: UUID
    let name: String
    let amount: Double
    let interestRate: Double
    let dueDate: Date
    let type: DebtType
    
    init(id: UUID = UUID(), name: String, amount: Double, interestRate: Double, dueDate: Date, type: DebtType) {
        self.id = id
        self.name = name
        self.amount = amount
        self.interestRate = interestRate
        self.dueDate = dueDate
        self.type = type
    }
    
    var formattedDueDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: dueDate)
    }
    
    var formattedAmount: String {
        String(format: "$%.2f", amount)
    }
    
    var formattedInterestRate: String {
        String(format: "%.1f%% APR", interestRate)
    }
}

enum DebtType: String, Codable, CaseIterable {
    case creditCard
    case personalLoan
    case mortgage
    case carLoan
    
    var icon: String {
        switch self {
        case .creditCard: return "creditcard.fill"
        case .personalLoan: return "person.fill"
        case .mortgage: return "house.fill"
        case .carLoan: return "car.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .creditCard: return .blue
        case .personalLoan: return .green
        case .mortgage: return .purple
        case .carLoan: return .orange
        }
    }
    
    var displayName: String {
        switch self {
        case .creditCard: return "Credit Card"
        case .personalLoan: return "Personal Loan"
        case .mortgage: return "Mortgage"
        case .carLoan: return "Car Loan"
        }
    }
}
