//
//  ContentView.swift
//  20.6 core data
//
//  Created by Дмитрий Богданов on 14.07.2024.
//

import SwiftUI
import CoreData
import CountryPicker
struct ContentView: View {
    let defaults = UserDefaults.standard
    
//    func i() {
//        let ascending:Bool = defaults.bool(forKey: "ascending")
//
//    }
  
    @Environment(\.managedObjectContext) var viewContextE

    @FetchRequest (
        sortDescriptors: [NSSortDescriptor(keyPath: \Worker.firstname, ascending: !UserDefaults.standard.bool(forKey: "ascending"))])
    
    
    private var w: FetchedResults<Worker>
    
    var body: some View {
        
        NavigationStack{
            List{
                ForEach(w){worker in
                    NavigationLink(destination:add_edit_worker(w:worker)){
                        Text("\(worker.firstname ?? "Ошибка!") \(worker.subname ?? "Ошибка!")").swipeActions(){
                            Button {
                                do{
                                    viewContextE.delete(worker as NSManagedObject)
                                    try viewContextE.save()
                                }catch{
                                    Text(error.localizedDescription)
                                }
                                print("Delete")
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                    }
                }
            }.navigationTitle("Исполнители - \(w.count)")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading){
                        Menu{
                            Section("Сортировка"){
                                Button("По возрастанию"){
                                    w.nsSortDescriptors=[NSSortDescriptor(keyPath: \Worker.firstname, ascending: true)]
                                    defaults.set(false, forKey: "ascending")
                                }
                                Button("По убыванию"){
                                    w.nsSortDescriptors=[NSSortDescriptor(keyPath: \Worker.firstname, ascending: false)]
                                    defaults.set(true, forKey: "ascending")
                                }
                            }
                        }label: {
                            Image(systemName: "list.bullet.circle")
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing){
                      
                        NavigationLink(destination: add_edit_worker(w:nil).environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)){
                            Label("add", systemImage: "plus")
                        }
                    }
                }
        }
    }
    //}
    
    struct add_edit_worker: View {
        @Environment(\.managedObjectContext) private var viewContext
        @Environment(\.presentationMode) var presentationMode

        @State var firstname: String = ""
        @State var subname: String = ""
        @State var workercountry: String = ""
        @State var birthday: Date = Date()
        @State private var showCountryPicker = false

        var worker: Worker?

        init(w: Worker?) {
            _firstname = State(initialValue: w?.firstname ?? "")
            _subname = State(initialValue: w?.subname ?? "")
            _workercountry = State(initialValue: w?.wcountry ?? "")
            _birthday = State(initialValue: w?.birthday ?? Date())
            worker = w
        }
        
        var body: some View {
            NavigationView {
                Form {
                    TextField("Имя", text: $firstname)
                    TextField("Фамилия", text: $subname)
                    DatePicker("Дата рождения", selection: $birthday, displayedComponents: .date)
                    
                    Button(action: {
                        showCountryPicker.toggle()
                    }) {
                        HStack {
                            Text("Страна")
                            Spacer()
                            Text(workercountry.isEmpty ? "Выберите страну" : workercountry)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .sheet(isPresented: $showCountryPicker) {
                    CountryPickerView { country in
                        self.workercountry = country.localizedName
                        self.showCountryPicker = false
                    }
                }
               
            } .toolbar {
                ToolbarItem(placement: .automatic) {

                    Button{saveOrUpdateWorker()}
                    label: {
                        Text("Сохранить")
                        Image(systemName: "checkmark")
                    }
                    .disabled(firstname.isEmpty || subname.isEmpty || workercountry.isEmpty)
                }

            }
        }
        
        private func saveOrUpdateWorker() {
            let workerToSave = worker ?? Worker(context: viewContext)
            workerToSave.firstname = firstname
            workerToSave.subname = subname
            workerToSave.wcountry = workercountry
            workerToSave.birthday = birthday
            
            do {
                try viewContext.save()
                presentationMode.wrappedValue.dismiss()
            } catch {
                print("Error saving worker: \(error)")
            }
        }
    }

}


#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
