//
//  SignIn.swift
//  Deluge
//
//  Created by Emil Landron on 5/4/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import SwiftUI

struct SignInView: View {
    
    @EnvironmentObject var store: AppStore

    @State var endpoint = "https://deluge.orembo.com"
    @State var password = "@Mira0329"
    
    var body: some View {
        
        ScrollView {
            
            Spacer(minLength: 120)
            
            Text("Welcome!")
                .font(.largeTitle)
            
            Image("Deluge")
                .padding(.vertical)
            
            TextField("Endpoint (https://example.com)", text: $endpoint)
            SecureField("Password", text: $password)
    
            Spacer(minLength: 64)
            
            HStack {
                Spacer()
                Button("Sign In", action: {
                    self.signIn(endpoint: self.endpoint, password: self.password)
                })
                .buttonStyle(FilledButtonStyle())
                Spacer()
            }
            
            Spacer()
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding(.horizontal)
        .edgesIgnoringSafeArea(.top)
//        .alert(isPresented: $viewModel.isSignInErrorPresented, content: {
//            Alert(
//                title: Text("Sign In"),
//                message: Text("Sign in failed. Please try again")
//            )
//        })
    }
    
    func signIn(endpoint: String, password: String) {
        
        guard let endpoint = URL(string: endpoint) else {
            // TODO: Error
            return
        }
        
        let session = Session(endpoint: endpoint, password: password)
        store.send(SignInAction(session: session))
    }
}

struct SignInView_Previews: PreviewProvider {
    
    static var previews: some View {
        SignInView()
    }
}
