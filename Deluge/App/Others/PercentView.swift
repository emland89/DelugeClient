//
//  PercentView.swift
//  Deluge
//
//  Created by Emil Landron on 5/8/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import SwiftUI

struct PercentView: View {
    
    private static var percentFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        return formatter
    }()
    
    @Binding var percent: Double

    var body: some View {
        Text("\(Self.percentFormatter.string(for: percent)!)")
    }
}

struct PercentView_Previews: PreviewProvider {
    static var previews: some View {
        PercentView(percent: .constant(0.40))
            .previewLayout(.sizeThatFits)
    }
}
