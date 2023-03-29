//
//  DetailsCollectingStepThree.swift
//  DetailsForm
//
//  Created by Marwan Aziz on 25/03/2023.
//

import SwiftUI

struct DetailsCollectingStepThree: View {

    @StateObject var viewModel: DetailsCollectingWalkthroughViewModel
    @State var focusedField: Int = 0
    @State var height: String = ""
    @State var weight: String = ""
    @State var age: String = ""
    @State var steps: String = ""

    var body: some View {
        VStack {
            Spacer()
            InputField(tag: 0, type: .number, title: "Height", text: $height, enabled: .constant(true), focused: $focusedField, onFocus: { _, frame  in
                viewModel.focusedFieldFrame = frame
            })
            InputField(tag: 1, type: .number, title: "Weight", text: $height, enabled: .constant(true), focused: $focusedField, onFocus: { _, frame  in
                viewModel.focusedFieldFrame = frame
            })
            Spacer()
            InputField(tag: 2, type: .number, title: "Age", text: $height, enabled: .constant(true), focused: $focusedField, onFocus: { _, frame  in
                viewModel.focusedFieldFrame = frame
            })
            Spacer()

            InputField(tag: 3, type: .number, title: "Number of daily steps", text: $height, enabled: .constant(true), focused: $focusedField, onFocus: { _, frame  in
                viewModel.focusedFieldFrame = frame
            })
            Spacer()
        }
        .textFieldStyle(.roundedBorder)
        .keyboardType(.numberPad)
        .padding(.horizontal)
    }
}

struct DetailsCollectingStepThree_Previews: PreviewProvider {
    static var previews: some View {
        DetailsCollectingStepThree(viewModel: DetailsCollectingWalkthroughViewModel())
    }
}
