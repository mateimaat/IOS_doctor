import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @State private var showCreateUserView = false
    @Binding var isLoggedIn: Bool
    @Binding var userRole: String

    var body: some View {
        ZStack {
            Image("fundal")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Autentificare")
                    .font(.largeTitle)
                    .padding(.top, 20)
                    .foregroundColor(.white)

                TextField("Nume utilizator", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                SecureField("Parola", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }

                Button(action: handleLogin) {
                    Text("Conectare")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Button(action: {
                    showCreateUserView = true
                }) {
                    Text("Creeaza user nou")
                        .padding()
                        .background(Color.blue.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .sheet(isPresented: $showCreateUserView) {
                    CreateUserView(isPresented: $showCreateUserView)
                }
            }
            .padding()
        }
    }

    private func handleLogin() {
        if let user = DatabaseManager.shared.getUser(username: username, password: password) {
            isLoggedIn = true
            userRole = user.role
        } else {
            errorMessage = "Date de login incorecte!"
        }
    }
}
