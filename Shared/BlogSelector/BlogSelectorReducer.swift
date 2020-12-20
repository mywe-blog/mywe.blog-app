import Foundation
import ComposableArchitecture

let blogSelectorReducer = Reducer<BlogSelectorState, BlogSelectorAction, BlogSelectorEnviornment>.combine(
    entryComposeReducer.forEach(state: \BlogSelectorState.allComposeComponentStates,
                                         action: /BlogSelectorAction.entryComposeAction,
                                         environment: { env in
                                            return EntryComposeEnviornment(mainQueue: env.mainQueue,
                                                                           client: env.client,
                                                                           secretsStore: env.secretsStore,
                                                                           configStore: env.configStore)
                                         }),
    settingsComponentReducer
        .optional()
        .pullback(state: \BlogSelectorState.selectedSettingsComponentsState,
                  action: /BlogSelectorAction.settingsAction, environment: { enviornment in
                    return SettingsComponentEnviornment(secretsStore: enviornment.secretsStore, configStore: enviornment.configStore)
                  }),
    Reducer { state, action, enviornment in
        switch action {
        case .entryComposeAction(let index, let entryComposeAction):
            switch entryComposeAction {
            case .deleteBlog:
                let config = state.allComposeComponentStates[index].settingsState.blogConfig

                enviornment.secretsStore.setContentLocation(nil, for: config)
                enviornment.configStore.delete(configuration: config)

                state.allComposeComponentStates.remove(at: index)
                return .none
            default:
                return .none
            }
        case .showSettings(let settingsState):
            state.showsSettings = true
            state.selectedSettingsComponentsState = settingsState

            return .none
        case .setShowSettingsActive(let value):
            state.showsSettings = value

            return .none
        case .delete(let config):
            enviornment.secretsStore.setContentLocation(nil,
                                                        for: config)
            enviornment.configStore.delete(configuration: config)

            if let index = state.allComposeComponentStates.firstIndex(where: { $0.settingsState.blogConfig.id == config.id }) {
                state.allComposeComponentStates.remove(at: index)
            }

            return .none
        case .addBlog:
            let newBlog = BlogConfiguration(serviceIdentifier: "test-app",
                                          urlString: "https://myweblog-api.herokuapp.com")

            enviornment.configStore.store(configuration: newBlog)

            let settingsState = enviornment.secretsStore.settingsComponentState(from: newBlog)
            let composeState = EntryComposeState(settingsState: settingsState)

            state.allComposeComponentStates.append(composeState)

            state.showsSettings = true
            state.selectedSettingsComponentsState = settingsState

            return .none
        case .settingsAction(let action):
            guard let selectedSettings = state.selectedSettingsComponentsState,
                  let index = state.allComposeComponentStates.firstIndex(where: { $0.settingsState.blogConfig.id == selectedSettings.blogConfig.id }) else {
                return .none
            }

            state.allComposeComponentStates.remove(at: index)
            state.allComposeComponentStates.append(EntryComposeState(settingsState: selectedSettings))

            switch action {
            case .dismiss:
                state.showsSettings = false
                state.selectedSettingsComponentsState = nil

                return .none
            default:
                return .none
            }
        }
    }
)
