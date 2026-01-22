import SwiftUI

struct ClientView: View {
    @Binding var isLoggedIn: Bool
    @State private var pacienti: [Pacient] = []
    @State private var showAddPacientView = false
    @State private var showEditPacientView = false
    @State private var selectedPacient: Pacient?

    var body: some View {
        NavigationView {
            ZStack {
                
                Image("fundal")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    Text("Lista Pacienti")
                        .font(.largeTitle)
                        .padding()
                        .foregroundColor(.white)
                    
                    List {
                        ForEach(pacienti) { pacient in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(pacient.nume) \(pacient.prenume)")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text("Adresa: \(pacient.adresa)")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                }
                                Spacer()
                                Button(action: {
                                    self.selectedPacient = pacient
                                    self.showEditPacientView = true
                                }) {
                                    Text("Editeaza")
                                        .foregroundColor(.blue)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                            .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.clear)
                    
                    Button(action: {
                        showAddPacientView = true
                    }) {
                        Text("Adauga Pacient")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Button(action: {
                        isLoggedIn = false
                    }) {
                        Text("Deconectare")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .onAppear {
                    loadPacienti()
                }
                .sheet(isPresented: $showAddPacientView) {
                    AddPacientView(onPacientAdded: {
                        loadPacienti()
                    })
                }
                .sheet(isPresented: $showEditPacientView) {
                    if let pacient = selectedPacient {
                        EditPacientView(pacient: pacient, onPacientUpdated: {
                            loadPacienti()
                        })
                    }
                }
            }
        }
    }

    private func loadPacienti() {
        pacienti = DatabaseManager.shared.getAllPacienti()
    }
}
