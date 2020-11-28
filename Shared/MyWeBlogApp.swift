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
        let blog1 = BlogConfiguration(serviceIdentifier: "test-app",
                                      urlString: "https://myweblog-api.herokuapp.com")

        let state = BlogSelectorState(allBlogs: [blog1])

        let store1 = Store(initialState: state,
                           reducer: blogSelectorReducer.debug(),
                           environment: BlogSelectorEnviornment())

        return BlogSelectorView(store: store1)
    }
}
