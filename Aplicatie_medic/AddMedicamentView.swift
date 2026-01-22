import SwiftUI

struct AddMedicamentView: View {
    @Binding var isPresented: Bool
    @State private var denumire: String = ""
    @State private var errorMessage: String = ""
    var onMedicamentAdded: (() -> Void)?

    var body: some View {
        VStack {
            Text("Adauga Medicament")
                .font(.largeTitle)
                .padding()

            TextField("Denumire", text: $denumire)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }

            Button(action: {
                adaugaMedicament()
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
    }

    private func adaugaMedicament() {
        guard !denumire.isEmpty else {
            errorMessage = "Trebuie completata denumirea!"
            return
        }

        errorMessage = ""
        DatabaseManager.shared.addMedicament(denumire: denumire)
        print("Medicament adaugat cu succes!")
        onMedicamentAdded?()
        isPresented = false
    }
}
