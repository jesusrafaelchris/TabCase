# TabCase
Head [here](https://youtu.be/dXR2qfmPd8U) for a video demo and explanation of TabCase on YouTube. 
## Images
<img src=https://github.com/acse-bac3c258/indentcase/assets/142490406/c784c107-ec3e-4db1-8fe2-a09671ed4196 width=18% height=18% >
<img src=https://github.com/acse-bac3c258/indentcase/assets/142490406/abf49e67-ba6f-4f8a-909f-4b6a90cf60b4 width=18% height=18% >
<img src=https://github.com/acse-bac3c258/indentcase/assets/142490406/cc1d296a-6002-4dc5-8cee-acde76ed8e5a width=18% height=18% >
<img src=https://github.com/acse-bac3c258/indentcase/assets/142490406/a711f5b6-7ec1-4462-b825-61b2573adf4c width=18% height=18% >
<img src=https://github.com/acse-bac3c258/indentcase/assets/142490406/7adfe4cb-2327-4e83-83d0-aeb258872575 width=18% height=18% >

# Project Description
## Summary
TabCase is an augmented reality powered iOS App that uses the MetaMask SDK and the OpenSea API to empower independent artists and curators to visualise their art creations through a different medium. The general idea is that you can also visualise your own NFTs, or NFTs that you can bid on, using AR. This means that if you like the visual appearance of an NFT both on a computer screen and when mixed with your environment, you can make purchases not only based on value, but also how you want your owned artwork to interact with your environment. 

## Team Member ~~(s)~~
Christian Gringling, jesusrafaelchris
Email: grinlingc@gmail.com

## Bounty Submitted 
Bounty 2: Mobile Fun with MetaMask SDK, as the SDK was used to 1. Connect the App to the MetaMask App using a deeplink and 2. Switch between different chains/networks.

## Problem Addressed
- **Problem 1**: The lack of interactivity with your NFTs, as they usually just sit in your wallet and collect dust, TabCase provides an easy and fun way to place your NFTs (converted to `.usdz` files) in your environment. As NFTs are not only limited to JPEGs, we can use a variety of different file types to be supported by TabCase.
-**Problem 2**: NFTs and Web3 has a high barrier of knowledge entry, and TabCase is here to make life easier for users, as logging is just a matter of 2 button taps, and MetaMask/Linea is handled in the backend, allowing the user to focus on the frontend of the app, whihch is the interactivity. 

## Future Plans
- Live Bids wherre users can out-bid each other
- Social Profiles so that users can see each other's NFTs
- Use XMTP for social messaging and sharing of different NFTs
- AR Galleries (NFT AR Playlists) that allow artist to save a particular set of their NFTs to an area, that is then accessible for users to explore, with the option to bid and buy those NFTs, like with a gallery.

# Installation
Clone the repository using 

    git clone wonwoignwegonweg

Open the `.xcodeproj` file, change teams, and run the Xcode project.

# MetaMask SDK Usage
MetaMask usage can be seen throughout the source code, but especially in 2 particular files: `LoginView.swift` and `SwitchChainView.swift`. In the `LoginView`, we use the MetaMask iOS SDK, by importing it, creating an `@ObservedObject` and then sending a deeplink to the MetaMask app:

```swift
import metamask_ios_sdk

@ObservedObject var ethereum = MetaMaskSDK.shared.ethereum
@State private var cancellables: Set<AnyCancellable> = []

private let dapp = Dapp(name: "TabCase", url: "https://tabcase.me")

@State private var connected: Bool = false
@State private var status: String = "Offline"

@State private var errorMessage = ""

  // Different Stacks, Variables, etc.

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

// Remainder of View
```

In the `SwitchChainView`, we perform a similar action, however, through a picker:

```swift
import metamask_ios_sdk

@ObservedObject var ethereum: Ethereum = MetaMaskSDK.shared.ethereum

@State private var cancellables: Set<AnyCancellable> = []
@State private var alert: AlertInfo?
@State var networkSelection: Network = .goerli

// Jumping into the struct

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

// A couple of Views later

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

```
