import Foundation
import ComposableArchitecture

let settingsComponentReducer = Reducer<SettingsComponentState,
                                       SettingsComponentAction,
                                       SettingsComponentEnviornment> { state, action, env in
    switch action {
    case .setEnteredServerPath(let path):
        state.enteredServerPath = path

        return .none
    case .setLocation(let index):
        state.locationIndex = index

        return .none
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
    case .setLocalPath(let path):
        state.localPath = path

        return .none
    case .save:
        let type = SettingsComponentState.Location.allCases[state.locationIndex]

        switch type {
        case .github:
            guard !state.accessToken.isEmpty && !state.repoName.isEmpty else {
                state.showsEmptyRequiredFieldWarning = true
                return .none
            }

            state.showsEmptyRequiredFieldWarning = true
            env.secretsStore.setContentLocation(.github(repo: state.repoName,
                                                        accessToken: state.accessToken),
                                                for: state.blogConfig)
        case .local:
            guard !state.localPath.isEmpty else {
                state.showsEmptyRequiredFieldWarning = true
                return .none
            }

            state.showsEmptyRequiredFieldWarning = false
            env.secretsStore.setContentLocation(.local(path: state.localPath),
                                                for: state.blogConfig)

        }

        var config = state.blogConfig
        config.urlString = state.enteredServerPath
        state.blogConfig = config

        env.configStore.store(configuration: config)

        
        return Effect(value: SettingsComponentAction.dismiss)
    case .dismiss:
        return .none
    }
}

