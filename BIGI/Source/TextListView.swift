import SwiftUI

struct TextListView: View {
    @State private var items = [
        Item(title: "(가) 음악에 대한 <여씨춘추>의 견해 / (나) 조성 음악과 무조 음악",
             year: 2022, month: .june, domains: [.reading]),
        
        Item(title: "사회적 연결망의 변화",
             year: 2023, month: .september, domains: [.social]),
        
        Item(title: "기술 발전과 인간의 역할",
             year: 2021, month: .november, domains: [.technology, .science]),
        
        Item(title: "예술의 자율성과 표현",
             year: 2024, month: .june, domains: [.arts]),
        
        Item(title: "인문학과 과학의 만남",
             year: 2023, month: .june, domains: [.humanities, .science]),
        
        Item(title: "독서의 본질과 기능",
             year: 2020, month: .november, domains: [.reading]),
        
        Item(title: "사회 제도의 변화와 인간",
             year: 2019, month: .september, domains: [.social]),
        
        Item(title: "인공지능과 인간의 사고",
             year: 2022, month: .september, domains: [.technology]),
        
        Item(title: "예술과 철학의 대화",
             year: 2021, month: .june, domains: [.arts, .humanities]),
        
        Item(title: "과학적 탐구의 과정",
             year: 2020, month: .june, domains: [.science]),
        
        Item(title: "기술 문명의 윤리적 문제",
             year: 2024, month: .june, domains: [.technology]),
        
        Item(title: "사회적 연대의 의미",
             year: 2022, month: .november, domains: [.social, .humanities]),
        
        Item(title: "독서의 방법과 태도",
             year: 2023, month: .june, domains: [.reading]),
        
        Item(title: "예술의 감상과 해석",
             year: 2021, month: .november, domains: [.arts]),
        
        Item(title: "과학 기술의 발전과 환경 문제",
             year: 2023, month: .november, domains: [.science, .technology])
    ]

    var body: some View {
        NavigationStack {
            List(items, id: \.id, rowContent: rowContent)
                .listStyle(.plain)
                .navigationTitle("기출 문제")
        }
    }
    
    private func rowContent(_ item: Item) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            subHeadLine(item)
            headLine(item)
        }
    }
    
    private func subHeadLine(_ item: Item) -> some View {
        HStack {
            subTitle(item.subtitle)
            domains(item.domains)
        }
    }
    
    private func subTitle(_ text: String) -> some View {
        Text(text)
            .foregroundStyle(.secondary)
            .font(.subheadline)
    }
    
    private func domains(_ domains: [Domain]) -> some View {
        HStack {
            ForEach(domains, id: \.self) { domain in
                Text(domain.description)
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(domain.color.opacity(0.15))
                    .foregroundColor(domain.color)
                    .cornerRadius(6)
            }
        }
    }
    
    private func headLine(_ item: Item) -> some View {
        Text(item.title)
            .font(.headline)
    }
}

