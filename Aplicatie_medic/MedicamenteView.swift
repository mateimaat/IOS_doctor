import SwiftUI

struct MedicamenteView: View {
    @State private var medicamente: [Medicament] = []
    @State private var showAddMedicamentView = false
    @State private var showEditMedicamentView = false
    @State private var selectedMedicament: Medicament?
    @State private var errorMessage: String = ""
    
    var body: some View {
        ZStack {
            
            Image("fundal")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            
            VStack {
                Text("Lista Medicamente")
                    .font(.largeTitle)
                    .padding()
                    .foregroundColor(.white)
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                
                List(medicamente, id: \.id) { medicament in
                    HStack {
                        Text(medicament.denumire)
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                        Button(action: {
                            selectedMedicament = medicament
                            showEditMedicamentView = true
                        }) {
                            Text("Editeaza")
                                .foregroundColor(.blue)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        Button(action: {
                            deleteMedicament(medicament)
                        }) {
                            Text("Sterge")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    .listRowBackground(Color.clear)
                }
                .listStyle(PlainListStyle())
                
                Button(action: {
                    showAddMedicamentView = true
                }) {
                    Text("Adauga Medicament")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .sheet(isPresented: $showAddMedicamentView) {
                AddMedicamentView(isPresented: $showAddMedicamentView, onMedicamentAdded: loadMedicamente)
            }
            .sheet(isPresented: $showEditMedicamentView) {
                if let medicament = selectedMedicament {
                    EditMedicamentView(isPresented: $showEditMedicamentView, medicament: medicament, onMedicamentUpdated: loadMedicamente)
                }
            }
            .onAppear {
                loadMedicamente()
            }
        }
    }

    private func loadMedicamente() {
        medicamente = DatabaseManager.shared.getAllMedicamente()
    }

    private func deleteMedicament(_ medicament: Medicament) {
        DatabaseManager.shared.deleteMedicament(medicamentID: medicament.id)
        loadMedicamente()
    }
}
