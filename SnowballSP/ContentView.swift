import SwiftUI

struct HomePage: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Home Page")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                NavigationLink(destination: ScanAreaPage()) {
                    Text("Go to Scan Area Page")
                        .frame(width: 200, height: 50)
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                NavigationLink(destination: DeployPage()) {
                    Text("Go to Deploy Page")
                        .frame(width: 200, height: 50)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                NavigationLink(destination: TimerPage()) {
                    Text("Go to Timer Page")
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: StatisticsPage()) {
                    Text("Go to Statistics Page")
                        .frame(width: 200, height: 50)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                                
                
            }
            .padding()
        }
    }
}

// Preview
struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
