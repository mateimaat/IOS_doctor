import SwiftUI

struct EditMedicamentView: View {
    @Binding var isPresented: Bool
    @State var medicament: Medicament
    @State private var denumire: String = ""
    @State private var errorMessage: String = ""
    var onMedicamentUpdated: (() -> Void)?

    var body: some View {
        VStack {
            Text("Editeaza Medicament")
                .font(.largeTitle)
                .padding()

            TextField("Denumire", text: $denumire)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .onAppear {
                    denumire = medicament.denumire
                }

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }

            Button(action: {
                editeazaMedicament()
            }) {
                Text("Salveaza modificările")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }

    private func editeazaMedicament() {
        guard !denumire.isEmpty else {
            errorMessage = "Campul denumire trebuie completat!"
            return
        }

        errorMessage = ""
        DatabaseManager.shared.updateMedicament(medicamentID: medicament.id, denumire: denumire)
        print("Medicament actualizat cu succes!")
        onMedicamentUpdated?()
        isPresented = false
    }
}
