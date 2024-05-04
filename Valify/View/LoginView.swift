//
//  LoginView.swift
//  Valify
//
//  Created by Nico Samuelson on 02/05/24.
//

import SwiftUI
import AuthenticationServices
import Auth

//class SignInViewModel: ObservableObject {
    
//    let signInApple = SignInApple()
    
//    func signIn() async throws {
//        signInApple.startSignInWithAppleFlow { result in
//            switch result {
//            case .success(let appleResult):
//                Task {
//                    try await signInWithApple(idToken: appleResult.idToken, nonce: appleResult.nonce)
//                }
//                
//            case .failure(_):
//                print("error")
//            }
//        }
//    }
//}

struct LoginView: View {
//    @StateObject var viewModel = SignInViewModel()
    @Binding var currentUser: User?
    
    var body: some View {
        SignInWithAppleButton { request in
            request.requestedScopes = [.email, .fullName]
        } onCompletion: { result in
            Task {
                do {
                    guard let credential = try result.get().credential as? ASAuthorizationAppleIDCredential
                    else {
                        return
                    }
                    
                    guard let idToken = credential.identityToken
                        .flatMap({ String(data: $0, encoding: .utf8) })
                    else {
                        return
                    }
                    let session = try await supabaseAuth.signInWithIdToken(
                        credentials: .init(
                            provider: .apple,
                            idToken: idToken
                        )
                    )
                    
                    currentUser = session.user
                } catch {
                    dump(error)
                }
            }
        }
        .fixedSize()
    }
}

//#Preview {
//    LoginView(currentuser)
//}
