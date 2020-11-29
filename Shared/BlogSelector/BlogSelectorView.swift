import SwiftUI
import ComposableArchitecture

struct BlogSelectorView: View {
    let store: Store<BlogSelectorState, BlogSelectorAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: [.init(), .init()]) {
                        ForEach(viewStore.allBlogs) { blog in
                            GroupBox(
                                label: Label(blog.serviceIdentifier,
                                             systemImage: "heart.fill")
                                    .foregroundColor(.red)
                            ) {
                                Text(blog.urlString)
                            }.groupBoxStyle(DefaultGroupBoxStyle())
                            .onTapGesture {
                                viewStore.send(.selectBlog(blog))
                            }
                            .contextMenu {
                                Button {
                                    viewStore.send(.showSettings(blog))
                                } label: {
                                    Label("Settings", image: "gearshape.fill")
                                }

                            }
                        }
                    }.padding()
                }
                .navigationTitle("Blogs")
                .popover(
                    isPresented: viewStore.binding(get: { $0.showsSettings},
                                                   send: BlogSelectorAction.setShowSettingsActive)) {
                    settingsView(store: store)
                }
                .navigate(to: composeView(viewStore: viewStore),
                          isActive: viewStore.binding(get: { $0.navigationActive }, send: BlogSelectorAction.setNavigationActive))
            }
        }
    }

    private func composeView(viewStore: ViewStore<BlogSelectorState, BlogSelectorAction>) -> some View {
        let composeStore = store.scope(
            state: \.composeComponentState,
            action: BlogSelectorAction.entryComposeAction
        )

        return EntryComposeView(store: composeStore)
    }

    private func settingsView(store: Store<BlogSelectorState, BlogSelectorAction>) -> some View {
        let store = store.scope(state: \.settingsState,
                                action: BlogSelectorAction.settingsAction)
        return SettingsComponentView(store: store)
    }
}
