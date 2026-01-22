import SwiftUI

struct EditPacientView: View {
    @State var pacient: Pacient
    @State private var cnp: String = ""
    @State private var nume: String = ""
    @State private var prenume: String = ""
    @State private var adresa: String = ""
    @State private var asigurare: String = ""
    @State private var errorMessage: String = ""
    @Environment(\.presentationMode) var presentationMode
    var onPacientUpdated: (() -> Void)?

    var body: some View {
        VStack {
            Text("Editeaza Pacient")
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
                editeazaPacient()
            }) {
                Text("Editeaza Pacient")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .onAppear {
            cnp = pacient.cnp
            nume = pacient.nume
            prenume = pacient.prenume
            adresa = pacient.adresa
            asigurare = pacient.asigurare
        }
    }

    private func editeazaPacient() {
        guard !cnp.isEmpty, !nume.isEmpty, !prenume.isEmpty, !adresa.isEmpty, !asigurare.isEmpty else {
            errorMessage = "Trebuie completate toate campurile!"
            return
        }

        errorMessage = ""
        DatabaseManager.shared.updatePacient(
            pacientID: pacient.id,
            cnp: cnp,
            nume: nume,
            prenume: prenume,
            adresa: adresa,
            asigurare: asigurare
        )
        print("Pacient actualizat cu succes!")

        onPacientUpdated?()
        presentationMode.wrappedValue.dismiss()
    }
}
