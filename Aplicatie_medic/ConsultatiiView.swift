import SwiftUI

struct ConsultatiiView: View {
    @State private var consultatii: [Consultatie] = []
    @State private var showAddConsultatieView = false
    @State private var showEditConsultatieView = false
    @State private var selectedConsultatie: Consultatie?
    @State private var errorMessage: String = ""

    var body: some View {
        NavigationView {
            ZStack {
                Image("fundal")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    Text("Lista Consultatii")
                        .font(.largeTitle)
                        .padding()
                        .foregroundColor(.white)

                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }

                    List {
                        ForEach(consultatii) { consultatie in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Pacient: \(consultatie.pacientNume) \(consultatie.pacientPrenume)")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text("Medicament: \(consultatie.medicamentDenumire)")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                    Text("Medic: \(consultatie.medicNume) \(consultatie.medicPrenume)")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                    Text("Diagnostic: \(consultatie.diagnostic)")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                    Text("Doza: \(consultatie.dozaMedicament)")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                }
                                Spacer()
                                Button(action: {
                                    self.selectedConsultatie = consultatie
                                    self.showEditConsultatieView = true
                                }) {
                                    Text("Editeaza")
                                        .foregroundColor(.blue)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                Button(action: {
                                    deleteConsultatie(consultatie)
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
                        showAddConsultatieView = true
                    }) {
                        Text("Adauga Consultatie")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
                .onAppear {
                    loadConsultatii()
                }
                .sheet(isPresented: $showAddConsultatieView) {
                    AddConsultatieView(isPresented: $showAddConsultatieView, onConsultatieAdded: {
                        loadConsultatii()
                    })
                }
                .sheet(isPresented: $showEditConsultatieView) {
                    if let consultatie = selectedConsultatie {
                        EditConsultatieView(isPresented: $showEditConsultatieView, consultatie: consultatie, onConsultatieUpdated: {
                            loadConsultatii()
                        })
                    }
                }
            }
        }
    }

    private func loadConsultatii() {
        consultatii = DatabaseManager.shared.getAllConsultatii()
    }

    private func deleteConsultatie(_ consultatie: Consultatie) {
        DatabaseManager.shared.deleteConsultatie(consultatieID: consultatie.id)
        loadConsultatii()
    }
}
