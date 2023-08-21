import SwiftUI

struct OwnedRow: View {
    
    var model: NFTModel
    
    var body: some View {
        VStack {
            HStack {
                Image(model.thumbnail)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .cornerRadius(8)
                    .padding(8)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(model.name)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black.opacity(1))
                    
                    Text(model.hash)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black.opacity(0.7))
                    
                    HStack(spacing: 12) {
                        Text(String(format: "%.4f ETH", model.price))
                        
                        Button {
                            
                        } label: {
                            HStack {
                                Image("opensea")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .padding(4)
                                    .background(.blue)
                                    .cornerRadius(50)
                            }
                        }
                    }
                    .padding(.top, 8)
                    
                    Spacer()
                }
                .padding(.top, 24)
                
                Spacer()
                
                VStack {
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .bold()
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                }
                .padding([.top, .trailing], 12)
            }
        }
        .frame(width: UIScreen.screenWidth*0.9, height: 134)
        .background(.black.opacity(0.02))
        .cornerRadius(8)
    }
}

struct OwnedRow_Previews: PreviewProvider {
    static var previews: some View {
        OwnedRow(model: ownedModels[0])
    }
}
