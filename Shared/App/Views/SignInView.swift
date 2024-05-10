//
//  SignIn.swift
//  Deluge
//
//  Created by Emil Landron on 5/4/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import SwiftUI

struct SignInView: View {

    @Bindable var viewModel: SignInViewModel

    var body: some View {

        ScrollView {

            Spacer(minLength: 120)

            Text("Welcome!")
                .font(.largeTitle)

            Image("Deluge")
                .padding(.vertical)

            TextField("Endpoint (https://example.com)", text: $viewModel.endpoint)
            SecureField("Password", text: $viewModel.password)

            Spacer(minLength: 64)

            HStack {
                Spacer()

                Button("Sign In") {
                    viewModel.signIn()
                }
                .buttonStyle(.borderedProminent)

                Spacer()
            }

            Spacer()
        }
        .textFieldStyle(.roundedBorder)
        .padding(.horizontal)
        .edgesIgnoringSafeArea(.top)
        .alert(isPresented: $viewModel.isSignInErrorAlertPresented) {
            Alert(
                title: Text("Sign In"),
                message: Text("Sign in failed. Please try again")
            )
        }
    }
}

#Preview {
    @Bindable var viewModel = SignInViewModel(onSignedIn: { _ in })
    return SignInView(viewModel: viewModel)
}
