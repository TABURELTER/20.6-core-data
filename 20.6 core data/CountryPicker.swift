//
//  c.swift
//  20.6 core data
//
//  Created by Дмитрий Богданов on 29.07.2024.
//

import SwiftUI
import CountryPicker

struct CountryPicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = CountryPickerViewController
    
    @Binding var country: Country?
    
    func makeUIViewController(context: Context) -> CountryPickerViewController {
        let countryPicker = CountryPickerViewController()
        countryPicker.selectedCountry = "RU"
        CountryManager.shared.config.showPhoneCodes = false
        CountryManager.shared.localeIdentifier = "ru_ru"
        countryPicker.delegate = context.coordinator
        return countryPicker
    }
    
    func updateUIViewController(_ uiViewController: CountryPickerViewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, CountryPickerDelegate {
        var parent: CountryPicker
        init(_ parent: CountryPicker) {
            self.parent = parent
        }
        func countryPicker(didSelect country: Country) {
            parent.country = country
        }
    }
}
struct CountryPickerView: View {
    var onSelectCountry: (Country) -> Void
    @State private var selectedCountry: Country?
    
    var body: some View {
        NavigationView {
            CountryPicker(country: $selectedCountry)
                .navigationBarTitle("Выберите страну")
                .onChange(of: selectedCountry?.localizedName) { _ in
                    if let country = selectedCountry {
                        onSelectCountry(country)
                    }
                }
        }
    }
}
