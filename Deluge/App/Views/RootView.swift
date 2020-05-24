//
//  RootView.swift
//  Deluge
//
//  Created by Emil Landron on 5/4/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var store: AppStore

    var body: some View {
        
        var signInView: SignInView?
        var mainView: MainView?
        
        switch store.state.session.signInState {
        case .signingIn, .signOut:
            signInView = SignInView()

        case .signedIn:
            mainView = MainView()
        }
        
        return Group {
            signInView
            mainView
        }
    }
}

struct RootView_Previews: PreviewProvider {
    
    static var previews: some View {
        RootView()
            .environmentObject(store)
    }
}
