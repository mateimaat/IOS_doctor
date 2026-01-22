import SwiftUI

struct MediciView: View {
    @State private var medici: [Medic] = []
    @State private var showAddMedicView = false
    @State private var showEditMedicView = false
    @State private var selectedMedic: Medic?
    @State private var errorMessage: String = ""

    var body: some View {
        NavigationView {
            ZStack {
                Image("fundal")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    Text("Lista Medici")
                        .font(.largeTitle)
                        .padding()
                        .foregroundColor(.white)
                    
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }
                    
                    List {
                        ForEach(medici) { medic in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(medic.nume) \(medic.prenume)")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text("Specializare: \(medic.specializare)")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                }
                                Spacer()
                                Button(action: {
                                    self.selectedMedic = medic
                                    self.showEditMedicView = true
                                }) {
                                    Text("Editeaza")
                                        .foregroundColor(.blue)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                Button(action: {
                                    deleteMedic(medic)
                                }) {
                                    Text("Sterge")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                            .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.clear)
                    
                    Button(action: {
                        showAddMedicView = true
                    }) {
                        Text("Adauga Medic")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
                .onAppear {
                    loadMedici()
                }
                .sheet(isPresented: $showAddMedicView) {
                    AddMedicView(onMedicAdded: {
                        loadMedici()
                    })
                }
                .sheet(isPresented: $showEditMedicView) {
                    if let medic = selectedMedic {
                        EditMedicView(medic: medic, onMedicUpdated: {
                            loadMedici()
                        })
                    }
                }
            }
        }
    }

    private func loadMedici() {
        medici = DatabaseManager.shared.getAllMedici()
    }

    private func deleteMedic(_ medic: Medic) {
        DatabaseManager.shared.deleteMedic(medicID: medic.id)
        loadMedici()
    }
}
