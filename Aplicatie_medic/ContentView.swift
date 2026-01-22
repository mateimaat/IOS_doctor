import SwiftUI

struct ContentView: View {
    @Binding var isLoggedIn: Bool

    var body: some View {
        NavigationView {
            ZStack {
                
                Image("fundal")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    Text("Aplicatie Medicala")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 40)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    NavigationLink(destination: MediciView()) {
                        Text("Medici")
                            .buttonStyleCustom()
                    }
                    
                    NavigationLink(destination: PacientiView()) {
                        Text("Pacienti")
                            .buttonStyleCustom()
                    }
                    
                    NavigationLink(destination: MedicamenteView()) {
                        Text("Medicamente")
                            .buttonStyleCustom()
                    }
                    
                    NavigationLink(destination: ConsultatiiView()) {
                        Text("Consultatii")
                            .buttonStyleCustom()
                    }
                    
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            isLoggedIn = false
                        }) {
                            Text("Deconectare")
                                .font(.body)
                                .padding(8)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }
                        .padding(.leading)
                        .padding(.bottom)
                        Spacer()
                    }
                }
                .padding()
            }
        }
    }
}

extension Text {
    func buttonStyleCustom() -> some View {
        self
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}
