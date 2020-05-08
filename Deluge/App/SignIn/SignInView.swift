//
//  SignIn.swift
//  Deluge
//
//  Created by Emil Landron on 5/4/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import SwiftUI

struct SignInView: View {
    
    @ObservedObject var viewModel: SignInViewModel
    
    @State var endpoint = ""
    @State var password = ""
    
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
                    self.viewModel.signIn(endpoint: self.endpoint, password: self.password)
                })
                .buttonStyle(FilledButtonStyle())
                Spacer()
            }
            
            Spacer()
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding(.horizontal)
        .edgesIgnoringSafeArea(.top)
        .alert(isPresented: $viewModel.isSignInErrorPresented, content: {
            Alert(
                title: Text("Sign In"),
                message: Text("Sign in failed. Please try again")
            )
        })
    }
}

struct SignInView_Previews: PreviewProvider {
    
    static var previews: some View {
        SignInView(viewModel: .init(credentialsValueSubject: .init(nil)))
    }
}
