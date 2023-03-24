import SwiftUI

struct ContentView: View {
    @State var progress: CGFloat = 0
    @State var name: String = ""
    @State var numberOfDays: Int = 10
    @State var dayscompleted: Int = 0
    @State var isDarkMode = false
    @State var celebrate = false
    
    var body: some View {
        ZStack{
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
                    .padding(50)
                
                HStack(spacing: 50) {
                    Button(action: {
                        if progress > 0 {
                            self.progress -= 1/CGFloat(self.numberOfDays)
                            self.dayscompleted = Int(self.progress * CGFloat(self.numberOfDays))
                            print(numberOfDays)
                        }
                        if progress <= 0 {
                            self.progress = 0
                            self.dayscompleted = 0
                        }
                    }) {
                        Text("-")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(30)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .disabled(progress <= 0)
                    
                    
                    Button(action: {
                        if progress < 1 {
                            self.progress += 1/CGFloat(self.numberOfDays)
                            self.dayscompleted += 1
                        }
                        if progress >= 1 {
                            self.progress = 1
                            self.dayscompleted = self.numberOfDays
                        }
                    }) {
                        Text("+")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(30)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .disabled(progress >= 1)
                    
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
                .onChange(of: dayscompleted) { newValue in
                    celebrate = newValue == numberOfDays
                }
            }
            if celebrate {
                ConfettiView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            celebrate = false
                        }
                    }
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
struct ConfettiView: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        let emitter = CAEmitterLayer()
        emitter.emitterShape = .line
        emitter.emitterPosition = CGPoint(x: view.bounds.width / 2, y: -50)
        emitter.emitterSize = CGSize(width: view.bounds.width, height: 2)
        emitter.beginTime = CACurrentMediaTime()
        
        let colors: [UIColor] = [.red, .blue, .green, .yellow, .orange]
        var cells: [CAEmitterCell] = []
        
        for color in colors {
            let cell = CAEmitterCell()
            cell.birthRate = 5
            cell.lifetime = 10
            cell.velocity = 150
            cell.velocityRange = 50
            cell.emissionLongitude = .pi
            cell.emissionRange = .pi / 4
            cell.scale = 0.05
            cell.scaleRange = 0.03
            cell.contents = UIImage(named: "confetti")?.cgImage
            cell.color = color.cgColor
            
            cells.append(cell)
        }
        
        emitter.emitterCells = cells
        view.layer.addSublayer(emitter)
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
