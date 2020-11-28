import SwiftUI
import ComposableArchitecture

struct BlogSelectorState: Equatable {
    var allBlogs: [BlogConfiguration]
    var composeComponentState = EntryComposeState()
    var settingsState = SettingsComponentState()

    var navigationActive = false
    var showsSettings = false
}

struct BlogSelectorEnviornment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    let client: Client
    let secretsStore: SecretsStore
}

enum BlogSelectorAction {
    case selectBlog(BlogConfiguration)
    case entryComposeAction(EntryComposeAction)
    case setNavigationActive(Bool)
    case showSettings(BlogConfiguration)
    case settingsAction(SettingsComponentAction)
    case setShowSettingsActive(Bool)
}

let blogSelectorReducer = Reducer<BlogSelectorState, BlogSelectorAction, BlogSelectorEnviornment>.combine(
    Reducer { state, action, enviornment in
        switch action {
        case .selectBlog(let blog):
            let queue = DispatchQueue.main.eraseToAnyScheduler()

            let accessToken: String?
            let repoName: String?
            let contentPath: String?

            let settingsState = enviornment.secretsStore.settingsComponentState(from: blog)

            state.navigationActive = true
            state.composeComponentState = EntryComposeState(blogConfig: blog,
                                                            settingsState: settingsState)

            return .none
        case .entryComposeAction(let action):

            return .none
        case .setNavigationActive(let value):
            state.navigationActive = value

            return .none
        case .showSettings(let blog):
            let settingsState = enviornment.secretsStore.settingsComponentState(from: blog)
            state.settingsState = settingsState
            state.showsSettings = true

            return .none
        case .settingsAction(let action):
            switch action {
            case .dismiss:
                state.showsSettings = false

                return .none
            default:
                return .none
            }
        case .setShowSettingsActive(let value):
            state.showsSettings = value

            return .none
        }
    },
    entryComposeReducer.pullback(state: \BlogSelectorState.composeComponentState,
                                 action: /BlogSelectorAction.entryComposeAction,
                                 environment: { env in
                                    return EntryComposeEnviornment(mainQueue: env.mainQueue,
                                                                   client: env.client,
                                                                   secretsStore: env.secretsStore)
                                 }),
    settingsComponentReducer.pullback(state: \BlogSelectorState.settingsState,
                                      action: /BlogSelectorAction.settingsAction,
                                      environment: { env in
                                        return SettingsComponentEnviornment(secretsStore: env.secretsStore)
                                      })
)

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
