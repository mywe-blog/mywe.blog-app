import Foundation

struct SettingsComponentState: Equatable {
    enum Location: String, CaseIterable {
        case github
        case local
    }

    // TODO: Model state to match enum
    var blogConfig: BlogConfiguration
    var enteredServerPath: String
    var locationIndex = 0
    var localPath = ""
    var identifierName: String
    var accessToken: String = ""
    var repoName: String = ""
    var showsEmptyRequiredFieldWarning = false
}
