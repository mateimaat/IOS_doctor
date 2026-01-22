import SwiftUI

struct AddConsultatieView: View {
    @Binding var isPresented: Bool
    var onConsultatieAdded: () -> Void
    
    @State private var pacienti: [Pacient] = []
    @State private var medicamente: [Medicament] = []
    @State private var medici: [Medic] = []
    
    @State private var selectedPacient: Pacient? = nil
    @State private var selectedMedicament: Medicament? = nil
    @State private var selectedMedic: Medic? = nil
    @State private var data: String = ""
    @State private var diagnostic: String = ""
    @State private var dozaMedicament: String = ""
    @State private var errorMessage: String = ""
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Adauga Consultatie")
                .font(.largeTitle)
                .padding(.top, 20)
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Pacient")
                    .font(.headline)
                Picker("Selectati un pacient", selection: $selectedPacient) {
                    ForEach(pacienti, id: \.id) { pacient in
                        Text("\(pacient.nume) \(pacient.prenume)").tag(pacient as Pacient?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onAppear {
                    if let firstPacient = pacienti.first {
                        selectedPacient = firstPacient
                    }
                }
                
                Text("Medicament")
                    .font(.headline)
                Picker("Selectati un medicament", selection: $selectedMedicament) {
                    ForEach(medicamente, id: \.id) { medicament in
                        Text(medicament.denumire).tag(medicament as Medicament?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onAppear {
                    if let firstMedicament = medicamente.first {
                        selectedMedicament = firstMedicament
                    }
                }
                
                Text("Medic")
                    .font(.headline)
                Picker("Selectati un medic", selection: $selectedMedic) {
                    ForEach(medici, id: \.id) { medic in
                        Text("\(medic.nume) \(medic.prenume)").tag(medic as Medic?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onAppear {
                    if let firstMedic = medici.first {
                        selectedMedic = firstMedic
                    }
                }
                
                TextField("Introduceti data (ex. 2024-12-12)", text: $data)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Introduceti diagnosticul", text: $diagnostic)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Introduceti doza medicamentului", text: $dozaMedicament)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)
            
            Button(action: addConsultatie) {
                Text("Adauga")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .onAppear(perform: loadData)
    }
    
    private func loadData() {
        pacienti = DatabaseManager.shared.getAllPacienti()
        medicamente = DatabaseManager.shared.getAllMedicamente()
        medici = DatabaseManager.shared.getAllMedici()
    }
    
    private func addConsultatie() {
        guard let pacient = selectedPacient,
              let medicament = selectedMedicament,
              let medic = selectedMedic,
              !data.isEmpty, !diagnostic.isEmpty, !dozaMedicament.isEmpty else {
            errorMessage = "Trebuie completate toate campurile!"
            return
        }
        
        errorMessage = ""
        
        DatabaseManager.shared.addConsultatie(
            pacientID: pacient.id,
            medicamentID: medicament.id,
            medicID: medic.id,
            data: data,
            diagnostic: diagnostic,
            dozaMedicament: dozaMedicament
        )
        
        onConsultatieAdded()
        isPresented = false
    }
}
