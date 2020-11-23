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

        let service = MyWeBlogService(baseURL: URL(string: "https://myweblog-api.herokuapp.com")!,
                                      client: URLSession.shared)

        let secretsStore = SecretsStore()
        let enviornment = EntryComposeEnviornment(mainQueue: queue,
                                                  service: service,
                                                  secretsStore: secretsStore)

        let accessToken: String?
        let repoName: String?
        let contentPath: String?

        switch secretsStore.contentLocation {
        case .github(let repo, let token):
            accessToken = token
            repoName = repo
        case .local(let path):
            accessToken = nil
            repoName = nil
            contentPath = path
        case .none:
            accessToken = nil
            repoName = nil
            contentPath = nil
        }

        let settingsState = SettingsComponentState(
            accessToken: accessToken ?? "",
            repoName: repoName ?? ""
        )

        let store = Store(initialState: EntryComposeState(settingsState: settingsState),
                          reducer: entryComposeReducer.debug(),
                          environment: enviornment)

        return EntryComposeView(store: store)
    }
}
