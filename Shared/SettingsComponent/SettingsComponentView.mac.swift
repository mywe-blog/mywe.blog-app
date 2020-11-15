import SwiftUI
import ComposableArchitecture

struct SettingsComponentView: View {
    let store: Store<SettingsComponentState, SettingsComponentAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                List {
                    Section {
                        SecureField(
                            "Access token",
                            text: viewStore.binding(
                                get: { $0.accessToken },
                                send: SettingsComponentAction.setAccessToken)
                        )
                        TextField(
                            "Repo name (username/reponame)",
                            text: viewStore.binding(
                                get: { $0.repoName },
                                send: SettingsComponentAction.setRepoName)
                        )
                        .disableAutocorrection(true)
                        if viewStore.showsEmptyRequiredFieldWarning {
                            Text("accessToken and repoName must not be empty")
                        }
                    }
                }
                .navigationTitle("Settings")
            }
        }
    }
}
