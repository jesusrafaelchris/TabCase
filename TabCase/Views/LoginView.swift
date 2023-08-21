import SwiftUI
import Combine
import metamask_ios_sdk

struct LoginView: View {
    
    @State private var navigateToNextView: Bool = false
    
    @ObservedObject var ethereum = MetaMaskSDK.shared.ethereum
    @State private var cancellables: Set<AnyCancellable> = []

    private let dapp = Dapp(name: "Dub Dapp", url: "https://dubdapp.com")

    @State private var connected: Bool = false
    @State private var status: String = "Offline"

    @State private var errorMessage = ""
    @State private var showError = false

    @State private var showToast = false
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 14) {
                    HStack(spacing: 26) {
                        Image(systemName: "cube.transparent")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 65, height: 65)
                        
                        Text("TabCase")
                            .font(.system(size: 32, weight: .bold))
                    }
                    
                    HStack {
                        Text("NFTs - Reimagined")
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
                .padding(.top, 140)
                
                HStack(spacing: 14) {
                    Image("MetaMask")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    
                    Button {
                        ethereum.connect(dapp)?.sink(receiveCompletion: { completion in
                            switch completion {
                            case let .failure(error):
                                errorMessage = error.localizedDescription
                                showError = true
                                print("Connection error: \(errorMessage)")
                            default: break
                            }
                        }, receiveValue: { result in
                            print("Connection result: \(result)")
                            navigateToNextView = true
                        }).store(in: &cancellables)
                        
                    } label: {
                        LoginButtonContent(text: "Log in with MetaMask")
                    }
                    
                    NavigationLink(
                        destination: TabControllerView(),
                        isActive: $navigateToNextView
                    ) { EmptyView() }
                    .hidden()

                }
                .padding(.leading, 16)
                .padding(.top, 200)
                
                Spacer()
                
                VStack {
                    Text("Having troubles?")
                        .font(.system(size: 16, weight: .semibold))
                    
                    Text("Erase Data")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.orange)
                }
                .padding(.bottom, 4)
                
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

struct LoginButtonContent: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.system(size: 18)).bold()
            .foregroundColor(.white)
            .padding(EdgeInsets(top: 10, leading: 34, bottom: 10, trailing: 34))
            .background(Color.red.opacity(0.8))
            .cornerRadius(14)
            .frame(width: 260, height: 180)
    }
}
