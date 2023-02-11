import SwiftUI

struct ContentView: View {
    @State var progress: CGFloat = 0
    @State var name: String = ""
    @State var numberOfDays: Int = 20

    var body: some View {
        VStack {
            TextField("Enter the name of the streak", text: $name)
            TextField("Enter the number of days", value: $numberOfDays, formatter: NumberFormatter())
                .keyboardType(.numberPad)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.blue, lineWidth: 20)
                .frame(width: 300, height: 300)
                .overlay(
                    VStack {
                        Text("(name)")
                        Text("(Int(progress * CGFloat(numberOfDays))) day(Int(progress * CGFloat(numberOfDays)) == 1 ? "" : "s")")
                            .font(.title)
                            .bold()
                        Text("(String(format: "%.2f", (progress * 100)))% done")
                            .font(.caption)
                        Text("of (numberOfDays) days")
                            .font(.caption)
                    }
                )
            Button("I have completed my streak") {
                self.progress += 1/CGFloat(self.numberOfDays)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
