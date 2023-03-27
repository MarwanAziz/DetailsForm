//
//  InputView.swift
//  DetailsForm
//
//  Created by Marwan Aziz on 25/03/2023.
//

import SwiftUI

import SwiftUI

class StateFocusObserver: ObservableObject {
    @Published var focusIndex: Int = -1
}

enum InputFieldType {
    case text, number, dropdown
}

struct InputField: View {
    let tag: Int
    let type: InputFieldType
    let title: String
    var dropdownItems: Array<String> = []
    var placeholder: String = ""
    @Binding var text: String
    @Binding var enabled: Bool
    @Binding var focused: Int
    var returnKey: SubmitLabel = .return
    var onSubmit: (() -> Void)? = nil
    var onFocus: ((InputField, CGRect) -> Void)? = nil
    var height: CGFloat = 44


    @FocusState private var focusField: Bool

    private let dropdownImage = Image(systemName: "trash")
    @State private var showDropdown: Bool = false


    fileprivate func fieldTitle() -> some View {
        return Text(title)
            .foregroundColor(.gray)
            .frame(alignment: .leading)
    }

    var body: some View {
        GeometryReader { reader in
            ZStack {
                Spacer()
                VStack(alignment: .leading, spacing: 8.0) {
                    fieldTitle()
                    ZStack(alignment: .leading) {
                        // The placeholder view
                        Text(placeholder)
                            .opacity(text.isEmpty ? 1 : 0)
                            .padding(.horizontal, 8)
                        // Text field
                        HStack {
                            ZStack {
                                TextField("", text: $text)
                                    .ignoresSafeArea(.keyboard)
                                    .disabled(!enabled)
                                    .frame(height: height)
                                    .textInputAutocapitalization(.sentences)
                                    .padding(.horizontal, 8)
                                    .keyboardType( type == .number ? .decimalPad : .default)
                                    .submitLabel(returnKey)
                                    .onChange(of: focused, perform: { newValue in
                                        focusField = newValue == tag
                                        if focusField, let onFocus = onFocus {
                                            onFocus(self, reader.frame(in: .global))
                                        }
                                    })
                                    .focused($focusField)
                                    .onChange(of: focusField, perform: { newValue in
                                        if type != .dropdown, newValue, focused != tag {
                                            focused = tag
                                        }
                                    })
                                    .onSubmit {
                                        if let onSubmit = onSubmit {
                                            onSubmit()
                                        } else {
                                            focusField.toggle()
                                        }
                                    }
                                if type == .dropdown {
                                    Text("Suppose to be menu")
                                }
                            }.frame(minHeight: 44)

                            if type == .dropdown {
                                dropdownImage
                                    .padding(.trailing, 5)
                            }
                        }
                        .ignoresSafeArea(.keyboard)

                        .frame(minHeight: 44)
                        .ignoresSafeArea(.keyboard)

                    }
                    .background(.secondary)
                    .cornerRadius(5)
                }
            }
            .frame(maxHeight: height)
            .ignoresSafeArea(.keyboard)

        }
    }
}


struct InputField_Previews: PreviewProvider {
    @FocusState static var focus: Bool
    static var previews: some View {
        InputField(tag: 0,
                   type: .dropdown,
                   title: "title",
                   dropdownItems: ["1", "2", "3"],
                   placeholder: "new field",
                   text: .constant(""),
                   enabled: .constant(true),
                   focused: .constant(-1),
                   onFocus: {_, _ in }
        ).preferredColorScheme(.dark)
    }
}

