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
    
    let byteCountFormatter = ByteCountFormatter()
    
    var body: some View {
        HStack {
            Image(systemName: "arrow.up")
            Text("\(self.byteCountFormatter.string(fromByteCount: Int64(self.uploadRate)))")
            
            Image(systemName: "arrow.down")
            Text("\(self.byteCountFormatter.string(fromByteCount: Int64(self.downloadRate)))")
        }
    }
    
}

struct UploadDownloadView_Previews: PreviewProvider {
    
    static var previews: some View {
        UploadDownloadView(uploadRate: .constant(64), downloadRate: .constant(13))
            .previewLayout(.sizeThatFits)
    }
}
