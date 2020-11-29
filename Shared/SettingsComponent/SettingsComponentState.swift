import Foundation

struct SettingsComponentState: Equatable {
    enum Location: String, CaseIterable {
        case github
        case local
    }

    var blogConfig = BlogConfiguration(serviceIdentifier: "", urlString: "")
    var locationIndex = 0
    var localPath = ""
    var accessToken: String = ""
    var repoName: String = ""
    var showsEmptyRequiredFieldWarning = false
}
