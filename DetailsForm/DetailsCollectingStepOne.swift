//
//  DetailsCollectingStepOne.swift
//  DetailsForm
//
//  Created by Marwan Aziz on 25/03/2023.
//

import SwiftUI

struct DetailsCollectingStepOne: View {
    @StateObject var viewModel: DetailsCollectingWalkthroughViewModel
    @State var title: String = ""
    @State var firstName: String = ""
    @State var surname: String = ""
    @State var jobTitle: String = ""
    @State var focusedField: Int = 0

    var body: some View {
        VStack {
            InputField(tag: 0, type: .text, title: "Title", text: $title, enabled: .constant(true), focused: $focusedField, onFocus: { _, frame  in
                viewModel.focusedFieldFrame = frame
            })
            Spacer()
            InputField(tag: 1, type: .text, title: "First name", text: $title, enabled: .constant(true), focused: $focusedField, onFocus: { _, frame  in
                viewModel.focusedFieldFrame = frame
            })
            Spacer()
            InputField(tag: 2, type: .text, title: "Surname", text: $title, enabled: .constant(true), focused: $focusedField, onFocus: { _, frame  in
                viewModel.focusedFieldFrame = frame
            })
            Spacer()
            InputField(tag: 3, type: .text, title: "Job title", text: $title, enabled: .constant(true), focused: $focusedField, onFocus: { _, frame  in
                viewModel.focusedFieldFrame = frame
            })
            Spacer()
            InputField(tag: 4, type: .text, title: "Job Duration", text: $title, enabled: .constant(true), focused: $focusedField, onFocus: { _, frame  in
                viewModel.focusedFieldFrame = frame
            })
            Spacer()
            

        }
        .textFieldStyle(.roundedBorder)
        .padding(.horizontal)
    }
}

struct DetailsCollectingStepOne_Previews: PreviewProvider {
    static var previews: some View {
        DetailsCollectingStepOne(viewModel: DetailsCollectingWalkthroughViewModel(), focusedField: 0)
    }
}
