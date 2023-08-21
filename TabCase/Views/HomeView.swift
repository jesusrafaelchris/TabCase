import SwiftUI
import Combine
import metamask_ios_sdk

struct HomeView: View {
    
    @State private var showARExperience = false
    @State private var searchText = ""
    @State private var searchIsActive = false
    @State private var rotation: Double = 0
    @State private var isSwitchChainViewPresented: Bool = false
    @State private var showingSheet = false
    @State private var selectedNFT: NFTModel?
    
    @ObservedObject var ethereum: Ethereum = MetaMaskSDK.shared.ethereum
    @State private var cancellables: Set<AnyCancellable> = []
        
    enum Network: String, CaseIterable, Identifiable {
        case goerli = "0x5"
        case ethereum = "0x1"
        case linea = "0xe704"
        
        var id: Self { self }
        
        var chainId: String {
            rawValue
        }
        
        var name: String {
            switch self {
                case .ethereum: return "Ethereum"
                case .goerli: return "Goerli Testnet"
                case .linea: return "Linea Testnet"
            }
        }
        
        static func chain(for chainId: String) -> String {
            self.allCases.first(where: { $0.rawValue == chainId })?.name ?? ""
        }
    }
    
    var body: some View {
            
        NavigationView {
            VStack {
                
                topBar
            
                ScrollView {
                    VStack {
                        SearchBar(text: $searchText)
                            .padding(.horizontal, 10)
                            .animation(.easeInOut, value: searchIsActive)
                            .onTapGesture {
                                withAnimation {
                                    self.searchIsActive.toggle()
                                }
                            }
                            .padding(.bottom, 16)
                        
                        Button {
                            showARExperience = true
                        } label: {
                            Text("Create your AR Experience")
                                .padding([.trailing, .leading], 68 )
                                .padding([.top, .bottom], 16)
                                .foregroundColor(.white)
                                .font(.system(size: 18)).bold()
                                .background(
                                    LinearGradient(gradient: Gradient(colors: [.red, .orange, .purple]), startPoint: .topTrailing, endPoint: .bottomLeading)
                                )
                        }
                        .cornerRadius(50)
                        .padding(.top, 4)
                        .fullScreenCover(isPresented: $showARExperience, content: {
                            ARExperienceView()
                    })
                    }
                    .padding(.top, 16)
                    
                    HStack {
                        Text("Current Bids")
                            .font(.system(size: 26, weight: .bold))
                        Spacer()
                    }
                    .padding(.leading, 16)
                    .padding(.top, 20)
                    
                    VStack {
                        ForEach(models, id: \.hash) { model in
                            BidRow(model: model)
                                .onTapGesture {
                                    selectedNFT = model
                                    showingSheet.toggle()
                                }
                        }
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                    }
                    
                    Spacer()
                }
            }
            .sheet(item: $selectedNFT) { model in
                NFTView(model: model)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

extension HomeView {
    
    private var topBar: some View {
                
        ZStack (alignment: .topLeading){
            HStack {
                VStack (alignment: .leading, spacing: 0) {
                    Text("Hi, \(formatEthereumAddress(ethereum.selectedAddress))")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(UIColor.lightGray))
                    
                    HStack(spacing: 10) {
                        Text("Connected to \(Network.chain(for: ethereum.chainId))")
                            .font(.system(size: 16, weight: .semibold))
            
                        Button {
                            withAnimation {
                                rotation += 180
                            }
                            isSwitchChainViewPresented.toggle()
                        } label: {
                            Image(systemName: "chevron.down")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14, height: 14)
                                .font(.headline)
                                .foregroundColor(.primary)
                                .rotationEffect(.degrees(rotation))
                        }
                        .sheet(isPresented: $isSwitchChainViewPresented) {
                            SwitchChainView()
                                .presentationDetents([.fraction(0.25)])
                        }
                        .onChange(of: isSwitchChainViewPresented) { newValue in
                            if !newValue { 
                                withAnimation {
                                    rotation += 180
                                }
                            }
                        }
                        
                    }
                }
                
                Spacer()
                
                NavigationLink {
                    
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                }
            }
            .padding(.leading, 16)
            .padding(.trailing, 16)
        }
        .padding(.top, 24)
    }
    
    func formatEthereumAddress(_ address: String?) -> String {
        guard let address = address, address.count > 10 else { return address ?? "" }
        let start = address.prefix(7)
        let end = address.suffix(5)
        return "\(start)...\(end)"
    }
}

struct SearchBar: View {
    @Binding var text: String
    @FocusState var isFocused: Bool
    
    var body: some View {
        HStack {
            TextField("Search current bids", text: $text)
                .focused($isFocused)
                .padding(7)
                .padding(.horizontal, 24)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                    }
                )
                .onTapGesture {
                    isFocused = true
                }
        }
        .padding([.leading, .trailing], 5)
    }
}
