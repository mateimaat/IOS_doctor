import SwiftUI

@main
struct Aplicație_medicApp: App {
    @State private var isLoggedIn = false
    @State private var nivelsecuritate = ""

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                if nivelsecuritate == "admin" {
                    ContentView(isLoggedIn: $isLoggedIn)
                } else {
                    ClientView(isLoggedIn: $isLoggedIn)
                }
            } else {
                LoginView(isLoggedIn: $isLoggedIn, userRole: $nivelsecuritate)
            }
        }
    }
}
