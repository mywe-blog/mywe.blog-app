import Foundation
import ComposableArchitecture

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
                                                                   secretsStore: env.secretsStore,
                                                                   configStore: env.configStore)
                                 }),
    settingsComponentReducer.pullback(state: \BlogSelectorState.settingsState,
                                      action: /BlogSelectorAction.settingsAction,
                                      environment: { env in
                                        return SettingsComponentEnviornment(secretsStore: env.secretsStore, configStore: env.configStore)
                                      })
)
