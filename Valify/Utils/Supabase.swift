//
//  Supabase.swift
//  Valify
//
//  Created by Nico Samuelson on 02/05/24.
//

import Foundation
import Supabase

let supabase = SupabaseClient(supabaseURL: URL(string: "https://wtdyrutekswuhitfzjvg.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind0ZHlydXRla3N3dWhpdGZ6anZnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTQ2NDQwOTUsImV4cCI6MjAzMDIyMDA5NX0.E_pTFJsAf65lqv_9anNxcSTbNxeG38D2d-RS6gpOleI")
let supabaseAuth = supabase.auth


func signInWithApple(idToken: String, nonce: String) async throws {
    let creds = OpenIDConnectCredentials(provider:.apple, idToken: idToken, accessToken: nonce, nonce: nonce)
    
    let session = try await supabase.auth.signInWithIdToken(credentials: creds)
}

func currentSession() async throws {
    let session = try await supabaseAuth.session
    print(session)
}
