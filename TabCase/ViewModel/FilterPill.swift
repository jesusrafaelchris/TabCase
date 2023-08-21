import SwiftUI

struct Pill: Identifiable {
    var id = UUID()
    var name: String
    var icon: String?
}

let filters: [Pill] = [
    Pill(name: "🌟 New NFTs"),
    Pill(name: "🚀 Up and Coming"),
    Pill(name: "🔥 Hot Artists"),
    Pill(name: "🐱 Animals"),
    Pill(name: "🎭 Abstract Art"),
]

struct FilterPill: View {
    
    @State private var isSelected: Bool = false
    
    var pill: Pill

    var body: some View {
        Text(pill.name)
            .font(.system(size: 14, weight: .semibold))
            .padding([.leading, .trailing], 10)
            .padding([.top, .bottom], 5)
            .background(isSelected ? Color.orange.opacity(0.6) : Color.orange.opacity(0.3))
            .cornerRadius(6)
            .onTapGesture {
                isSelected.toggle()
            }
    }
}

struct FilterPill_Previews: PreviewProvider {
    static var previews: some View {
        FilterPill(pill: filters[0])
    }
}
