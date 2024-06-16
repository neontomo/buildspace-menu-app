//
//  CustomLinksView.swift
//  buildspace menu app
//
//  Created by Tomo Myrman on 2024-06-16.
//

import AppKit
import SwiftUI

struct CustomLinksView: View {
  @AppStorage("customLink1") var customLink1 = ""
  @AppStorage("customLink2") var customLink2 = ""
  @AppStorage("customLink3") var customLink3 = ""
  @AppStorage("customLink4") var customLink4: String = ""
  @AppStorage("customLink5") var customLink5: String = ""

  var window: NSWindow?

  // a swiftui view to edit custom links
  var body: some View {
    ScrollView {
      VStack {
        Text("custom links")
          .font(.title)
          .padding()

        Group {
          TextField("custom Link 1", text: $customLink1)
            .textFieldStyle(RoundedBorderTextFieldStyle())

          TextField("custom Link 2", text: $customLink2)
            .textFieldStyle(RoundedBorderTextFieldStyle())

          TextField("custom link 3", text: $customLink3)
            .textFieldStyle(RoundedBorderTextFieldStyle())

          TextField("custom link 4", text: $customLink4)
            .textFieldStyle(RoundedBorderTextFieldStyle())

          TextField("custom link 5", text: $customLink5)
            .textFieldStyle(RoundedBorderTextFieldStyle())

          Button("close & save") {
            // close the window
            window?.close()
          }

        }
      }
    }
    .padding()
    .frame(width: 300, height: 300)

  }
}

#Preview {
  CustomLinksView()
}
