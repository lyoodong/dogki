import SwiftUI
import MessageUI
import Firebase

struct SettingView: View {
    @State private var isShowEmail: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    userSupportSection()
                    policySection()
                    InfoSection()
                }
                .navigationTitle("설정")
                .navigationBarTitleDisplayMode(.inline)
                
                Spacer()
                
                Text("© bdnm. All rights reserved.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 6)
            }
        }
        .sheet(isPresented: $isShowEmail) {
            SettingEmailView(frame: AppInfo.emailFrame)
        }
        .onAppear {
            let event = "appear_settingView"
            Analytics.logEvent(event, parameters: nil)
        }
    }
    
    private func userSupportSection() -> some View {
        Section("고객 지원") {
            ForEach(UserSupport.allCases) { item in
                rowContent(for: item.description, systemName: item.systemImage)
                    .onTapGesture {
                        onFeedbackTapGesture(for: item)
                        let event = "tap_\(item.rawValue)"
                        Analytics.logEvent(event, parameters: nil)
                    }
            }
        }
    }
    
    private func policySection() -> some View {
        Section("정책") {
            ForEach(Policy.allCases) { item in
                rowContent(for: item.description, systemName: item.systemImage)
                    .onTapGesture {
                        onPolicyTapGesture(for: item)
                        let event = "tap_\(item.rawValue)"
                        Analytics.logEvent(event, parameters: nil)
                    }
            }
        }
    }
    
    private func InfoSection() -> some View {
        Section("앱 정보") {
            ForEach(Info.allCases) { item in
                rowContent(for: item.description, text: AppInfo.appVersion ,systemName: item.systemImage)
                    .onTapGesture {
                        onAppInfoTapGesture(for: item)
                        let event = "tap_\(item.rawValue)"
                        Analytics.logEvent(event, parameters: nil)
                    }
            }
        }
    }
    
    @ViewBuilder
    private func rowContent(for title: String, text: String? = nil, systemName: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: systemName)
                .foregroundStyle(.blue)
            
            Text(title)
            
            Spacer()
            
            if let text = text {
                Text(text)
                    .foregroundStyle(.secondary)
            } else {
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }
    
    private func onFeedbackTapGesture(for item: UserSupport) {
        switch item {
        case .review:
            requestReview()
        case .email:
            requestEmail()
        }
    }
    
    private func onPolicyTapGesture(for item: Policy) {
        openSafari(for: item.url)
    }
    
    private func onAppInfoTapGesture(for item: Info) {
        switch item {
        case .version:
            openAppStore()
        }
    }
    
    private func openAppStore() {
        if let url = URL(string: ServiceURL.store) {
            UIApplication.shared.open(url)
        }
    }
    
    private func openSafari(for url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
    
    private func requestEmail() {
        if MFMailComposeViewController.canSendMail() {
            isShowEmail = true
        } else {
            openSafari(for: ServiceURL.openChat)
        }
    }
    
    private func requestReview() {
        if let url = URL(string: ServiceURL.storeReview) {
            UIApplication.shared.open(url)
        }
    }
}
