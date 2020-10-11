import SwiftUI
import ComposableArchitecture

struct EntryComposeComponentView: View {
    let store: Store<EntryComposeComponentState, EntryComposeComponentAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            switch viewStore.componentType {
            case .paragraph:
                MultilineTextEditor(
                    placeholder: "Paragraph",
                    text: viewStore.binding(
                        get: { $0.text },
                        send: EntryComposeComponentAction.changeParagraph
                    )
                )
                .contextMenu {
                    Button {
                        viewStore.send(.delete)
                    } label: {
                        Text("Delete")
                    }
                }
            case .uploadingImage(let data):
                VStack {
                    Image(data: data)?
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .contextMenu {
                            Button {
                                viewStore.send(.delete)
                            } label: {
                                Text("Delete")
                            }
                        }
                    Text("Uploading")
                }
            case .imageURL(let data, _):
                Image(data: data)?
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .contextMenu {
                        Button {
                            viewStore.send(.delete)
                        } label: {
                            Text("Delete")
                        }
                    }
            case .headline:
                MultilineTextEditor(
                    placeholder: "Headline",
                    font: Font.headline,
                    text: viewStore.binding(
                        get: { $0.text },
                        send: EntryComposeComponentAction.changeHeadline
                    )
                )
                .contextMenu {
                    Button {
                        viewStore.send(.delete)
                    } label: {
                        Text("Delete")
                    }
                }
            }
        }
    }
}

