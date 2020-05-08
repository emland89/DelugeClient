//
//  FilledButtonStyle.swift
//  Deluge
//
//  Created by Emil Landron on 5/7/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import SwiftUI

struct FilledButtonStyle: ButtonStyle {
        
    func makeBody(configuration: Self.Configuration) -> some View {
        
        configuration.label
            .foregroundColor(.white)
            .padding(.horizontal, 64)
            .padding(.vertical, 8)
            .background(Color.blue.opacity(configuration.isPressed ? 0.5 : 1))
            .cornerRadius(8)
    }
}

struct FilledButtonStyle_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Button("A Button", action: { })
            .buttonStyle(FilledButtonStyle())
    }
}
