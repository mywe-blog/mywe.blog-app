import SwiftUI
import ComposableArchitecture

@main
struct MyWeBlogApp: App {
    var body: some Scene {
        WindowGroup {
            entryComposeView
        }
    }

    var entryComposeView: EntryComposeView {
        let queue = DispatchQueue.main.eraseToAnyScheduler()

        let secretsStore = SecretsStore()
        let enviornment = EntryComposeEnviornment(mainQueue: queue,
                                                  service: MyWeBlogService(baseURL: URL(string: "http://127.0.0.1:3000")!,
                                                                        client: URLSession.shared),
                                                  secretsStore: secretsStore)

        let settingsState = SettingsComponentState(
            accessToken: secretsStore.accessToken ?? "",
            repoName: secretsStore.repoName ?? ""
        )

        let store = Store(initialState: EntryComposeState(settingsState: settingsState),
                          reducer: entryComposeReducer.debug(),
                          environment: enviornment)

        return EntryComposeView(store: store)
    }
}
