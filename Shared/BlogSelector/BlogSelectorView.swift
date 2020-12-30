import SwiftUI
import ComposableArchitecture

struct BlogSelectorView: View {
    let store: Store<BlogSelectorState, BlogSelectorAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: [.init()]) {
                        ForEachStore(
                            self.store.scope(
                                state: \.allComposeComponentStates,
                                action: BlogSelectorAction.entryComposeAction
                            ),
                            content: { store in
                                WithViewStore(store) { composeViewStore in
                                    NavigationLink(
                                        destination: EntryComposeView(store: store)
                                    ) {
                                        BlogSelectorItemView(store: store)
                                    }
                                    .contextMenu {
                                        Button {
                                            viewStore.send(.showSettings(composeViewStore.settingsState))
                                        } label: {
                                            Label("Settings", image: "gear")
                                                .foregroundColor(.red)
                                        }
                                        Button {
                                            composeViewStore.send(.deleteBlog)
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
                .navigationBarItems(trailing:
                                        Button(
                                            action: { viewStore.send(.addBlog) },
                                            label: { Image(systemName: "plus") }
                                        )
                )
                .navigationTitle("Blogs")
                .popover(
                    isPresented: viewStore.binding(get: { $0.showsSettings},
                                                   send: BlogSelectorAction.setShowSettingsActive)) {
                    IfLetStore(
                        self.store.scope(
                            state: \.selectedSettingsComponentsState,
                            action: BlogSelectorAction.settingsAction
                        ), then: { store in
                            SettingsComponentView(store: store)
                        })
                }
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
