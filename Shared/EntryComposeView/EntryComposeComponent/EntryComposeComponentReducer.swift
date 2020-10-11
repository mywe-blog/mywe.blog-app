import Foundation
import ComposableArchitecture
import Combine

let entryComposeComponentReducer = Reducer<EntryComposeComponentState, EntryComposeComponentAction, EntryComposeComponentEnviornment> { state, action, env in
    switch action {
    case .delete:
        return .none
    case .changeParagraph(let text):
        state.componentType = .paragraph(text)
        return .none
    case .changeHeadline(let text):
        state.componentType = .headline(text)
        return .none
    case .changeImage(let data, let url, let filename):
        guard let url = url, let filename = filename else {
            return .none
        }

        state.componentType = .imageURL(data, filename)

        return .none
    }
}
