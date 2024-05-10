//
//  UploadDownloadView.swift
//  Deluge
//
//  Created by Emil Landron on 5/5/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import SwiftUI

struct TransferRateView: View {
    
    let uploadRate: Int
    let downloadRate: Int

    var body: some View {
       
        HStack {

            Label(
                title: { 
                    Text(downloadRate.formatted(.byteCount(style: .file)))
                },
                icon: {
                    Image(systemName: "arrow.down")
                }
            )

            Label(
                title: {
                    Text(uploadRate.formatted(.byteCount(style: .file)))
                },
                icon: {
                    Image(systemName: "arrow.up")
                }
            )
        }
        .labelStyle(.titleAndIcon)
    }
}

#Preview {
    TransferRateView(uploadRate: 64, downloadRate: 13)
}
