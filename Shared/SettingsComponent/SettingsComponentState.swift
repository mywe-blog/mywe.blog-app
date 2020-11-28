import Foundation

struct SettingsComponentState: Equatable {
    var blogConfig = BlogConfiguration(serviceIdentifier: "", urlString: "")
    var accessToken: String = ""
    var repoName: String = ""
    var showsEmptyRequiredFieldWarning = false
}
