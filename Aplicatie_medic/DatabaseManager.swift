import Foundation
import SQLite
import CryptoKit
typealias Expression = SQLite.Expression

// Modele pentru fiecare tabel
struct Pacient: Identifiable, Hashable {
    let id: Int64
    let cnp: String
    let nume: String
    let prenume: String
    let adresa: String
    let asigurare: String
}

struct Medicament: Identifiable, Hashable {
    let id: Int64
    let denumire: String
}

struct Medic: Identifiable, Hashable {
    let id: Int64
    let nume: String
    let prenume: String
    let specializare: String
}


struct Consultatie: Identifiable {
    var id: Int64
    var pacientID: Int64
    var pacientNume: String
    var pacientPrenume: String
    var medicamentID: Int64
    var medicamentDenumire: String
    var medicID: Int64
    var medicNume: String
    var medicPrenume: String
    var data: String
    var diagnostic: String
    var dozaMedicament: String
}


class DatabaseManager {
    static let shared = DatabaseManager()
    
    private var db: Connection?

    private let medicTable = Table("Medic")
    private let pacientTable = Table("Pacient")
    private let medicamenteTable = Table("Medicamente")
    private let consultatieTable = Table("Consultatie")

    private let medicID = Expression<Int64>("MedicID")
    private let numeMedic = Expression<String>("NumeMedic")
    private let prenumeMedic = Expression<String>("PrenumeMedic")
    private let specializare = Expression<String>("Specializare")

    private let pacientID = Expression<Int64>("PacientID")
    private let cnp = Expression<String>("CNP")
    private let numePacient = Expression<String>("NumePacient")
    private let prenumePacient = Expression<String>("PrenumePacient")
    private let adresa = Expression<String>("Adresa")
    private let asigurare = Expression<String>("Asigurare")

    private let medicamentID = Expression<Int64>("MedicamentID")
    private let denumire = Expression<String>("Denumire")

    private let consultatieID = Expression<Int64>("ConsultatieID")
    private let fkPacientID = Expression<Int64>("PacientID")
    private let fkMedicamentID = Expression<Int64>("MedicamentID")
    private let fkMedicID = Expression<Int64>("MedicID")
    private let dataConsultatie = Expression<String>("Data")
    private let diagnostic = Expression<String>("Diagnostic")
    private let dozaMedicament = Expression<String>("DozaMedicament")


