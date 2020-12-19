import SwiftUI
import ComposableArchitecture

struct SettingsComponentView: View {
    let store: Store<SettingsComponentState, SettingsComponentAction>

    var colors = ["Red", "Green", "Blue"]

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                List {
                    Section {
                        TextField(
                            "https://myweblog-api.herokuapp.com",
                            text: viewStore.binding(
                                get: { $0.identifierName },
                                send: SettingsComponentAction.setIdentifierName)
                        )
                    }
                    Section {
                        Picker(
                            selection: viewStore.binding(get: { $0.locationIndex }, send: SettingsComponentAction.setLocation),
                            label: Text("Content Location")
                        ) {
                            ForEach(0..<SettingsComponentState.Location.allCases.count) { index in
                                Text(SettingsComponentState.Location.allCases[index].rawValue).tag(index)
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                        TextField(
                            "https://myweblog-api.herokuapp.com",
                            text: viewStore.binding(
                                get: { $0.enteredServerPath },
                                send: SettingsComponentAction.setEnteredServerPath)
                        )
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                    }
                    Section {
                        if SettingsComponentState.Location.allCases[viewStore.locationIndex] == .github {
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
                            .autocapitalization(.none)
                        } else {
                            TextField(
                                "Local path",
                                text: viewStore.binding(
                                    get: { $0.localPath },
                                    send: SettingsComponentAction.setLocalPath)
                            )
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                        }
                        if viewStore.showsEmptyRequiredFieldWarning {
                            Text("accessToken and repoName must not be empty")
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .navigationTitle("Settings")
                .navigationBarItems(leading:
                                        Button(action: {
                                            viewStore.send(.save)
                                        }, label: {
                                            Text("Save")
                                        })
                )
            }
        }
    }
}
