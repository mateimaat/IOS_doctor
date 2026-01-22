import SwiftUI

struct AddPacientView: View {
    @State private var cnp: String = ""
    @State private var nume: String = ""
    @State private var prenume: String = ""
    @State private var adresa: String = ""
    @State private var asigurare: String = ""
    @State private var errorMessage: String = ""
    @Environment(\.presentationMode) var presentationMode
    var onPacientAdded: (() -> Void)?

    var body: some View {
        VStack {
            Text("Adauga Pacient")
                .font(.largeTitle)
                .padding()

            TextField("CNP", text: $cnp)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            TextField("Nume", text: $nume)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            TextField("Prenume", text: $prenume)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            TextField("Adresa", text: $adresa)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            TextField("Asigurare", text: $asigurare)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }

            Button(action: {
                adaugaPacient()
            }) {
                Text("Adauga Pacient")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }

    private func adaugaPacient() {
        guard !cnp.isEmpty, !nume.isEmpty, !prenume.isEmpty, !adresa.isEmpty, !asigurare.isEmpty else {
            errorMessage = "Trebuie completate toate campurile!"
            return
        }

        errorMessage = ""
        DatabaseManager.shared.addPacient(cnp: cnp, nume: nume, prenume: prenume, adresa: adresa, asigurare: asigurare)
        print("Pacient adăugat cu succes!")

        onPacientAdded?()
        presentationMode.wrappedValue.dismiss()
    }
}
