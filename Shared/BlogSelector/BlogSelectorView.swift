import SwiftUI
import ComposableArchitecture

struct BlogSelectorView: View {
    let store: Store<BlogSelectorState, BlogSelectorAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: [.init(), .init()]) {
                        ForEachStore(
                            self.store.scope(
                                state: \.allComposeComponentStates,
                                action: BlogSelectorAction.entryComposeAction
                            ),
                            content: { store in
                                WithViewStore(store) { viewStore in
                                    NavigationLink(
                                        destination: EntryComposeView(store: store)
                                    ) {
                                        BlogSelectorItemView(store: store)
                                    }
                                    .contextMenu {
                                        NavigationLink(destination: Text("Test")) {
                                            Label("Settings", image: "gear")
                                        }
                                        Button {
                                            // TODO: Add delete
                                            viewStore.send(.deleteBlog)
                                        } label: {
                                            Label("Delete", image: "trash")
                                                .foregroundColor(.red)
                                        }

                                    }
                                }
                            }
                        )
                    }
                    .padding()
                }
                .navigationTitle("Blogs")
            }
        }
    }
}

struct BlogSelectorItemView: View {
    let store: Store<EntryComposeState, EntryComposeAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            GroupBox(
                label: Label(viewStore.settingsState.blogConfig.serviceIdentifier,
                             systemImage: "heart.fill")
                    .foregroundColor(.red)
            ) {
                Text(viewStore.settingsState.blogConfig.urlString)
            }
            .groupBoxStyle(DefaultGroupBoxStyle())
        }
    }
}
