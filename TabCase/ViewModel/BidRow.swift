import SwiftUI

struct BidRow: View {
    
    var model: NFTModel
    
    var body: some View {
        HStack(spacing: 16) {
            Image(model.thumbnail)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(model.name)
                    .font(.system(size: 18, weight: .bold))
                
                Text(model.hash)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            HStack {
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
                
                Text(String(format: "%.3f ETH", model.price))
                    .font(.system(size: 16)).bold()
            }
        }
    }
}

struct BidRow_Previews: PreviewProvider {
    static var previews: some View {
        BidRow(model: models[0])
    }
}