    private init() {
        connectToDatabase()
    }

    
    private func connectToDatabase() {
        do {
            
            if let bundlePath = Bundle.main.path(forResource: "main", ofType: "sqlite") {
                let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let writablePath = documentsPath.appendingPathComponent("main.sqlite")

                if !FileManager.default.fileExists(atPath: writablePath.path) {
                    try FileManager.default.copyItem(atPath: bundlePath, toPath: writablePath.path)
                    print("Baza de date a fost copiata.")
                }
                
                if let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    print("Calea bazei de date în Simulator: \(documentsPath.path)")
                }

                db = try Connection(writablePath.path)
                print("Conexiunea la baza de date a fost realizata cu succes!")
            } else {
                print("Eroare: Fisierul bazei de date nu a fost gasit.")
            }
        } catch {
            print("Eroare la conectarea sau copierea bazei de date: \(error)")
        }
    }
    
    func hashPassword(_ password: String) -> String {
        let data = Data(password.utf8)
        let hashed = SHA256.hash(data: data)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }

    
    func getAllMedici() -> [Medic] {
        var medici: [Medic] = []
        do {
            if let rows = try db?.prepare(medicTable) {
                for row in rows {
                    let medic = Medic(
                        id: row[medicID],
                        nume: row[numeMedic],
                        prenume: row[prenumeMedic],
                        specializare: row[specializare]
                    )
                    medici.append(medic)
                }
            }
        } catch {
            print("Eroare la obtinerea medicilor: \(error)")
        }
        return medici
    }

    func addMedic(nume: String, prenume: String, specializare: String) {
        guard !nume.isEmpty, !prenume.isEmpty, !specializare.isEmpty else {
            print("Trebuie completate toate campurile!")
            return
        }

        do {
            try db?.run(medicTable.insert(
                self.numeMedic <- nume,
                self.prenumeMedic <- prenume,
                self.specializare <- specializare
            ))
            print("Medic adaugat cu succes!")
        } catch {
            print("Eroare la adaugarea medicului: \(error)")
        }
    }
    
    func updateMedic(medicID: Int64, nume: String, prenume: String, specializare: String) {
        guard !nume.isEmpty, !prenume.isEmpty, !specializare.isEmpty else {
            print("Eroare: Toate campurile trebuie completate!")
            return
        }

        do {
            let medic = medicTable.filter(self.medicID == medicID)
            try db?.run(medic.update(
                self.numeMedic <- nume,
                self.prenumeMedic <- prenume,
                self.specializare <- specializare
            ))
            print("Medic actualizat cu succes!")
        } catch {
            print("Eroare la actualizarea medicului: \(error)")
        }
    }


    
    func deleteMedic(medicID: Int64) {
        do {
            let medic = medicTable.filter(self.medicID == medicID)
            try db?.run(medic.delete())
            print("Medic sters cu succes!")
        } catch {
            print("Eroare la stergerea medicului: \(error)")
        }
    }


    func getAllPacienti() -> [Pacient] {
        var pacienti: [Pacient] = []
        do {
            if let rows = try db?.prepare(pacientTable) {
                for row in rows {
                    let pacient = Pacient(
                        id: row[pacientID],
                        cnp: row[cnp],
                        nume: row[numePacient],
                        prenume: row[prenumePacient],
                        adresa: row[adresa],
                        asigurare: row[asigurare]
                    )
                    pacienti.append(pacient)
                }
            }
        } catch {
            print("Eroare la obtinerea pacientilor: \(error)")
        }
        return pacienti
    }

    func addPacient(cnp: String, nume: String, prenume: String, adresa: String, asigurare: String) {
        do {
            try self.db?.run(self.pacientTable.insert(
                self.cnp <- cnp,
                self.numePacient <- nume,
                self.prenumePacient <- prenume,
                self.adresa <- adresa,
                self.asigurare <- asigurare
            ))
            print("Pacient adaugat cu succes!")
        } catch {
            print("Eroare la adaugarea pacientului: \(error)")
        }
    }
    
    func updatePacient(pacientID: Int64, cnp: String, nume: String, prenume: String, adresa: String, asigurare: String) {
        do {
            let pacient = self.pacientTable.filter(self.pacientID == pacientID)
            try self.db?.run(pacient.update(
                self.cnp <- cnp,
                self.numePacient <- nume,
                self.prenumePacient <- prenume,
                self.adresa <- adresa,
                self.asigurare <- asigurare
            ))
            print("Pacient actualizat cu succes!")
        } catch {
            print("Eroare la actualizarea pacientului: \(error)")
        }
    }
    
    func deletePacient(pacientID: Int64) {
        do {
            let pacient = pacientTable.filter(self.pacientID == pacientID)
            try db?.run(pacient.delete())
            print("Pacient sters cu succes!")
        } catch {
            print("Eroare la stergerea pacientului: \(error)")
        }
    }

    func getAllMedicamente() -> [Medicament] {
        var medicamente: [Medicament] = []
        do {
            if let rows = try db?.prepare(medicamenteTable) {
                for row in rows {
                    let medicament = Medicament(
                        id: row[medicamentID],
                        denumire: row[denumire]
                    )
                    medicamente.append(medicament)
                }
            }
        } catch {
            print("Eroare la obtinerea medicamentelor: \(error)")
        }
        return medicamente
    }

    func addMedicament(denumire: String) {
        do {
            try db?.run(medicamenteTable.insert(self.denumire <- denumire))
            print("Medicament adaugat cu succes!")
        } catch {
            print("Eroare la adaugarea medicamentului: \(error)")
        }
    }
    
    func updateMedicament(medicamentID: Int64, denumire: String) {
        let medicament = medicamenteTable.filter(self.medicamentID == medicamentID)
        do {
            try db?.run(medicament.update(self.denumire <- denumire))
            print("Medicament actualizat cu succes!")
        } catch {
            print("Eroare la actualizarea medicamentului: \(error)")
        }
    }

    func deleteMedicament(medicamentID: Int64) {
        let medicament = medicamenteTable.filter(self.medicamentID == medicamentID)
        do {
            try db?.run(medicament.delete())
            print("Medicament sters cu succes!")
        } catch {
            print("Eroare la stergerea medicamentului: \(error)")
        }
    }

    func getAllConsultatii() -> [Consultatie] {
        var consultatii: [Consultatie] = []
        let query = """
        SELECT Consultatie.ConsultatieID, Consultatie.PacientID, Pacient.NumePacient AS PacientNume, Pacient.PrenumePacient AS PacientPrenume,
               Consultatie.MedicamentID, Medicamente.Denumire AS MedicamentDenumire,
               Consultatie.MedicID, Medic.NumeMedic AS MedicNume, Medic.PrenumeMedic AS MedicPrenume,
               Consultatie.Data, Consultatie.Diagnostic, Consultatie.DozaMedicament
        FROM Consultatie
        INNER JOIN Pacient ON Consultatie.PacientID = Pacient.PacientID
        INNER JOIN Medicamente ON Consultatie.MedicamentID = Medicamente.MedicamentID
        INNER JOIN Medic ON Consultatie.MedicID = Medic.MedicID
        """
        do {
            if let statement = try db?.prepare(query) {
                for row in statement {
                    let consultatie = Consultatie(
                        id: row[0] as! Int64,
                        pacientID: row[1] as! Int64,
                        pacientNume: row[2] as! String,
                        pacientPrenume: row[3] as! String,
                        medicamentID: row[4] as! Int64,
                        medicamentDenumire: row[5] as! String,
                        medicID: row[6] as! Int64,
                        medicNume: row[7] as! String,
                        medicPrenume: row[8] as! String,
                        data: row[9] as! String,
                        diagnostic: row[10] as! String,
                        dozaMedicament: row[11] as! String
                    )
                    consultatii.append(consultatie)
                }
            }
        } catch {
            print("Eroare la obtinerea consultațiilor: \(error)")
        }
        return consultatii
    }
    
    func addConsultatie(pacientID: Int64, medicamentID: Int64, medicID: Int64, data: String, diagnostic: String, dozaMedicament: String) {
        do {
            try self.db?.run(self.consultatieTable.insert(
                self.fkPacientID <- pacientID,
                self.fkMedicamentID <- medicamentID,
                self.fkMedicID <- medicID,
                self.dataConsultatie <- data,
                self.diagnostic <- diagnostic,
                self.dozaMedicament <- dozaMedicament
            ))
            print("Consultatie adaugata cu succes!")
        } catch {
            print("Eroare la adaugarea consultatiei: \(error)")
        }
    }
    
    func updateConsultatie(id: Int64, pacientID: Int64, medicamentID: Int64, medicID: Int64, data: String, diagnostic: String, dozaMedicament: String) {
        let query = """
        UPDATE Consultatie
        SET PacientID = ?, MedicamentID = ?, MedicID = ?, Data = ?, Diagnostic = ?, DozaMedicament = ?
        WHERE ConsultatieID = ?
        """
        do {
            try db?.run(query, pacientID, medicamentID, medicID, data, diagnostic, dozaMedicament, id)
            print("Consultatie actualizata cu succes!")
        } catch {
            print("Eroare la actualizarea consultatiei: \(error)")
        }
    }
    
    func deleteConsultatie(consultatieID: Int64) {
        do {
            let consultatie = self.consultatieTable.filter(self.consultatieID == consultatieID)
            try self.db?.run(consultatie.delete())
            print("Consultatie stearsă cu succes!")
        } catch {
            print("Eroare la stergerea consultatiei: \(error)")
        }
    }
    
    func autentificaUtilizator(numeUtilizator: String, parola: String) -> String? {
        let hashedPassword = hashPassword(parola) // Hash-uiește parola pentru comparare
        let query = "SELECT Rol FROM Utilizatori WHERE NumeUtilizator = ? AND Parola = ?"
        do {
            if let db = db {
                let statement = try db.prepare(query, [numeUtilizator, hashedPassword])
                if let row = statement.next() {
                    return row[0] as? String
                }
            }
        } catch {
            print("Eroare la autentificare: \(error)")
        }
        return nil
    }
    
    func getUser(username: String, password: String) -> (username: String, role: String)? {
        let hashedPassword = hashPassword(password)
        let query = "SELECT NumeUtilizator, Rol FROM Utilizatori WHERE NumeUtilizator = ? AND Parola = ?"
        do {
            if let db = db {
                let statement = try db.prepare(query, [username, hashedPassword])
                if let row = statement.next() {
                    return (username: row[0] as! String, role: row[1] as! String)
                }
            }
        } catch {
            print("Eroare la obținerea utilizatorului: \(error)")
        }
        return nil
    }
    func createUser(username: String, password: String, role: String) -> Bool {
        let hashedPassword = hashPassword(password) // Hash-uiește parola
        let query = "INSERT INTO Utilizatori (NumeUtilizator, Parola, Rol) VALUES (?, ?, ?)"
        do {
            try db?.run(query, username, hashedPassword, role)
            return true
        } catch {
            print("Eroare la crearea utilizatorului: \(error)")
            return false
        }
    }
}
