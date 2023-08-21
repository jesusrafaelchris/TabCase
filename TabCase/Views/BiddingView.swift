import SwiftUI

struct BiddingView: View {
    
    @State private var price: Double

    @Environment(\.presentationMode) var presentationMode
    
    init(model: NFTModel = models[0]) {
        self.model = model
        self._price = State(initialValue: model.price)
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var model: NFTModel
    
    var body: some View {
                
        NavigationView {
            VStack {
                Image(model.thumbnail)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 320, height: 320)
                    .cornerRadius(16)
                    .padding(.top, 12)
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(model.name)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text(String(format: "Current price: %.4f ETH", model.price))
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                }
                .padding(.top, 24)
                .padding([.leading, .trailing], 16)
                
                HStack(spacing: 24) {
                    Button {
                        price -= 0.0001
                    } label: {
                        Image(systemName: "minus")
                            .font(.system(size: 24, weight: .bold))
                            .frame(width: 50, height: 50)
                            .background(.black.opacity(0.6))
                            .cornerRadius(16)
                        
                    }
                    
                    Button {
                        
                    } label: {
                        Text(String(format: "%.4f", price))
                            .font(.system(size: 36, weight: .bold))
                            .frame(width: 150, height: 36)
                    }
                    
                    Button {
                        price += 0.0001
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .bold))
                            .frame(width: 50, height: 50)
                            .background(.black.opacity(0.6))
                            .cornerRadius(16)
                    }
                }
                .padding(.top, 36)
                
                Button {
                    
                } label: {
                    Text("Bid")
                        .font(.system(size: 22, weight: .bold))
                        .frame(width: 330, height: 50)
                        .padding([.leading, .trailing], 16)
                        .background(.blue.opacity(0.8))
                        .cornerRadius(16)
                }
                .padding(.top, 16)
                
                Spacer()
            }
            .background(
                Image(model.thumbnail)
                    .resizable()
                    .scaledToFill()
                    .blur(radius: 80)
                    .overlay(Color.black.opacity(0.3))
                    .edgesIgnoringSafeArea(.all)
            )
            .navigationTitle("Make a Bid")
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .font(.system(size: 12, weight: .bold))
                    .padding(8)
                    .background(.black.opacity(0.1))
                    .cornerRadius(50)
            })
        }
        .accentColor(.white)
    }
}

struct BiddingView_Previews: PreviewProvider {
    static var previews: some View {
        BiddingView(model: models[0])
    }
}
