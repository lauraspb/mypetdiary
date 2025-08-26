//
//  ContentView.swift
//  mypetdiary
//
//  Created by Laura Páez on 12/13/24.
//
import SwiftUI
import Photos

struct CatEntry: Identifiable {
    let id = UUID()
    var date: Date
    var photo: Image?
    var notes: String
    var pets: [String]
}

struct ContentView: View {
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    @State private var showAddEntryView = false
    @State private var inputImage: UIImage?
    @State private var entries: [CatEntry] = []
    @State private var editMode: EditMode = .inactive
    @State private var selection: Set<UUID> = []
    
    var body: some View {
        if isFirstLaunch {
            Welcome()
        } else {
            NavigationView {
                VStack {
                    List {
                        ForEach(entries) { entry in
                            entryRow(for: entry)
                        }
                        .onDelete(perform: deleteEntry) // This is where it goes
                        
                    }
                    .id(UUID()) // Add this line to force re-rendering
                    .navigationTitle("Pet Diary Edit")
                    .toolbar {
                        EditButton()
                    }
                    
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
                }
            }
        }
    }
        

    // Function to create the HStack for each entry
    private func entryRow(for entry: CatEntry) -> some View {
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
    
    func deleteEntry(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
    }
}
