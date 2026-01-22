import SwiftUI

struct AddMedicView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var nume: String = ""
    @State private var prenume: String = ""
    @State private var specializare: String = ""
    @State private var errorMessage: String = ""
    var onMedicAdded: (() -> Void)?

    var body: some View {
        VStack {
            Text("Adauga Medic")
                .font(.largeTitle)
                .padding()

            TextField("Nume", text: $nume)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            TextField("Prenume", text: $prenume)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            TextField("Specializare", text: $specializare)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }

            Button(action: adaugaMedic) {
                Text("Adauga Medic")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding()
    }

    private func adaugaMedic() {
        let trimmedNume = nume.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPrenume = prenume.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedSpecializare = specializare.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedNume.isEmpty, !trimmedPrenume.isEmpty, !trimmedSpecializare.isEmpty else {
            errorMessage = "Trebuie completate toate campurile!"
            return
        }
        errorMessage = ""
        DatabaseManager.shared.addMedic(nume: trimmedNume, prenume: trimmedPrenume, specializare: trimmedSpecializare)
        print("Medic adaugat cu succes!")
        onMedicAdded?()
        dismiss()
    }
}
