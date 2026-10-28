// scripts/export_seed_data.swift
import Foundation

@main
struct ExportApp {
    static func main() throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        let doctorsData = try encoder.encode(Doctor.mockDoctors)
        let clinicsData = try encoder.encode(Clinic.mockClinics)

        try doctorsData.write(to: URL(fileURLWithPath: "scripts/doctors.json"))
        try clinicsData.write(to: URL(fileURLWithPath: "scripts/clinics.json"))
        print("Exported doctors.json and clinics.json successfully")
    }
}
