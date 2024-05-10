//
//  RootView.swift
//  Deluge
//
//  Created by Emil Landron on 5/4/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import SwiftUI

struct RootView: View {
    
    var viewModel = RootViewModel()

    var body: some View {
        
        switch viewModel.attached {
        case .signIn(let viewModel):
            SignInView(viewModel: viewModel)
        
        case .main(let viewModel):
            MainView(viewModel: viewModel)
            
        case .none:
            ProgressView("Loading...")
        }
  
    }
}

#Preview {
    RootView()
}
