import SwiftUI

struct SplashView: View {
  @AppStorage("house") var house = ""

  let backgroundImages = [
    "💋 spectreseek": "spectreseek",
    "🌀 alterok": "alterok",
    "🌙 gaudmire": "gaudmire",
    "🌿 erevald": "erevald",
  ]

  var body: some View {
    VStack(alignment: .center) {
      Image(backgroundImages[house] ?? "unset")
        .resizable()
        .scaledToFill()
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding()
    }
  }
}

struct SplashView_Previews: PreviewProvider {
  static var previews: some View {
    SplashView()
      .frame(width: 300, height: 300)
  }
}
