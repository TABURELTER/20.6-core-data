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
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest (
        sortDescriptors: [NSSortDescriptor(keyPath: \Worker.firstname, ascending: true)])
    
    private var w: FetchedResults<Worker>
    
    var body: some View {
        NavigationStack{

                List{
                    ForEach(w){worker in
                        NavigationLink(destination:add_edit_worker(w:worker)){
                            Text("\(worker.firstname ?? "Ошибка!") \(worker.subname ?? "Ошибка!")").swipeActions(){
                                Button {
                                    do{
                                        viewContext.delete(worker as NSManagedObject)
                                        try viewContext.save()
                                    }catch{
                                        //                                    Alert(title: Text(error.localizedDescription))
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
                        Button(action: {}, label: {
                            Image(systemName: "list.bullet.circle")
                        })
                    }
                    ToolbarItem(placement: .topBarTrailing){
                        NavigationLink(destination: add_edit_worker(w:nil).environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)){
                            Label("add", systemImage: "plus")
                        }
                    }
                }
            }
    }
}

struct add_edit_worker: View {

    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var firstname: String
    @State var subname: String
    @State var workercountry: String
    @State var birthday: Date 
    
    @State private var showCountryPicker = false
    
    @State var worker:Worker?
//    var w:Worker?
    init(w: Worker?) {
        self.firstname = w?.firstname ?? ""
        self.subname = w?.subname ?? ""
        self.workercountry = w?.wcountry ?? ""
        self.birthday = w?.birthday ?? Date.now
        
        worker = w
//        self.w = w
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
                    .sheet(isPresented: $showCountryPicker) {
                        CountryPickerView { country in
                            self.workercountry = country.localizedName
                            self.showCountryPicker = false
                        }
                    }
                }
            }
        }.toolbar{
            ToolbarItem(placement: .topBarTrailing){
                Button {
                    do{

                            
                        worker = Worker(context: PersistenceController.shared.container.viewContext)
#if targetEnvironment(simulator)
                        worker = Worker(context: PersistenceController.preview.container.viewContext)
#endif
                            
                            worker!.firstname = $firstname.wrappedValue
                            worker!.subname = $subname.wrappedValue
                            worker!.wcountry = $workercountry.wrappedValue
                            worker!.birthday = $birthday.wrappedValue

                        print("w?.firstname != nil = \(worker?.firstname != nil) == \(String(describing: worker?.firstname?.description))")
//                        if(worker?.firstname != nil){
//                            viewContext.delete(worker!)
//                        }else{
////                            w=worker
//                        }
//                       try viewContext.save()
                        try PersistenceController.shared.saveData()
                        
                        try presentationMode.wrappedValue.dismiss()
                        
                    }catch{
//                        ForEach(w){worker in
//                        worker
                        print("++++++++++++++++++++++++++++++++++++")
                        print("error - \(error)")
                        print("++++++++++++++++++++++++++++++++++++")
                        print("error - \(error.localizedDescription)")
                        print("++++++++++++++++++++++++++++++++++++")
                    }
                } label: {
                    Text("Сохранить")
                    Image(systemName: "checkmark")
                }.disabled(!Bool(firstname != "" && subname != "" && $birthday != nil && workercountry != ""))
            }
        }
    }

    
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
}
#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
