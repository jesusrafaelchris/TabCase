import SwiftUI
import RealityKit
import ARKit
import FocusEntity
import Combine

struct ARExperienceView: View {
    @State private var modelEntities: [ModelEntity] = []
    @State private var isEditingModel: Bool = false
    @State private var selectedModelName: String? = nil
    @State private var arCoordinator: ARContainerView.Coordinator?
    @State private var deleteAllCancellable: AnyCancellable? = nil
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            ZStack {
                ARContainerView(selectedModelName: $selectedModelName, modelEntities: $modelEntities, isEditingModel: $isEditingModel)
                
                VStack {
                    Text("Add your Artwork")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 80)
                    
                    HStack {
                        
                        Spacer()
                        
                        VStack(spacing: 14) {
                            Button {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    isEditingModel.toggle()
                                    print("Pencil tapped. isEditingModel is now: \(isEditingModel)")
                                }
                            } label: {
                                Image(systemName: "pencil")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.clear)
                                    .contentShape(Rectangle())
                            }
                            
                            Button {
                                print("Undo tapped")
                            } label: {
                                Image(systemName: "arrow.uturn.backward")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.clear)
                                    .contentShape(Rectangle())
                            }
                            
                            Button {
                                print("Trash tapped")
                            } label: {
                                Image(systemName: "trash")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.clear)
                                    .contentShape(Rectangle())
                            }
                        }
                        .padding()
                    }
                    
                    Spacer()
                    BottomSheet(selectedModelName: $selectedModelName)
                }
            }
            .navigationBarTitle(Text(""), displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.white)
                    .font(.title2)
                    .padding()
            })
            .edgesIgnoringSafeArea([.top, .bottom])
        }
    }
}

struct ARContainerView: UIViewRepresentable {
    @Binding var selectedModelName: String?
    @Binding var modelEntities: [ModelEntity]
    @Binding var isEditingModel: Bool

    func makeUIView(context: Context) -> ARView {
        let view = ARView()
        
        let session = view.session
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.vertical]
        session.run(config)
        
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.session = session
        coachingOverlay.goal = .verticalPlane
        view.addSubview(coachingOverlay)
        
        context.coordinator.view = view
        session.delegate = context.coordinator
        
        view.addGestureRecognizer(
            UITapGestureRecognizer(
                target: context.coordinator,
                action: #selector(Coordinator.handleTap)
            )
        )
        
        return view
    }

    func updateUIView(_ uiView: ARView, context: Context) {

    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(selectedModelName: $selectedModelName, isEditingModel: $isEditingModel)
    }

    class Coordinator: NSObject, ARSessionDelegate {
        weak var view: ARView?
        var selectedModelName: Binding<String?>
        var focusEntity: FocusEntity?
        var isEditingModel: Binding<Bool>
        var addedAnchors: [AnchorEntity] = []
        
        init(selectedModelName: Binding<String?>, isEditingModel: Binding<Bool>) {
            self.selectedModelName = selectedModelName
            self.isEditingModel = isEditingModel
            
            super.init()
        }

        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            guard let view = self.view else { return }

            if self.focusEntity == nil {
                self.focusEntity = FocusEntity(on: view, style: .classic(color: .yellow))
            } else {
            }
        }
        
        @objc func handleTap(gesture: UITapGestureRecognizer) {
            guard let view = self.view, let focusEntity = self.focusEntity else { return }
            
            print("Is Editing: \(isEditingModel.wrappedValue)")

            if isEditingModel.wrappedValue {
                print("Editing mode is active. No model will be added.")
                return
            }

            if let modelName = selectedModelName.wrappedValue {
                let anchor = AnchorEntity()
                view.scene.anchors.append(anchor)

                let modelEntity = try! ModelEntity.loadModel(named: modelName)
                modelEntity.scale = [0.01, 0.01, 0.01]
                modelEntity.position = focusEntity.position
                modelEntity.generateCollisionShapes(recursive: true)
                view.installGestures([.all], for: modelEntity)

                anchor.addChild(modelEntity)

                addedAnchors.append(anchor)
            }
        }
    }
}

struct BottomSheet: View {
    @Binding var selectedModelName: String?
    @State private var showBiddingView: Bool = false

    var body: some View {
        VStack {
            Text("My Collection")
                .font(.system(size: 25)).bold()
                .foregroundColor(.white)
                .padding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(models, id: \.hash) { model in
                        VStack {
                            Image(model.thumbnail)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .cornerRadius(12)

                                .onTapGesture {
                                    selectedModelName = model.model
                                }
                            
                            Button {
                                selectedModelName = model.model
                                showBiddingView.toggle()
                            } label: {
                                Text("Make a bid")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding([.trailing, .leading], 10)
                                    .padding([.top, .bottom], 8)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(12)
                            }
                            .offset(y: -30)
                        }
                        .sheet(isPresented: $showBiddingView) {
                            if let modelName = selectedModelName,
                               let selectedModel = models.first(where: { $0.model == modelName }) {
                                BiddingView(model: selectedModel)
                            }
                        }
                    }
                }
            }
            .padding()
            .offset(y: -10)
        }
        .background(BlurView())
        .cornerRadius(18)
    }
}

struct BlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

struct ARExperienceView_Previews: PreviewProvider {
    static var previews: some View {
        ARExperienceView()
    }
}

