//
//  DetailsCollectingWalkthrough.swift
//  DetailsForm
//
//  Created by Marwan Aziz on 25/03/2023.
//

import SwiftUI
import Combine

class DetailsCollectingWalkthroughViewModel: ObservableObject {

    @Published var focusedFieldFrame: CGRect? = .zero
}

struct DetailsCollectingWalkthrough: View {
    @ObservedObject var viewModel: DetailsCollectingWalkthroughViewModel

    var pages: [PageContainer] = []
    @State var index: Int
    @State var bottomAnchor: CGFloat = 0

    init() {
        self.index = 0
        let viewModel = DetailsCollectingWalkthroughViewModel()
        self.viewModel = viewModel
        self.pages = [PageContainer(DetailsCollectingStepOne(viewModel: viewModel)),
                      PageContainer(DetailsCollectionStepTwo(viewModel: viewModel)),
                      PageContainer(DetailsCollectingStepThree(viewModel: viewModel))]
    }

    var mainBody: some View {
        GeometryReader { reader in
            VStack {
                ScrollView {
                    PagerView(pages: pages, index: $index, snapsEnabled: false)
                        .frame(height: reader.size.height)
                }
                .content.offset(x: 0, y: -bottomAnchor)
                .ignoresSafeArea(.keyboard)
                .frame(height: reader.size.height)
                HStack {
                    Button("Back") {
                        if index > 0 {
                            DispatchQueue.main.async {
                                withAnimation {
                                    index -= 1
                                }
                            }
                        }
                    }

                    Spacer()

                    Button("Next") {
                        if index < pages.indices.last! {
                            DispatchQueue.main.async {
                                withAnimation {
                                    index += 1
                                }
                            }
                        }
                    }
                }
            }
            .padding()
            .ignoresSafeArea(.keyboard)
            .onKeyboardSizeChanged(action: { value in
                var newHeight: CGFloat = 0
                if value.height > 0 {
                    if let focusedFieldFrame = viewModel.focusedFieldFrame {
                        print("field frame: \(focusedFieldFrame)")
                        print("Keyboard frame: \(value)")
                        print("Frames intersects: \(focusedFieldFrame.intersects(value))")
                        if focusedFieldFrame.maxY > value.minY {
                            newHeight = focusedFieldFrame.maxY - value.minY
                            print("frames intersection: \(focusedFieldFrame.intersection(value))")
                            if newHeight < 0 {
                                newHeight = 0
                            }
                        }
                    } else {
                        print("Field frame is null")
                        return
                    }
                } else {
                    print("Hiding keyboard: \(value)")
                }
                print("*****************************************************")
                withAnimation {
                    self.bottomAnchor = abs(newHeight)
                }
            })
            .frame(height: reader.size.height)

        }
        .ignoresSafeArea(.keyboard)
    }

    var body: some View {
        mainBody
    }
}

struct DetailsCollectingWalkthrough_Previews: PreviewProvider {
    static var previews: some View {
        DetailsCollectingWalkthrough()
    }
}


struct WatchKeyboard: ViewModifier {
    @State var keyboardSize: CGRect = .zero
    var onSizeChanged: (CGRect) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear(perform: {
                NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillShowNotification)
                    .dropFirst(1)
                    .receive(on: DispatchQueue.main)
                    .merge(with: NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillHideNotification))
                    .compactMap { notification in
                        notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                    }.subscribe(Subscribers.Assign(object: self, keyPath: \.keyboardSize))

            }
            ).onChange(of: keyboardSize) {
                onSizeChanged($0)
            }
    }
}

extension View {
    func onKeyboardSizeChanged( action: @escaping (CGRect) -> Void) -> some View {
        return modifier(WatchKeyboard(onSizeChanged: action))
    }
}
