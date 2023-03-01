import SwiftUI

struct ContentView: View {
    @State var progress: CGFloat = 0
    @State var name: String = ""
    @State var numberOfDays: Int = 365
    @State var isDarkMode = false
    
    var body: some View {
        VStack {
            VStack {
                TextField("Enter the name of the streak", text: $name)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .shadow(color: Color.gray.opacity(0.8), radius: 5, x: 0, y: 2)
                    )
                    .foregroundColor(.black)
                
                TextField("Enter the number of days", value: $numberOfDays, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .shadow(color: Color.gray.opacity(0.8), radius: 5, x: 0, y: 2)
                    )
                    .foregroundColor(.black)
            }
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.green, lineWidth: 20)
                .frame(width: 300, height: 300)
                .overlay(
                    VStack {
                        Text("\(name)")
                            .font(.title)
                            .bold()
                            .padding(.bottom, 10)
                            .foregroundColor(isDarkMode ? Color.white : Color.black)
                        
                        Text("\(Int(progress * CGFloat(numberOfDays))) day\(Int(progress * CGFloat(numberOfDays)) == 1 ? "" : "s")")
                            .font(.title)
                            .bold()
                            .foregroundColor(isDarkMode ? Color.white : Color.black)
                        
                        Text("\(String(format: "%.2f", (progress * 100)))% done")
                            .font(.caption)
                            .foregroundColor(isDarkMode ? Color.white : Color.black)
                        
                        Text("of \(numberOfDays) days")
                            .font(.caption)
                            .foregroundColor(isDarkMode ? Color.white : Color.black)
                    }
                )
                .padding()
            
            HStack(spacing: 50) {
                Button(action: {
                    if progress > 0 {
                        self.progress -= 1/CGFloat(self.numberOfDays)
                    }
                }) {
                    Text("-")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    self.progress += 1/CGFloat(self.numberOfDays)
                }) {
                    Text("+")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding(.top, 20)
            
            Spacer()
            
            Button(action: {
                self.isDarkMode.toggle()
            }) {
                Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                    .font(.title)
                    .foregroundColor(isDarkMode ? .white : .primary)
            }
        }
        .padding()
        .background(isDarkMode ? Color.black : Color.white)
        .foregroundColor(isDarkMode ? Color.white : Color.black)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
