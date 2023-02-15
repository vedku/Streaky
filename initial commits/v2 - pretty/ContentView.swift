import SwiftUI

struct ContentView: View {
    @State var progress: CGFloat = 0
    @State var name: String = ""
    @State var numberOfDays: Int = 20
    
    var body: some View {
        
        VStack {
            TextField("Enter the name of the streak", text: $name)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 2)
                )
            
            TextField("Enter the number of days", value: $numberOfDays, formatter: NumberFormatter())
                .keyboardType(.numberPad)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 2)
                )
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.blue, lineWidth: 20)
                .frame(width: 300, height: 300)
                .overlay(
                    VStack {
                        Text("\(name)")
                            .font(.title)
                            .bold()
                            .padding(.bottom, 10)
                        
                        Text("\(Int(progress * CGFloat(numberOfDays))) day\(Int(progress * CGFloat(numberOfDays)) == 1 ? "" : "s")")
                            .font(.title)
                            .bold()
                        
                        Text("\(String(format: "%.2f", (progress * 100)))% done")
                            .font(.caption)
                        
                        Text("of \(numberOfDays) days")
                            .font(.caption)
                    }
                )
                .padding()
            
            Button(action: {
                self.progress += 1/CGFloat(self.numberOfDays)
            }) {
                Text("I have completed my streak")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            
            Spacer()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
