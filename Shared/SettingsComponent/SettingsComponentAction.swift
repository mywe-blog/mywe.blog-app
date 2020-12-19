import Foundation

enum SettingsComponentAction {
    case setEnteredServerPath(String)
    case setLocation(Int)
    case setAccessToken(String)
    case setRepoName(String)
    case setLocalPath(String)
    case setIdentifierName(String)
    case save
    case dismiss
}
