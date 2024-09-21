import SwiftUI

// Streak model
struct Streak: Identifiable {
    let id = UUID()
    var name: String
    var numberOfDays: Int
    var daysCompleted: Int
}

// Extension to dismiss the keyboard
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// View for an individual streak
struct StreakView: View {
    @Binding var streak: Streak
    @State private var progress: CGFloat = 0
    @State private var showAlert = false
    @State private var showCompletionAlert = false

    @State private var isEditingName = false
    @State private var isEditingNumberOfDays = false
    @State private var newName = ""
    @State private var newNumberOfDaysString = ""

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(streak.name)
                        .font(.largeTitle)
                        .bold()
                    Button(action: {
                        self.newName = self.streak.name
                        self.isEditingName = true
                    }) {
                        Image(systemName: "pencil")
                            .font(.title2)
                    }
                }

                HStack {
                    Text("\(streak.numberOfDays) day\(streak.numberOfDays == 1 ? "" : "s")")
                        .font(.title3)
                    Button(action: {
                        self.newNumberOfDaysString = String(self.streak.numberOfDays)
                        self.isEditingNumberOfDays = true
                    }) {
                        Image(systemName: "pencil")
                            .font(.title2)
                    }
                }
            }
            .padding()

            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.green, lineWidth: 20)
                .frame(width: 300, height: 300)
                .overlay(
                    VStack {
                        Text("\(streak.daysCompleted) day\(streak.daysCompleted == 1 ? "" : "s")")
                            .font(.title)
                            .bold()

                        Text("\(String(format: "%.2f", (progress * 100)))% done")
                            .font(.caption)

                        Text("of \(streak.numberOfDays) days")
                            .font(.caption)
                    }
                )
                .padding(10)
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.progress = CGFloat(self.streak.daysCompleted) / CGFloat(self.streak.numberOfDays)
                    }
                }
                .onChange(of: streak.numberOfDays) {
                    if streak.numberOfDays <= 0 {
                        streak.numberOfDays = 1
                    }
                    withAnimation {
                        self.progress = CGFloat(self.streak.daysCompleted) / CGFloat(self.streak.numberOfDays)
                    }
                }
                .padding(10)

            HStack(spacing: 50) {
                // Swapped '+' and '-' buttons for UI consistency
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
            }
            .padding()

            Spacer()
        }
        .padding()
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
                message: Text("You have completed your streak, \(streak.name), for \(streak.daysCompleted) days!"),
                dismissButton: .default(Text("Dismiss"))
            )
        }
        .sheet(isPresented: $isEditingName) {
            NavigationView {
                VStack {
                    Text("Edit Streak Name")
                        .font(.headline)
                    TextField("Streak Name", text: $newName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    HStack {
                        Button("Cancel") {
                            isEditingName = false
                        }
                        Spacer()
                        Button("Save") {
                            streak.name = newName
                            isEditingName = false
                        }
                    }
                    .padding()
                }
                .padding()
                .navigationBarHidden(true)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            }
        }
        .sheet(isPresented: $isEditingNumberOfDays) {
            NavigationView {
                VStack {
                    Text("Edit Number of Days")
                        .font(.headline)
                    TextField("Number of Days", text: $newNumberOfDaysString)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    HStack {
                        Button("Cancel") {
                            isEditingNumberOfDays = false
                        }
                        Spacer()
                        Button("Save") {
                            if let newNumberOfDays = Int(newNumberOfDaysString), newNumberOfDays > 0 {
                                streak.numberOfDays = newNumberOfDays
                                if streak.daysCompleted > streak.numberOfDays {
                                    streak.daysCompleted = streak.numberOfDays
                                }
                                withAnimation {
                                    self.progress = CGFloat(self.streak.daysCompleted) / CGFloat(self.streak.numberOfDays)
                                }
                            }
                            isEditingNumberOfDays = false
                        }
                    }
                    .padding()
                }
                .padding()
                .navigationBarHidden(true)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            }
        }
    }
}

// Custom view for a streak row with swipe gestures
struct StreakRow: View {
    @Binding var streak: Streak
    @Binding var selectedStreak: Streak?
    @Binding var isShowingStreakView: Bool

    var body: some View {
        HStack {
            Text(streak.name)
                .font(.headline)
            Spacer()
            // Progress Circle
            Circle()
                .trim(from: 0, to: CGFloat(streak.daysCompleted) / CGFloat(max(streak.numberOfDays, 1)))
                .stroke(Color.green, lineWidth: 5)
                .frame(width: 30, height: 30)
            Spacer()
            Text("\(streak.daysCompleted)/\(streak.numberOfDays) days")
                .font(.subheadline)
        }
        .contentShape(Rectangle()) // Makes the entire row tappable
        .onTapGesture {
            selectedStreak = streak
            isShowingStreakView = true
        }
        .gesture(
            DragGesture(minimumDistance: 30)
                .onEnded { value in
                    if abs(value.translation.height) < abs(value.translation.width) {
                        if value.translation.width < 0 {
                            // Left swipe - increment
                            if streak.daysCompleted < streak.numberOfDays {
                                streak.daysCompleted += 1
                            }
                        } else {
                            // Right swipe - decrement
                            if streak.daysCompleted > 0 {
                                streak.daysCompleted -= 1
                            }
                        }
                    }
                }
        )
    }
}

// View for the dashboard displaying all streaks
struct DashboardView: View {
    @State private var streaks: [Streak] = [] // Start with no streaks
    @State private var selectedStreak: Streak?
    @State private var isShowingStreakView = false

    var body: some View {
        NavigationView {
            VStack {
                if streaks.isEmpty {
                    Text("No streaks yet. Start by adding one!")
                        .font(.headline)
                        .padding()
                }

                List {
                    ForEach($streaks) { $streak in
                        StreakRow(streak: $streak, selectedStreak: $selectedStreak, isShowingStreakView: $isShowingStreakView)
                    }
                    .onDelete { indexSet in
                        streaks.remove(atOffsets: indexSet)
                    }
                }

                Spacer()

                Button(action: {
                    let newStreak = Streak(name: "New Streak", numberOfDays: 1, daysCompleted: 0)
                    streaks.append(newStreak)
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .padding()
                        .foregroundColor(.blue)
                }
            }
            .navigationTitle("Streaky")
            .sheet(isPresented: $isShowingStreakView) {
                if let selectedStreak = selectedStreak,
                   let index = streaks.firstIndex(where: { $0.id == selectedStreak.id }) {
                    StreakView(streak: $streaks[index])
                }
            }
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
