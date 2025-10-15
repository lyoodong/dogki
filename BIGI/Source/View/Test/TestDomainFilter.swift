import SwiftUI
import Firebase

struct TestFilter: View {
    @Binding var selectedDomains: Set<Domain>
    
    var body: some View {
        NavigationStack {
            list()
                .scrollDisabled(true)
                .listStyle(.insetGrouped)
                .navigationTitle("필터")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: refreshButton)
                .presentationDetents([.medium, .large])
        }
        .onAppear {
            let event = "appear_testFilter"
            Analytics.logEvent(event, parameters: nil)
        }
        .onDisappear {
            let event = "disappear_testFilter"
            let parameters: [String: Any] = [
                Domain.humanities.rawValue : selectedDomains.contains(.humanities),
                Domain.social.rawValue: selectedDomains.contains(.social),
                Domain.technology.rawValue: selectedDomains.contains(.technology),
                Domain.science.rawValue: selectedDomains.contains(.science),
                Domain.reading.rawValue: selectedDomains.contains(.reading),
                Domain.arts.rawValue: selectedDomains.contains(.arts)
            ]

            Analytics.logEvent(event, parameters: parameters)
        }
    }
    
    private func refreshButton() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                selectedDomains = Set(Domain.allCases)
                let event = "tap_refreshButton"
                Analytics.logEvent(event, parameters: nil)
            } label: {
                Image(systemName: "arrow.clockwise")
            }
        }
    }
    
    private func list() -> some View {
        List {
            Section("영역") {
                ForEach(Domain.allCases, id: \.self, content: rowContent)
            }
        }
    }
    
    private func rowContent(for domain: Domain) -> some View {
        HStack {
            Circle()
                .fill(domain.color.opacity(0.7))
                .frame(width: 16, height: 16)
            
            Text(domain.description)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            
            toggle(for: domain)
        }
    }
    
    private func toggle(for domain: Domain) -> some View {
        Toggle("", isOn: Binding(
            get: { selectedDomains.contains(domain) },
            set: { isOn in
                if isOn {
                    selectedDomains.insert(domain)
                } else {
                    selectedDomains.remove(domain)
                }
            }
        ))
    }
}
