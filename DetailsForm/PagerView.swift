//
//  PagerView.swift
//  DetailsForm
//
//  Created by Marwan Aziz on 25/03/2023.
//

import SwiftUI

struct PagerView: View {

    var pages: Array<PageContainer>
    @Binding var index: Int
    @State var snapsEnabled: Bool
    @State var swipeEnabled: Bool = false
    @State var bottomAnchorOffset: CGFloat = 0
    @State private var offset: CGFloat = 0
    @State private var isGestureActive: Bool = false

    private var spacing: CGFloat {
        snapsEnabled ? 10 : 0
    }

    private func itemWidth(_ geometry: GeometryProxy) -> CGFloat {
        if snapsEnabled {
            return geometry.size.width - spacing * CGFloat(pages.count + 1)
        } else {
            return geometry.size.width
        }
    }

    var body: some View {

        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: spacing) {
                    ForEach (pages) { view in
                        view
                            .frame(minWidth: itemWidth(geometry),
                                   idealWidth: itemWidth(geometry),
                                   maxWidth: itemWidth(geometry),
                                   maxHeight: .infinity
                            )
                    }
                }.frame( maxHeight: .infinity)
            }
            // 2
            .content.offset(x: self.isGestureActive ? self.offset : -itemWidth(geometry) * CGFloat(index))
            // 3
            .frame(idealWidth: geometry.size.width, idealHeight: .infinity)
            .gesture(DragGesture().onChanged({ value in
                if swipeEnabled {
                    // 4
                    self.isGestureActive = true
                    // 5
                    self.offset = value.translation.width + -itemWidth(geometry) * CGFloat(index)
                }
            }).onEnded({ value in
                if swipeEnabled {
                    if -value.predictedEndTranslation.width > itemWidth(geometry) / 2, index < pages.endIndex - 1 {
                        index += 1
                    }
                    if value.predictedEndTranslation.width > itemWidth(geometry) / 2, index > 0 {
                        index -= 1
                    }
                    // 6
                    withAnimation { self.offset = -itemWidth(geometry) * CGFloat(index) }
                    // 7
                    DispatchQueue.main.async { self.isGestureActive = false }
                }
            }))
            .offset(CGSize(width: spacing, height: 0))

        }
    }
}

struct PageContainer: View, Identifiable {
    let id = UUID()
    let pageView: Any
    private let internalView: AnyView

    init<V: View>(_ view: V) {
        internalView = AnyView(view)
        pageView = view
    }

    @ViewBuilder
    var body: some View {
        internalView
            .frame(maxHeight: .infinity)
    }
}

struct PagerView_Previews: PreviewProvider {
    static var views = [PageContainer(AnyView(EmptyView()))]
    static var height: CGFloat = 0
    @State static var index: Int = 0
    static var previews: some View {
        PagerView(pages: views, index: $index, snapsEnabled: true, bottomAnchorOffset: height).preferredColorScheme(.dark)
    }
}
