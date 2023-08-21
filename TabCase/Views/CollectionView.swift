import SwiftUI

struct CollectionView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(filters, id: \.id) { filter in
                                FilterPill(pill: filter)
                            }
                        }
                        .padding(.leading, 16)
                    }
                    .padding(.top, 12)
                    
                    HStack {
                        Text("Explore Categories")
                            .font(.system(size: 24, weight: .bold))
                        
                        Spacer()
                        
                    }
                    .frame(width: UIScreen.screenWidth*0.92)
                    .padding(.top, 12)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(categories, id: \.id) { category in
                                CategoriesCell(category: category)
                                    .shadow(radius: 2)
                            }
                            .padding([.top, .bottom, .trailing], 2)
                            .padding(.leading, 2)
                        }
                    }
                    .frame(width: UIScreen.screenWidth*0.92)
                    
                    HStack {
                        Text("Featured")
                            .font(.system(size: 24, weight: .bold))
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                    }
                    .frame(width: UIScreen.screenWidth*0.92)
                    .padding(.top, 12)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(featuredModels, id: \.id) { nft in
                                OwnedRow(model: nft)
                            }
                            .padding(.leading, 16)
                        }
                    }
                    .padding(.top, 0)
                    
                    HStack {
                        Text("NFT 101")
                            .font(.system(size: 24, weight: .bold))
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                    }
                    .frame(width: UIScreen.screenWidth*0.92)
                    .padding(.top, 12)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(nftModels, id: \.id) { nft in
                                OwnedRow(model: nft)
                            }
                            .padding(.leading, 16)
                        }
                    }
                    .padding(.top, 0)
                    
                    Spacer()
                }
                .navigationTitle("Marketplace")
            }
        }
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
    }
}
