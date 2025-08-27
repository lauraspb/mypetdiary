//
//  ContentView.swift
//  mypetdiary
//
//  Created by Laura Páez on 12/13/24.
//
import SwiftUI
import Photos

struct PetEntry: Identifiable {
    let id = UUID()
    var date: Date
    var photo: Image?
    var notes: String
    var pets: [String]
}

struct ContentView: View {
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    @State var showAddEntryView = false
    @State var inputImage: UIImage?
    @State private var entries: [PetEntry] = []
    @State private var editMode: EditMode = .inactive
    @State private var selection: Set<UUID> = []
    
    var body: some View {
        if isFirstLaunch {
            Welcome()
        } else {
            NavigationStack {
                Text("My Pet Diary")
                    .navigationBarTitleDisplayMode(.inline)
                    .font(.custom("DynaPuff", size: 20))
                    .foregroundColor(Color(.mymutedpurple))
                    .toolbar {
                        Text("hello")
                        EditButton()
                    }
                List {
                    ForEach(entries) { entry in
                        entryRow(for: entry)
                    }
                }
                
                .id(UUID())
                .environment(\.editMode, $editMode)
                .listStyle(.plain)
                .sheet(isPresented: $showAddEntryView) {
                    AddEntryView(selectedImage: $inputImage, entries: $entries)
                        .onDisappear {
                            inputImage = nil
                        }
                }
                
                Button("Add New Entry") {
                    showAddEntryView = true
                }   
                .font(.custom("DynaPuff", size: 20))
                .foregroundColor(Color(.mymutedpurple))
            }
            
        }
    }
        

    // Function to create the HStack for each entry
    private func entryRow(for entry: PetEntry) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(entry.date, style: .date)
                Text(entry.notes)
                Text(entry.pets.joined(separator: ", "))
            }
            Spacer()
            
            let imageView = if let image = entry.photo {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipped()
            } else {
                Image("")
                    .resizable() // Add these modifiers
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipped()
            }
            
            imageView
        }
        .onTapGesture {
            if editMode == .active {
                if selection.contains(entry.id) {
                    selection.remove(entry.id)
                } else {
                    selection.insert(entry.id)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
