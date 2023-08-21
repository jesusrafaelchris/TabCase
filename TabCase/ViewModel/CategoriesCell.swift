import SwiftUI

struct Category: Identifiable {
    var id = UUID()
    var name: String
    var imageUrl: String
}

let categories: [Category] = [
    Category(name: "Art", imageUrl: "art"),
    Category(name: "Gaming", imageUrl: "gaming"),
    Category(name: "Memberships", imageUrl: "memberships"),
    Category(name: "Music", imageUrl: "music"),

]

struct CategoriesCell: View {
    
    var category: Category
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(category.imageUrl)
                .resizable()
                .scaledToFill()
                .frame(width: 140, height: 140)
                .overlay(
                    ZStack(alignment: .bottomLeading) {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 140, height: 40)
                        
                        Text(category.name)
                            .font(.system(size: 17, weight: .bold))
                            .padding(.leading, 12)
                            .padding(.bottom, 10)
                    }
                    ,alignment: .bottom
                )
                .shadow(radius: 1)
                .cornerRadius(16)
        }
    }
}


struct CategoriesCell_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesCell(category: categories[0])
            .background(.black)
    }
}
