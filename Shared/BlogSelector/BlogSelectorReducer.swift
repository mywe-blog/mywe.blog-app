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
    Reducer { state, action, enviornment in
        switch action {
        case .entryComposeAction(let action, _):
            return .none
        case .showSettings(let blog):
            return .none
        case .setShowSettingsActive(let value):
            state.showsSettings = value

            return .none
        case .delete(let config):
            enviornment.secretsStore.setContentLocation(nil,
                                                        for: config)
            enviornment.configStore.delete(configuration: config)

            if let index = state.allComposeComponentStates.firstIndex(where: { $0.blogConfig.id == config.id }) {
                state.allComposeComponentStates.remove(at: index)
            }

            return .none
        }
    }
)
