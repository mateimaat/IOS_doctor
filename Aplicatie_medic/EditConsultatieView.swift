import SwiftUI

struct EditConsultatieView: View {
    @Binding var isPresented: Bool
    var consultatie: Consultatie
    var onConsultatieUpdated: () -> Void

    @State private var selectedPacient: Pacient?
    @State private var selectedMedicament: Medicament?
    @State private var selectedMedic: Medic?
    @State private var data: String = ""
    @State private var diagnostic: String = ""
    @State private var dozaMedicament: String = ""
    @State private var errorMessage: String = ""

    var body: some View {
        VStack(spacing: 15) {
            Text("Editare Consultatie")
                .font(.largeTitle)
                .padding(.top, 20)

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }

            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Pacient")
                            .font(.headline)
                        Picker("Selectati un pacient", selection: $selectedPacient) {
                            ForEach(DatabaseManager.shared.getAllPacienti(), id: \.id) { pacient in
                                Text("\(pacient.nume) \(pacient.prenume)").tag(pacient as Pacient?)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Medicament")
                            .font(.headline)
                        Picker("Selectati un medicament", selection: $selectedMedicament) {
                            ForEach(DatabaseManager.shared.getAllMedicamente(), id: \.id) { medicament in
                                Text(medicament.denumire).tag(medicament as Medicament?)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Medic")
                            .font(.headline)
                        Picker("Selectati un medic", selection: $selectedMedic) {
                            ForEach(DatabaseManager.shared.getAllMedici(), id: \.id) { medic in
                                Text("\(medic.nume) \(medic.prenume)").tag(medic as Medic?)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }
                Spacer()
            }
            .padding(.horizontal)

            TextField("Data (ex. 2024-12-12)", text: $data)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Diagnostic", text: $diagnostic)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Doza Medicament", text: $dozaMedicament)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                if validateFields() {
                    DatabaseManager.shared.updateConsultatie(
                        id: consultatie.id,
                        pacientID: selectedPacient?.id ?? consultatie.pacientID,
                        medicamentID: selectedMedicament?.id ?? consultatie.medicamentID,
                        medicID: selectedMedic?.id ?? consultatie.medicID,
                        data: data,
                        diagnostic: diagnostic,
                        dozaMedicament: dozaMedicament
                    )
                    onConsultatieUpdated()
                    isPresented = false
                }
            }) {
                Text("Salveaza")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .onAppear {
            initializeFields()
        }
    }

    private func validateFields() -> Bool {
        guard let _ = selectedPacient, let _ = selectedMedicament, let _ = selectedMedic,
              !data.isEmpty, !diagnostic.isEmpty, !dozaMedicament.isEmpty else {
            errorMessage = "Trebuie completate toate campurile!"
            return false
        }
        errorMessage = ""
        return true
    }

    private func initializeFields() {
        selectedPacient = DatabaseManager.shared.getAllPacienti().first { $0.id == consultatie.pacientID }
        selectedMedicament = DatabaseManager.shared.getAllMedicamente().first { $0.id == consultatie.medicamentID }
        selectedMedic = DatabaseManager.shared.getAllMedici().first { $0.id == consultatie.medicID }
        data = consultatie.data
        diagnostic = consultatie.diagnostic
        dozaMedicament = consultatie.dozaMedicament
    }
}
