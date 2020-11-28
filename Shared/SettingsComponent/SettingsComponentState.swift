import Foundation

struct SettingsComponentState: Equatable {
    var accessToken: String = ""
    var repoName: String = ""
    var showsEmptyRequiredFieldWarning = false
}
