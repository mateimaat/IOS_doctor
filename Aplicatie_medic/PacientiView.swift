import SwiftUI

struct PacientiView: View {
    @State private var pacienti: [Pacient] = []
    @State private var showAddPacientView = false
    @State private var showEditPacientView = false
    @State private var selectedPacient: Pacient?
    @State private var errorMessage: String = ""

    var body: some View {
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
                                Text(pacient.adresa)
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            Button("Editeaza") {
                                selectedPacient = pacient
                                showEditPacientView = true
                                
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            
                            Button("Sterge") {
                                deletePacient(pacient)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            .foregroundColor(.red)
                        }
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(PlainListStyle())
                
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
                .padding()
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .onAppear {
                loadPacienti()
            }
            .sheet(isPresented: $showAddPacientView) {
                AddPacientView(onPacientAdded: loadPacienti)
            }
            .sheet(isPresented: $showEditPacientView) {
                if let pacient = selectedPacient {
                    EditPacientView(pacient: pacient, onPacientUpdated: loadPacienti)
                }
            }
        }
    }

    private func loadPacienti() {
        pacienti = DatabaseManager.shared.getAllPacienti()
    }

    private func deletePacient(_ pacient: Pacient) {
        DatabaseManager.shared.deletePacient(pacientID: pacient.id)
        loadPacienti()
    }
}
