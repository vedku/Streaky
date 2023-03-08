//doesn't work yet lolo
import SwiftUI

struct ContentView: View {
    @State var progress: CGFloat = 0
    @State var name: String = ""
    @State var numberOfDays: Int = 10
    @State var isDarkMode = false
    
    var body: some View {
        VStack {
            VStack {
                TextField("Enter the name of the streak", text: $name)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: Color.gray.opacity(0.8), radius: 5, x: 0, y: 2)
                    )
                    .foregroundColor(.black)
                
                TextField("Enter the number of days", value: $numberOfDays, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
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
                .padding(50)
            
            HStack(spacing: 50) {
                Button(action: {
                    if progress > 0 {
                        self.progress -= 1/CGFloat(self.numberOfDays)
                    }
                }) {
                    Text("-")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(30)
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .disabled(progress <= 0) // Disable when progress is already at 0
                
                Button(action: {
                    if progress < 1 {
                        self.progress += 1/CGFloat(self.numberOfDays)
                    }
                }) {
                    Text("+")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(30)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .disabled(progress >= 1) // Disable when progress is already at 100%
            }
            .padding()
            
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
