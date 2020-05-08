//
//  ETAView.swift
//  Deluge
//
//  Created by Emil Landron on 5/5/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import SwiftUI

struct ETAView: View {
    
    @Binding var eta: TimeInterval
    
    private let etaFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .short
        formatter.allowedUnits = [.second, .minute, .hour]
        return formatter
    }()
    
    
    
    var body: some View {
        Text("\(self.etaFormatter.string(from: eta)!)")
    }
}

struct ETAView_Previews: PreviewProvider {
    static var previews: some View {
        ETAView(eta: .constant(60))
            .previewLayout(.sizeThatFits)
    }
}
