////
////  add:edit worker.swift
////  20.6 core data
////
////  Created by Дмитрий Богданов on 19.07.2024.
////
//
//import SwiftUI
//import CountryPicker
//import CoreData
//
////import SwiftUI
//import CountryPicker // убедитесь, что библиотека импортирована
//
//struct add_edit_worker2: View {
//    
//   
//    
//    let worker: Worker?
//    @State var firstname: String
//    @State var subname: String
//    @State var workercountry: String
//    @State var birthday: Date
//    
//    @State private var showCountryPicker = false
//    
//    var body: some View {
//        NavigationView {
//            Form {
//                TextField("Имя", text: $firstname)
//                TextField("Фамилия", text: $subname)
//                DatePicker("Дата рождения", selection: $birthday, displayedComponents: .date)
//                
//                Button(action: {
//                    showCountryPicker.toggle()
//                }) {
//                    HStack {
//                        Text("Страна")
//                        Spacer()
//                        Text(workercountry.isEmpty ? "Выберите страну" : workercountry)
//                            .foregroundColor(.gray)
//                    }
//                }
//            }
//            .navigationBarTitle("Форма", displayMode: .inline)
//            .sheet(isPresented: $showCountryPicker) {
//                CountryPickerView { country in
//                    self.workercountry = country.localizedName
//                    self.showCountryPicker = false
//                }
//            }
//        }
//    }
//}
//
//
//
//
//
//
//
//
//
//#Preview {
//    NavigationView(content: {
//        add_edit_worker(w: nil)
//    })
//}
