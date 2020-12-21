//
//  SearchBar.swift
//
//  Created by Eric Ito on 12/17/20.
//

import SwiftUI

struct SearchBar: View {

    enum Style {
        case xButton
        case cancelButton
    }

    @Binding
    var text: String

    @State
    private var isEditing = false

    let placeholderText: String
    let style: Style

    init(text: Binding<String>, placeholderText: String = "Search", style: Style = .xButton) {
        self._text = text
        self.placeholderText = placeholderText
        self.style = style
    }

    var body: some View {
        ZStack {
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "magnifyingglass")
                        .renderingMode(.template)

                    TextField(placeholderText, text: $text, onEditingChanged: { editing in
                        withAnimation {
                            isEditing = editing
                        }
                    })
                    .foregroundColor(Color(.label))
                    .frame(minHeight: 36)
                    .layoutPriority(1)

                    if style == .xButton && shouldShowCancelButton {
                        Button(action: {
                            cancelAction()
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .renderingMode(.template)
                                .imageScale(.medium)
                        })
                        .padding(.trailing, 6)
                        .transition(.opacity)
                    }
                }
                .padding(.leading, 6)
                .foregroundColor(Color(.placeholderText))
                .background(Color(.tertiarySystemFill))
                .cornerRadius(10.0)

                if style == .cancelButton && shouldShowCancelButton {
                    Button(action: {
                        cancelAction()
                    }, label: {
                        Text("Cancel")
                            .foregroundColor(.blue)
                    })
                    .transition(.move(edge: .trailing))
                }
            }
        }
    }

    private var shouldShowCancelButton: Bool {
        isEditing || !text.isEmpty
    }

    private func cancelAction() {
        text = ""
        self.hideKeyboard()
    }
}

private extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#if DEBUG
struct SearchBar_Previews: PreviewProvider {

    static let dynamicTypeSizes: [ContentSizeCategory] = [.extraSmall, .large, .extraExtraExtraLarge]

    static var previews: some View {
        Group {

            ForEach(dynamicTypeSizes, id: \.self) { sizeCategory in

                SearchBar(text: .constant(""))
                    .padding()
                    .environment(\.sizeCategory, sizeCategory)

                SearchBar(text: .constant(""))
                    .padding()
                    .background(Color(.systemBackground))
                    .environment(\.colorScheme, .dark)
                    .environment(\.sizeCategory, sizeCategory)
            }

            SearchBar(text: .constant("text"), style: .xButton)
                .padding()

            SearchBar(text: .constant("text"), style: .xButton)
                .padding()
                .background(Color(.systemBackground))
                .environment(\.colorScheme, .dark)

            SearchBar(text: .constant("text"), style: .cancelButton)
                .padding()
                .previewDisplayName("Light, cancel text")

            SearchBar(text: .constant("text"), style: .cancelButton)
                .padding()
                .background(Color(.systemBackground))
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark, cancel text")
        }
        .previewLayout(PreviewLayout.fixed(width: 380, height: 68))
    }
}
#endif

