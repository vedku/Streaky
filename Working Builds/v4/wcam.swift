import SwiftUI

// Model representing a streak
struct Streak: Identifiable {
    let id = UUID()
    var name: String
    var numberOfDays: Int
    var daysCompleted: Int
}

// View for individual streaks
struct StreakView: View {
    @Binding var streak: Streak
    @State private var progress: CGFloat = 0
    @State private var showAlert = false
    @State private var showCompletionAlert = false
    @State private var isDarkMode = false
    
    var body: some View {
        VStack {
            VStack {
                TextField("Enter the name of the streak", text: $streak.name)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: Color.gray.opacity(0.8), radius: 5, x: 0, y: 2)
                    )
                    .foregroundColor(.black)
                
                TextField("Enter the number of days", value: $streak.numberOfDays, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: Color.gray.opacity(0.8), radius: 5, x: 0, y: 2)
                    )
                    .foregroundColor(.black)
                    .onChange(of: streak.numberOfDays) {
                        if streak.numberOfDays <= 0 {
                            streak.numberOfDays = 1
                        }
                    }
            }
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.green, lineWidth: 20)
                .frame(width: 300, height: 300)
                .overlay(
                    VStack {
                        Text("\(streak.name)")
                            .font(.title)
                            .bold()
                            .padding(.bottom, 10)
                            .foregroundColor(isDarkMode ? Color.white : Color.black)
                        
                        Text("\(streak.daysCompleted) day\(streak.daysCompleted == 1 ? "" : "s")")
                            .font(.title)
                            .bold()
                            .foregroundColor(isDarkMode ? Color.white : Color.black)
                        
                        Text("\(String(format: "%.2f", (progress * 100)))% done")
                            .font(.caption)
                            .foregroundColor(isDarkMode ? Color.white : Color.black)
                        
                        Text("of \(streak.numberOfDays) days")
                            .font(.caption)
                            .foregroundColor(isDarkMode ? Color.white : Color.black)
                    }
                )
                .padding(10)
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.progress = CGFloat(self.streak.daysCompleted) / CGFloat(self.streak.numberOfDays)
                    }
                }
                .padding(10)
            
            HStack(spacing: 50) {
                Button(action: {
                    withAnimation {
                        if streak.daysCompleted > 0 {
                            streak.daysCompleted -= 1
                            self.progress = CGFloat(self.streak.daysCompleted) / CGFloat(self.streak.numberOfDays)
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
                .disabled(streak.daysCompleted <= 0)

                Button(action: {
                    withAnimation {
                        if streak.daysCompleted < streak.numberOfDays {
                            streak.daysCompleted += 1
                            self.progress = CGFloat(self.streak.daysCompleted) / CGFloat(self.streak.numberOfDays)
                            if self.streak.daysCompleted < self.streak.numberOfDays {
                                self.showAlert = true
                            } else if self.streak.daysCompleted == self.streak.numberOfDays {
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
                .disabled(streak.daysCompleted >= streak.numberOfDays)
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
                message: Text("You have completed your Streak, \(streak.name), for \(streak.daysCompleted) days!"),
                dismissButton: .default(Text("Dismiss"))
            )
        }
    }
}

// View for the dashboard displaying all streaks
struct DashboardView: View {
    @State private var streaks: [Streak] = [
        Streak(name: "Exercise", numberOfDays: 30, daysCompleted: 10),
        Streak(name: "Meditation", numberOfDays: 20, daysCompleted: 15),
        // Add more streaks here
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach($streaks) { $streak in
                    NavigationLink(destination: StreakView(streak: $streak)) {
                        HStack {
                            Text(streak.name)
                                .font(.headline)
                            Spacer()
                            Text("\(streak.daysCompleted)/\(streak.numberOfDays) days")
                                .font(.subheadline)
                        }
                    }
                }
            }
            .navigationTitle("Streaky")
        }
    }
}

// The main ContentView that shows the dashboard
struct ContentView: View {
    var body: some View {
        DashboardView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
