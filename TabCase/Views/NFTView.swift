import SwiftUI

struct NFTView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var model: NFTModel
    
    var body: some View {
        NavigationView {
            VStack {
                Image(model.thumbnail)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.screenWidth*0.9)
                    .cornerRadius(12)
                    .padding(.top, 18)
                    .shadow(radius: 2)
                
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(model.name)
                            .font(.system(size: 24, weight: .bold))
                        
                        Text(model.hash)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    Text(String(format: "%.4f ETH", model.price))
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                }
                .frame(width: UIScreen.screenWidth*0.9)
                .padding(.top, 12)
                
                HStack {
                    VStack {
                        Text("Auction ends on: 14.09.2023")
                    }
                    
                    Spacer()
                }
                .frame(width: UIScreen.screenWidth*0.9)
                .padding(.top, 12)
                
                Button {
                    
                } label: {
                    HStack {
                        Image("opensea")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        
                        Text("View on OpenSea")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .frame(width: UIScreen.screenWidth*0.9, height: 60)
                    .background(.blue)
                    .cornerRadius(50)
                        
                }
                .padding(.top, 24)
                
                Spacer()
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Link("Etherscan", destination: URL(string: "https://etherscan.io/address/\(model.assetAddress)/\(model.hash)")!)
                        .foregroundColor(.blue)

                }
            }
        }
        
    }
}

struct NFTView_Previews: PreviewProvider {
    static var previews: some View {
        NFTView(model: models[0])
    }
}

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
