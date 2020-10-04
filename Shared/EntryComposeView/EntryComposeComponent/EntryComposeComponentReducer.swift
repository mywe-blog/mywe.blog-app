import Foundation
import ComposableArchitecture
import Combine

let entryComposeComponentReducer = Reducer<EntryComposeComponentState, EntryComposeComponentAction, EntryComposeComponentEnviornment> { state, action, env in
    switch action {
    case .delete:
        return .none
    case .changeText(let text):
        state.componentType = .paragraph(text)
        return .none
    case .changeImage(let url):
        guard let url = url else {
            return .none
        }

        state.componentType = .imageURL(url)

        return .none
    case .uploadImageIfNeeded:
        switch state.componentType {
        case .uploadingImage(let data, let startUpload) where startUpload == true:
            guard let accessToken = env.secretsStore.accessToken,
                  let repo = env.secretsStore.repoName else {
                return .none
            }

            state.componentType = .uploadingImage(data, startUpload: false)

            let upload: Future<ImageUploadContent, Error> = env
                .service
                .perform(endpoint: .uploadImage(repo: repo,
                                                 accessToken: accessToken,
                                                 imageData: data))
            return upload
                .catchToEffect()
                .map { result in
                    print("Result \(result)")
                    switch result {
                    case .success(let uploadCntent):
                        return .changeImage(URL(string: uploadCntent.content.downloadUrl))
                    case .failure:
                        return .changeImage(nil)
                    }
                }
        default:
            return .none
        }
    }

}
