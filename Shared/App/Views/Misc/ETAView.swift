//
//  ETAView.swift
//  Deluge
//
//  Created by Emil Landron on 5/5/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import SwiftUI

struct ETAView: View {
    
    let eta: TimeInterval

    private static let etaFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .short
        formatter.allowedUnits = [.second, .minute, .hour]
        return formatter
    }()
    
    var body: some View {
        Text("\(Self.etaFormatter.string(from: eta)!)")
    }
}

#Preview {
    ETAView(eta: 60)
}
