import SwiftUI

struct EditMedicView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var medic: Medic
    @State private var nume = ""
    @State private var prenume = ""
    @State private var specializare = ""

    var onMedicUpdated: () -> Void

    var body: some View {
        VStack {
            Text("Editeaza Medic")
                .font(.largeTitle)
                .padding()

            TextField("Nume", text: $nume)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Prenume", text: $prenume)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Specializare", text: $specializare)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                DatabaseManager.shared.updateMedic(medicID: medic.id, nume: nume, prenume: prenume, specializare: specializare)
                onMedicUpdated()
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Salveaza Modificările")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            Spacer()
        }
        .onAppear {
            nume = medic.nume
            prenume = medic.prenume
            specializare = medic.specializare
        }
        .padding()
    }
}
