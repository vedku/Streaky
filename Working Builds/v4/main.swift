import SwiftUI

struct ContentView: View {
    @State var progress: CGFloat = 0
    @State var name: String = ""
    @State var numberOfDays: Int = 10
    @State var dayscompleted: Int = 0
    @State var isDarkMode = false
    @State private var showAlert = false
    @State private var showCompletionAlert = false
    
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
                    .onChange(of: numberOfDays) {
                        if numberOfDays <= 0 {
                            numberOfDays = 1
                        }
                    }

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
                        
                        Text("\(dayscompleted) day\(dayscompleted == 1 ? "" : "s")")
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
                .padding(10)
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.progress = CGFloat(self.dayscompleted) / CGFloat(self.numberOfDays)
                    }
                }
                .padding(10)
            
            HStack(spacing: 50) {
                Button(action: {
                    withAnimation {
                        if dayscompleted > 0 {
                            self.dayscompleted -= 1
                            self.progress = CGFloat(self.dayscompleted) / CGFloat(self.numberOfDays)
                        }
                    }
                }) {
                    Text("-")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(30)
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .disabled(dayscompleted <= 0)

                Button(action: {
                    withAnimation {
                        if dayscompleted < numberOfDays {
                            self.dayscompleted += 1
                            self.progress = CGFloat(self.dayscompleted) / CGFloat(self.numberOfDays)
                            if self.dayscompleted < self.numberOfDays {
                                self.showAlert = true
                            } else if self.dayscompleted == self.numberOfDays {
                                self.showCompletionAlert = true
                            }
                        }
                    }
                }) {
                    Text("+")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(30)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .disabled(dayscompleted >= numberOfDays)
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
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Congratulations!"),
                message: Text("You have completed your streak for today."),
                dismissButton: .default(Text("Dismiss"))
            )
        }
        .alert(isPresented: $showCompletionAlert) {
            Alert(
                title: Text("Congratulations!"),
                message: Text("You have completed your Streak, \(name), for \(dayscompleted) days!"),
                dismissButton: .default(Text("Dismiss"))
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
