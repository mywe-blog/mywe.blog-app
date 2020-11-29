import Foundation

enum SettingsComponentAction {
    case setLocation(Int)
    case setAccessToken(String)
    case setRepoName(String)
    case setLocalPath(String)
    case save
    case dismiss
}
