import Foundation
import ComposableArchitecture

let settingsComponentReducer = Reducer<SettingsComponentState,
                                       SettingsComponentAction,
                                       SettingsComponentEnviornment> { state, action, env in
    switch action {
    case .setAccessToken(let string):
        if state.repoName.isEmpty && string.isEmpty {
            state.showsEmptyRequiredFieldWarning = true
        } else {
            state.showsEmptyRequiredFieldWarning = false
        }

        state.accessToken = string

        return .none
    case .setRepoName(let string):
        if state.accessToken.isEmpty && string.isEmpty {
            state.showsEmptyRequiredFieldWarning = true
        } else {
            state.showsEmptyRequiredFieldWarning = false
        }

        state.repoName = string

        return .none
    case .save:
        guard !state.accessToken.isEmpty && !state.repoName.isEmpty else {
            state.showsEmptyRequiredFieldWarning = true
            return .none
        }

        env.secretsStore.accessToken = state.accessToken
        env.secretsStore.repoName = state.repoName

        return Effect(value: SettingsComponentAction.dismiss)
    case .dismiss:
        return .none
    }
}

