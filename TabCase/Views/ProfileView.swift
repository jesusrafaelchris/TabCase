import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack(spacing: 16) {
                        Image("christian")
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 70, height: 70)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            HStack {
                                Text("Christian")
                                    .font(.system(size: 20, weight: .bold))
                                
                                Button {
                                    
                                } label: {
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.black)
                                }
                            }
                            
                            Text("jesusrafaelchris")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.black.opacity(0.7))

                        }
                        
                        Spacer()
                    }
                    .padding(.top, 12)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.gray)
                        .opacity(0.3)
                        .frame(width: UIScreen.screenWidth*0.9, height: 40)
                        .overlay(
                            HStack {
                                Text("🚀  Focusing")
                                
                                Spacer()
                            }
                                .padding([.leading, .trailing], 16)
                        )
                    
                    HStack {
                        Text("Bringing NFTs to Augmented Reality")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.black)
                        
                        Spacer()
                    }
                    .padding(.top, 4)
                    
                    VStack(spacing: 4) {
                        HStack {
                            Button {
                                
                            } label: {
                                Image(systemName: "map")
                                    .foregroundColor(.black.opacity(0.6))
                            }
                            .frame(width: 26)
                            
                            Text("London, UK")
                                .foregroundColor(.black.opacity(0.6))
                            
                            Spacer()
                        }
                        
                        HStack {
                            Button {
                                
                            } label: {
                                Image(systemName: "person")
                                    .foregroundColor(.black.opacity(0.6))
                            }
                            .frame(width: 26)
                            
                            HStack(spacing: 6) {
                                Text("11")
                                    .foregroundColor(.black)
                                Text("followers  •")
                                    .foregroundColor(.black.opacity(0.6))
                            }
                            
                            HStack(spacing: 6) {
                                Text("15")
                                    .foregroundColor(.black)
                                Text("following")
                                    .foregroundColor(.black.opacity(0.6))
                            }
                            
                            Spacer()
                        }
                        
                        HStack {
                            Button {
                                
                            } label: {
                                Image(systemName: "trophy")
                                    .foregroundColor(.black.opacity(0.6))
                            }
                            .frame(width: 26)
                            
                            HStack(spacing: -10) {
                                Image("cat")
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                                    .frame(width: 34, height: 34)
                                
                                Image("dino")
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                                    .frame(width: 37, height: 37)
                            }
                            
                            Spacer()
                        }
                        .padding(.top, 6)
                        
                        HStack {
                            Image(systemName: "photo.artframe")
                                .foregroundColor(.black.opacity(0.6))
                            
                            Text("Owned NFTS")
                                .foregroundColor(.black.opacity(0.6))
                            
                            Spacer()
                        }
                        .padding(.top, 14)
                        
                        VStack {
                            ScrollView(showsIndicators: false) {
                                ForEach(ownedModels, id: \.id) { nft in
                                    OwnedRow(model: nft)
                                }
                            }
                        }
                        .padding(.top, 12)
                        
                    }
                    .padding(.top, 2)
                    
                    Spacer()
                }
                .frame(width: UIScreen.screenWidth*0.9)
                .navigationTitle("")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack(spacing: 6) {
                            Button(action: {
                            }) {
                                Image(systemName: "gearshape")
                            }
                            
                            Button(action: {
                            }) {
                                Image(systemName: "square.and.arrow.up")
                            }
                        }
                    }
            }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
