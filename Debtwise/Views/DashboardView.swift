import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isEmpty {
                    EmptyStateView(
                        icon: "chart.bar.fill",
                        title: "No Data Yet",
                        message: "Add your first debt to see the overview"
                    )
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            SummaryCard(
                                title: "Total Debt",
                                amount: viewModel.formattedTotalDebt,
                                color: .red
                            )
                            SummaryCard(
                                title: "Monthly Payment",
                                amount: viewModel.formattedMonthlyPayment,
                                color: .blue
                            )
                            SummaryCard(
                                title: "Active Debts",
                                amount: "\(viewModel.activeDebtsCount)",
                                color: .green
                            )
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Make a Payment")
                                    .font(.headline)
                                    .padding(.horizontal)
                                
                                ForEach(viewModel.debts) { debt in
                                    PaymentDebtRow(debt: debt) {
                                        viewModel.selectDebtForPayment(debt)
                                    }
                                }
                            }
                            .padding(.top, 10)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Overview")
            .sheet(isPresented: $viewModel.showPaymentSheet) {
                PaymentSheet(viewModel: viewModel)
            }
            .alert("Payment Successful", isPresented: $viewModel.showPaymentSuccess) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Your payment has been recorded.")
            }
        }
    }
}

struct PaymentDebtRow: View {
    let debt: Debt
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: debt.type.icon)
                    .font(.title3)
                    .foregroundColor(debt.type.color)
                    .frame(width: 36, height: 36)
                    .background(debt.type.color.opacity(0.1))
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(debt.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    Text("Due: \(debt.formattedDueDate)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(debt.formattedAmount)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

struct PaymentSheet: View {
    @ObservedObject var viewModel: DashboardViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                if let debt = viewModel.selectedDebt {
                    Section("Debt Details") {
                        HStack {
                            Text("Name")
                            Spacer()
                            Text(debt.name)
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            Text("Current Balance")
                            Spacer()
                            Text(debt.formattedAmount)
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            Text("Interest Rate")
                            Spacer()
                            Text(debt.formattedInterestRate)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Section("Payment Amount") {
                        TextField("Enter amount", text: $viewModel.paymentAmount)
                            .keyboardType(.decimalPad)
                        
                        if let amount = Double(viewModel.paymentAmount), amount > debt.amount {
                            Text("Amount exceeds current balance")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    
                    Section {
                        Button(action: {
                            viewModel.makePayment()
                        }) {
                            HStack {
                                Spacer()
                                Text("Submit Payment")
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                        }
                        .disabled(!viewModel.isPaymentValid)
                    }
                }
            }
            .navigationTitle("Make Payment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
