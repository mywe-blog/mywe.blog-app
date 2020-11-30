import SwiftUI
import ComposableArchitecture

@main
struct MyWeBlogApp: App {
    var body: some Scene {
        WindowGroup {
            entryComposeView
        }
    }

    var entryComposeView: BlogSelectorView {
//        let blog1 = BlogConfiguration(serviceIdentifier: "test-app",
//                                      urlString: "https://myweblog-api.herokuapp.com")
//
//        let blog2 = BlogConfiguration(serviceIdentifier: "local",
//                                      urlString: "http://0.0.0.0:3000")

        let state = BlogSelectorState(allBlogs: BlogConfigurationStore().allConfigurations)
        let secretStore = SecretsStore()
        let queue = DispatchQueue.main.eraseToAnyScheduler()

        let store1 = Store(initialState: state,
                           reducer: blogSelectorReducer.debug(),
                           environment: BlogSelectorEnviornment(mainQueue: queue,
                                                                client: URLSession.shared,
                                                                secretsStore: secretStore,
                                                                configStore: BlogConfigurationStore()))

        return BlogSelectorView(store: store1)
    }
}
