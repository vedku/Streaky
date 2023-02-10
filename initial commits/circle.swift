import SwiftUI

struct ContentView: View {
    @State private var progress: CGFloat = 0
    @State private var name: String = ""

    var body: some View {
        VStack {
            TextField("Enter the name of the streak", text: $name)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.blue, lineWidth: 20)
                .frame(width: 300, height: 300)
                .overlay(
                    Text("(Int(progress * 100))%")
                        .font(.title)
                        .bold()
                )
            Button("Advance the circle") {
                self.progress += 1/7
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
