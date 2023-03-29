//
//  DetailsCollectionStepTwo.swift
//  DetailsForm
//
//  Created by Marwan Aziz on 25/03/2023.
//

import SwiftUI

struct DetailsCollectionStepTwo: View {

    @StateObject var viewModel: DetailsCollectingWalkthroughViewModel
    @State var address1: String = ""
    @State var address2: String = ""
    @State var city: String = ""
    @State var country: String = ""
    @State var focusedField: Int = 0

    var body: some View {
        VStack {
            InputField(tag: 0, type: .text, title: "Address line one", text: $address1, enabled: .constant(true), focused: $focusedField, onFocus: { _, frame  in
                viewModel.focusedFieldFrame = frame
            })
            Spacer()
            InputField(tag: 1, type: .text, title: "Address line two", text: $address1, enabled: .constant(true), focused: $focusedField, onFocus: { _, frame  in
                viewModel.focusedFieldFrame = frame
            })
            Spacer()
            InputField(tag: 2, type: .text, title: "City", text: $address1, enabled: .constant(true), focused: $focusedField, onFocus: { _, frame  in
                viewModel.focusedFieldFrame = frame
            })
            Spacer()
            InputField(tag: 3, type: .text, title: "Country", text: $address1, enabled: .constant(true), focused: $focusedField, onFocus: { _, frame  in
                viewModel.focusedFieldFrame = frame
            })
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct DetailsCollectionStepTwo_Previews: PreviewProvider {
    static var previews: some View {
        DetailsCollectionStepTwo(viewModel: DetailsCollectingWalkthroughViewModel())
    }
}
