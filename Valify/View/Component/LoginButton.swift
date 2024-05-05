//
//  LoginView.swift
//  Valify
//
//  Created by Nico Samuelson on 02/05/24.
//

import SwiftUI
import AuthenticationServices
import Auth

struct LoginButton: View {
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
        .frame(maxWidth: .infinity, maxHeight: 48)
    }
}

//#Preview {
//    LoginView(currentuser)
//}
