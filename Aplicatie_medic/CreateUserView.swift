import SwiftUI

struct CreateUserView: View {
    @Binding var isPresented: Bool
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var selectedRole: String = "client"
    @State private var errorMessage: String = ""
    @State private var successMessage: String = ""
    
    let roles = ["admin", "client"]

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {

                TextField("Nume utilizator", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                SecureField("Parola", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Picker("Rol", selection: $selectedRole) {
                    ForEach(roles, id: \.self) { role in
                        Text(role.capitalized).tag(role)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }

                Button(action: createUser) {
                    Text("Creeaza")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                Spacer()
            }
            .navigationTitle("Creare user")
            .navigationBarItems(trailing: Button("Anulare") {
                isPresented = false
            })
        }
    }

    private func createUser() {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Trebuie completate toate campurile!"
            return
        }

        let success = DatabaseManager.shared.createUser(username: username, password: password, role: selectedRole)
        if success {
            successMessage = "User creat cu succes!"
            isPresented = false
        } else {
            errorMessage = "Eroare la crearea utilizatorului"
        }
    }
}
