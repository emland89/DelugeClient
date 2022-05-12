//
//  RootView.swift
//  Deluge
//
//  Created by Emil Landron on 5/4/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import SwiftUI

struct RootView: View {
    
    @StateObject var viewModel = RootViewModel()

    var body: some View {
        
        switch viewModel.attached {
        case .signIn(let viewModel):
            SignInView(viewModel: viewModel)
        
        case .main(let viewModel):
            MainView(viewModel: viewModel)
            
        case .none:
            Text("Loading")
        }
  
    }
}

struct RootView_Previews: PreviewProvider {
    
    static var previews: some View {
        RootView()
    }
}
