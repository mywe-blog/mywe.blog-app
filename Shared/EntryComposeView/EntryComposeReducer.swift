import Foundation
import ComposableArchitecture
import Combine

let entryComposeReducer = Reducer<EntryComposeState, EntryComposeAction, EntryComposeEnviornment>.combine(
    entryComposeComponentReducer.forEach(state: \EntryComposeState.componentStates,
                                         action: /EntryComposeAction.composeAction,
                                         environment: { env in
                                            EntryComposeComponentEnviornment(
                                                service: env.service,
                                                secretsStore: env.secretsStore
                                            )
                                         }),
    Reducer { state, action, enviornment in
        switch action {
        case .updateTitle(let title):
            state.title = title
            return .none
        case .addParagraph:
            let paragraphState = EntryComposeComponentState(componentType: .paragraph(""))
            state.componentStates.append(paragraphState)
            return .none
        case .selectImage:
            state.showsImagePicker = true
            return .none
        case .imageSelectionResponse(let data):
            if let data = data {
                let uploadingState = EntryComposeComponentState(componentType: .uploadingImage(data, startUpload: true))
                state.componentStates.append(uploadingState)
            }
            
            return .none
        case .composeAction(let index, let action):
            switch action {
            case .delete:
                state.componentStates.remove(at: index)
                return .none
            default:
                return .none
            }
        case .settingsAction(let action):
            switch action {
            case .dismiss:
                state.showsSettings = false
                return .none
            default:
                return .none
            }
        case .showSettings(let show):
            state.showsSettings = show

            return .none
        case .showsImagePicker(let newValue):
            state.showsImagePicker = newValue
            return .none
        case .move(let items, let position):
            state.componentStates.move(fromOffsets: items, toOffset: position)
            return .none
        case .upload:
            guard let accessToken = enviornment.secretsStore.accessToken,
                  let repo = enviornment.secretsStore.repoName else {
                return .none
            }

            state.uploadButtonTitle = "Uploading"
            state.uploadButtonEnabled = false

            let content = state.componentStates.compactMap { state in
                state.toContentPart()
            }

            let postContent = PostContent(
                repo: repo,
                accessToken: accessToken,
                title: state.title,
                content: content)

            let upload: Future<Empty, Error> = enviornment
                .service
                .perform(endpoint: .createEntry(postContent))
            return upload
                .catchToEffect()
                .map { result in
                    switch result {
                    case .success:
                        return .uploadSuccess(true)
                    case .failure:
                        return .uploadSuccess(false)
                    }
                }
        case .uploadSuccess(let success):
            state.uploadButtonEnabled = true

            if success {
                state.uploadButtonTitle = "Upload"
            } else {
                state.uploadButtonTitle = "Upload failed, try again"
            }

            return .none
        }
    },
    settingsComponentReducer.pullback(state: \EntryComposeState.settingsState,
                                      action: /EntryComposeAction.settingsAction,
                                      environment: { env in
                                        return SettingsComponentEnviornment(secretsStore: env.secretsStore)
                                      })
    )

