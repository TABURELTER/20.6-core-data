//
//  add:edit worker.swift
//  20.6 core data
//
//  Created by Дмитрий Богданов on 19.07.2024.
//

import SwiftUI
import CountryPicker
import CoreData

struct add_edit_worker: View {
    @Environment(\.managedObjectContext) var viewContext
    
    @State var firstname: String
    @State var subname: String
    @State var workercountry: String
    @State var birthday: Date
    
    @State private var showCountryPicker = false
    
//    @State var edit : Bool = false
    
    var w:Worker
    init(w: Worker?) {
//        if w != nil {
//            edit = true
//        }else{
//            edit = false
//        }
        self.w = w ?? Worker()
        self.firstname = w?.firstname ?? ""
        self.subname = w?.subname ?? ""
        self.workercountry = w?.wcountry ?? ""
        self.birthday = w?.birthday ?? Date.now
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Имя", text: $firstname)
                TextField("Фамилия", text: $subname)
                DatePicker("Дата рождения", selection: $birthday, displayedComponents: .date)
                
                Button(action: {
                    showCountryPicker.toggle()
                    print($showCountryPicker)
                }) {
                    HStack {
                        Text("Страна")
                        Spacer()
                        Text(workercountry.isEmpty ? "Выберите страну" : workercountry)
                            .foregroundColor(.gray)
                    }
                }
            }
        }.toolbar{
            ToolbarItem(placement: .topBarTrailing){
                Button {
                    do{
                        w.firstname = $firstname.wrappedValue
                        w.subname = $subname.wrappedValue
                        w.wcountry = $workercountry.wrappedValue
                        w.birthday = $birthday.wrappedValue
                        try viewContext.save()
                        print("сохранили")
                        
                    }catch{
                        print("error - \(error)")
                        print("error - \(error.localizedDescription)")
//                        fatalError(error.localizedDescription)
                    }
                } label: {
                    Text("Сохранить")
                    Image(systemName: "checkmark")
                }
            }
        }
    }
    func s(){
        w.firstname = $firstname.wrappedValue
    }
}



#Preview {
    NavigationView(content: {
        add_edit_worker(w: nil)
    })
}
