import SwiftUI

struct AddDebtView: View {
    @StateObject private var viewModel = AddDebtViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section("Debt Information") {
                    TextField("Debt Name", text: $viewModel.debtName)
                    TextField("Amount", text: $viewModel.amount)
                        .keyboardType(.decimalPad)
                    TextField("Interest Rate (%)", text: $viewModel.interestRate)
                        .keyboardType(.decimalPad)
                }
                
                Section("Type") {
                    Picker("Debt Type", selection: $viewModel.selectedType) {
                        ForEach(DebtType.allCases, id: \.self) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                }
                
                Section("Due Date") {
                    DatePicker("Select Date", selection: $viewModel.dueDate, displayedComponents: .date)
                }
                
                Section {
                    Button(action: {
                        hideKeyboard()
                        viewModel.saveDebt()
                    }) {
                        HStack {
                            Spacer()
                            Text("Add Debt")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .disabled(!viewModel.isFormValid)
                }
            }
            .navigationTitle("Add Debt")
            .scrollDismissesKeyboard(.interactively)
            .alert("Debt Added", isPresented: $viewModel.showAlert) {
                Button("OK") {
                    viewModel.resetForm()
                }
            } message: {
                Text("Your debt has been successfully added.")
            }
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
