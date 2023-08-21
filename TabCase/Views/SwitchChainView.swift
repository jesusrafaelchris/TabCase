import SwiftUI
import Combine
import metamask_ios_sdk

struct SwitchChainView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var ethereum: Ethereum = MetaMaskSDK.shared.ethereum

    @State private var cancellables: Set<AnyCancellable> = []
    @State private var alert: AlertInfo?
    @State var networkSelection: Network = .goerli
    
    init() {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
    }

    struct AlertInfo: Identifiable {
        enum Status {
            case error
            case success
            case chainDoesNotExist
        }

        let id: Status
        let title: String
        let message: String

        var primaryButton: Alert.Button?
        var secondarButton: Alert.Button?
        var dismissButton: Alert.Button?
    }
    
    enum Network: String, CaseIterable, Identifiable {
        case goerli = "0x5"
        case kovan = "0x2a"
        case ethereum = "0x1"
        case polygon = "0x89"
        case linea_test = "0xe704"
        case linea = "0xe708"
        
        var id: Self { self }
        
        var chainId: String {
            rawValue
        }
        
        var name: String {
            switch self {
                case .polygon: return "Polygon"
                case .ethereum: return "Ethereum"
                case .kovan: return "Kovan Testnet"
                case .goerli: return "Goerli Testnet"
                case .linea_test: return "Linea Testnet"
                case .linea: return "Linea Main Network"
            }
        }
        
        var rpcUrls: [String] {
            switch self {
            case .polygon: return ["https://polygon-rpc.com"]
            default: return []
            }
        }
        
        static func chain(for chainId: String) -> String {
            self.allCases.first(where: { $0.rawValue == chainId })?.name ?? ""
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Switch to:", selection: $networkSelection) {
                        ForEach(Network.allCases) { network in
                            Text("\(network.name)")
                        }
                    }
                    .onChange(of: networkSelection) { newNetwork in
                        switchEthereumChain()
                    }
                }
            }
            .navigationBarTitle("Select Chain", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.primary)
                    .font(.system(size: 12, weight: .bold))
                    .padding(8)
                    .background(.black.opacity(0.1))
                    .cornerRadius(50)
            })
        }
        .onAppear {
            if let selectedNetwork = Network.allCases.first(where: { $0.chainId == ethereum.chainId }) {
                networkSelection = selectedNetwork
            } else {
                networkSelection = .goerli
            }
        }
    }

    func switchEthereumChain() {
        let switchChainParams: [String: String] = [
            "chainId": networkSelection.chainId
        ]

        let switchChainRequest = EthereumRequest(
            method: .switchEthereumChain,
            params: [switchChainParams] // wallet_switchEthereumChain rpc call expects an array parameters object
        )

        ethereum.request(switchChainRequest)?.sink(receiveCompletion: { completion in
            switch completion {
            case let .failure(error):
                if error.codeType == .unrecognizedChainId || error.codeType == .serverError {
                    alert = AlertInfo(
                        id: .chainDoesNotExist,
                        title: "Error",
                        message: "\(networkSelection.name) (\(networkSelection.chainId)) has not been added to your MetaMask wallet. Add chain?",
                        primaryButton: SwiftUI.Alert.Button.default(Text("OK"), action: {
                            addEthereumChain()
                        }),
                        secondarButton: SwiftUI.Alert.Button.default(Text("Cancel"))
                    )
                } else {
                    alert = AlertInfo(
                        id: .error,
                        title: "Error",
                        message: error.localizedDescription,
                        dismissButton: SwiftUI.Alert.Button.default(Text("OK"))
                    )
                    print("Switch chain error: \(error.localizedDescription)")
                }
            default: break
            }
        }, receiveValue: { value in
            alert = AlertInfo(
                id: .success,
                title: "Success",
                message: "Successfully switched to \(networkSelection.name)",
                dismissButton: SwiftUI.Alert.Button.default(Text("OK"), action: {
                    presentationMode.wrappedValue.dismiss()
                })
            )
            print("Switch chain result: \(value)")
        }).store(in: &cancellables)
    }

    func addEthereumChain() {
        let addChainParams = AddChainRequest(
            chainId: networkSelection.chainId,
            chainName: networkSelection.name,
            rpcUrls: networkSelection.rpcUrls
        )

        let addChainRequest = EthereumRequest(
            method: .addEthereumChain,
            params: [addChainParams] // wallet_addEthereumChain rpc call expects an array parameters object
        )

        ethereum.request(addChainRequest)?.sink(receiveCompletion: { completion in
            switch completion {
            case let .failure(error):
                alert = AlertInfo(
                    id: .error,
                    title: "Error",
                    message: error.localizedDescription
                )
                print("Add chain error: \(error.localizedDescription)")
            default: break
            }
        }, receiveValue: { value in
            alert = AlertInfo(
                id: .success,
                title: "Success",
                message: ethereum.chainId == networkSelection.chainId
                    ? "Successfully switched to \(networkSelection.name)"
                    : "Successfully added \(networkSelection.name)",
                dismissButton: SwiftUI.Alert.Button.default(Text("OK"), action: {
                    presentationMode.wrappedValue.dismiss()
                })
            )
            print("Add chain result: \(value)")
        }).store(in: &cancellables)
    }
}

struct AddChainRequest: CodableData {
    let chainId: String
    let chainName: String
    let rpcUrls: [String]

    public func socketRepresentation() -> NetworkData {
        [
            "chainId": chainId,
            "chainName": chainName,
            "rpcUrls": rpcUrls
        ]
    }
}

struct SwitchChainView_Previews: PreviewProvider {
    static var previews: some View {
        SwitchChainView()
    }
}
