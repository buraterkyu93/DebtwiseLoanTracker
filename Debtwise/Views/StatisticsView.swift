import SwiftUI

struct StatisticsView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isEmpty {
                    EmptyStateView(
                        icon: "chart.pie.fill",
                        title: "No Statistics",
                        message: "Add debts to see your payment statistics and progress"
                    )
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            StatsSectionHeader(title: "Overview")
                            
                            ChartCard(
                                title: "Total Debt",
                                value: viewModel.formattedTotalDebt,
                                subtitle: "Outstanding balance"
                            )
                            
                            HStack(spacing: 12) {
                                SmallStatCard(
                                    title: "Active Debts",
                                    value: "\(viewModel.activeCount)",
                                    icon: "list.bullet",
                                    color: .blue
                                )
                                SmallStatCard(
                                    title: "Avg. Interest",
                                    value: viewModel.formattedAverageInterest,
                                    icon: "percent",
                                    color: .orange
                                )
                            }
                            
                            StatsSectionHeader(title: "Monthly Payments")
                            
                            ChartCard(
                                title: "Total Monthly Payment",
                                value: viewModel.formattedMonthlyPayment,
                                subtitle: "Required to pay on time"
                            )
                            
                            ChartCard(
                                title: "Average per Debt",
                                value: viewModel.formattedAveragePaymentPerDebt,
                                subtitle: "Monthly payment per loan"
                            )
                            
                            StatsSectionHeader(title: "Timeline")
                            
                            ChartCard(
                                title: "Debt-Free In",
                                value: viewModel.formattedMonthsUntilDebtFree,
                                subtitle: "Until all debts are paid"
                            )
                            
                            if let nearest = viewModel.nearestDueDate {
                                DebtHighlightCard(
                                    title: "Next Due Date",
                                    debt: nearest,
                                    subtitle: "Upcoming payment"
                                )
                            }
                            
                            StatsSectionHeader(title: "Debt Breakdown")
                            
                            if let largest = viewModel.largestDebt {
                                DebtHighlightCard(
                                    title: "Largest Debt",
                                    debt: largest,
                                    subtitle: "Highest balance"
                                )
                            }
                            
                            if let smallest = viewModel.smallestDebt, viewModel.activeCount > 1 {
                                DebtHighlightCard(
                                    title: "Smallest Debt",
                                    debt: smallest,
                                    subtitle: "Lowest balance"
                                )
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Statistics")
        }
    }
}

struct StatsSectionHeader: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding(.top, 8)
    }
}

struct SmallStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Spacer()
            }
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct DebtHighlightCard: View {
    let title: String
    let debt: Debt
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            
            HStack(spacing: 12) {
                Image(systemName: debt.type.icon)
                    .font(.title2)
                    .foregroundColor(debt.type.color)
                    .frame(width: 40, height: 40)
                    .background(debt.type.color.opacity(0.1))
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(debt.name)
                        .font(.body)
                        .fontWeight(.semibold)
                    Text("Due: \(debt.formattedDueDate)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(debt.formattedAmount)
                    .font(.title3)
                    .fontWeight(.bold)
            }
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
