//
//  Profile.swift
//  Valify
//
//  Created by Nico Samuelson on 05/05/24.
//

import SwiftUI
import Auth

struct ProfileButton: View {
    @Binding var profileSheet: Bool
    @Binding var isAuthenticated: Bool
    @Binding var currentUser: User?
    
    var body: some View {
        Button {
            profileSheet = true
        } label: {
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 28, height: 28)
                .aspectRatio(contentMode: .fit)
        }
        .sheet(isPresented: $profileSheet) {
            NavigationView {
                VStack(alignment: .leading) {
                    HStack {
                        ZStack {
                            Circle()
                                .frame(width: 64, height: 64)
                                .foregroundStyle(.secondary)
                            Text((isAuthenticated ? currentUser?.email?.prefix(1).uppercased() : "-") ?? "-")
                                .font(.title2)
                                .foregroundStyle(.white)
                        }
                        
                        Text((isAuthenticated ? currentUser?.email : "You are not logged in") ?? "You are not logged in")
                            .padding(.leading, 8)
                    }
                    .padding(.top, 16)
                    
                    if(isAuthenticated) {
                        Button(action: {
                            isAuthenticated = false
                            currentUser = nil
                        }) {
                            Text("Log Out")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(.secondary)
                                .foregroundStyle(.red)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .padding(.vertical, 16)
                    }
                    else {
                        LoginButton(currentUser: $currentUser)
                    }
                }
                .padding(.horizontal, 20)
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
            }
            .presentationDetents([.fraction(0.25)])
        }
    }
}
