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
                        .onReceive(Publishers.keyboardHeight.receive(on: DispatchQueue.main)) { value in
                            var newHeight: CGFloat = 0
                            if value.height > 0 {
                                if let focusedFieldFrame = viewModel.focusedFieldFrame {
                                    print("field frame: \(focusedFieldFrame)")
                                    print("Keyboard frame: \(value)")
                                    print("Frames intersects: \(focusedFieldFrame.intersects(value))")
                                    if focusedFieldFrame.intersects(value) {
                                        newHeight = focusedFieldFrame.intersection(value).height //(reader.frame(in: .global).maxY  - value) - totalFieldBottomAnchor
                                        print("frames intersection: \(focusedFieldFrame.intersection(value))")
                                        print("*****************************************************")
                                        if newHeight < 0 {
                                            newHeight = 0
                                        }
                                    }
                                } else {
                                    print("Field frame is null")
                                    return
                                }
                            }
                            withAnimation {
                                self.bottomAnchor = abs(newHeight)
                            }
                        }
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

extension Notification {
    var keyboardHeight: CGRect {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect) ?? .zero
    }
}

extension Publishers {
    // 1.
    static var keyboardHeight: AnyPublisher<CGRect, Never> {
        // 2.
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map {
                $0.keyboardHeight
            }

        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in
                    CGRect.zero
            }

        // 3.
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}
