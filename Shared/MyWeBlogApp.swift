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
        let service = MyWeBlogService(baseURL: URL(string: "https://myweblog-api.herokuapp.com")!,
                                      client: URLSession.shared)

        let enviornment = EntryComposeEnviornment(mainQueue: queue,
                                                  service: service,
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
