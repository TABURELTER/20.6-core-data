//
//  ContentView.swift
//  20.6 core data
//
//  Created by Дмитрий Богданов on 14.07.2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest (
        sortDescriptors: [NSSortDescriptor(keyPath: \Worker.firstname, ascending: true)])
    
    private var w: FetchedResults<Worker>
    
    var body: some View {
        NavigationView {
            List{
                Text("количество - \(w.count)").bold()
//                Text("количество - \(w[1].firstname)")
                ForEach(w){worker in
                    NavigationLink(destination:add_edit_worker(w:worker)){
                        Text("\(worker.firstname!) \(worker.subname!)").swipeActions(){
                            Button {
                                do{
                                    viewContext.delete(worker)
                                    try viewContext.save()
                                }catch{
                                    Alert(title: Text(error.localizedDescription))
                                }
                                print("Delete")
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                    }
                }
            }
        }.toolbar {
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
        .navigationTitle("Исполнители")
    }
}

#Preview {
    NavigationView(content: {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    })
}
