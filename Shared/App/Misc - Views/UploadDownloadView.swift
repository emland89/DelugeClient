//
//  UploadDownloadView.swift
//  Deluge
//
//  Created by Emil Landron on 5/5/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import SwiftUI

struct UploadDownloadView: View {
    
    @Binding var uploadRate: Int
    @Binding var downloadRate: Int
        
    var body: some View {
       
        HStack {
            
            HStack(spacing: 2) {
                Image(systemName: "arrow.down")
                Text(downloadRate.formatted(.byteCount(style: .file)))
            }
            
            HStack(spacing: 2) {
                Image(systemName: "arrow.up")
                Text(uploadRate.formatted(.byteCount(style: .file)))
            }
        }
    }
    
}

struct UploadDownloadView_Previews: PreviewProvider {
    
    static var previews: some View {
        UploadDownloadView(uploadRate: .constant(64), downloadRate: .constant(13))
            .previewLayout(.sizeThatFits)
    }
}
