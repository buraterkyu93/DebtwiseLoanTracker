import SwiftUI

struct DebtRowView: View {
    let debt: Debt
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: debt.type.icon)
                .font(.title2)
                .foregroundColor(debt.type.color)
                .frame(width: 40, height: 40)
                .background(debt.type.color.opacity(0.1))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(debt.name)
                    .font(.headline)
                Text("Due: \(debt.formattedDueDate)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(debt.formattedAmount)
                    .font(.headline)
                Text(debt.formattedInterestRate)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
