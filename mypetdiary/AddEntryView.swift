//
//  AddEntryView.swift
//  mypetdiary
//
//  Created by Laura Páez on 12/13/24.
//

import SwiftUI
import PhotosUI

enum ImageSource: Identifiable {
    case camera
    case photoLibrary
    var id: Self { self }
}

struct AddEntryView: View {
    @Binding var selectedImage: UIImage?
    @State private var showConfirmationDialog = false
    @Binding var entries: [PetEntry]
    @Environment(\.dismiss) var dismiss
    @State private var imageSource: ImageSource?
    @State private var selectedDate = Date()
    @State private var notes: String = ""
    @State private var petNames: String = ""
    @State private var selectedItem: PhotosPickerItem? // Use PhotosPickerItem
    @State private var showImagePicker = false
    @State private var showActionSheet = false  // To show the action sheet
//    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        NavigationStack {
            Form {
                DatePicker("Date",selection: $selectedDate, displayedComponents: .date)
                    .font(.custom("DynaPuff", size: 20))
                    .foregroundColor(Color(.mymutedpurple))
                
                TextField("Notes", text: $notes)
                    .font(.custom("DynaPuff", size: 20))
                    .foregroundColor(Color(.mymutedpurple))
                
                TextField("Pet Names (comma-separated)", text: $petNames)
                    .font(.custom("DynaPuff", size: 20))
                    .foregroundColor(Color(.mymutedpurple))
                
                Button("Add Photo", systemImage: "camera") {
                    showConfirmationDialog = true
                }
                .font(.custom("DynaPuff", size: 20))
                .foregroundColor(Color(.hookersgreen))
                .labelStyle(.iconOnly)
                .padding()
                .confirmationDialog("Choose Photo Source", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
                    Button("Camera") {
                        imageSource = .camera
                    }
                    Button("Photo Library") {
                        imageSource = .photoLibrary
                    }
                    Button("Cancel", role: .cancel) { }
                }
                .sheet(item: $imageSource) { source in
                    let sourceType: UIImagePickerController.SourceType = (source == .camera) ? .camera : .photoLibrary
                    ImagePicker(sourceType: sourceType, selectedImage: $selectedImage)
                }
            }
        }
        if selectedImage != nil {
            Button("Save Entry") {
                let newEntry = PetEntry(
                    date: selectedDate,
                    photo: selectedImage != nil ? Image(uiImage: selectedImage!) : nil,
                    notes: notes,
                    pets: petNames.components(separatedBy: ",")
                )
                entries.append(newEntry)
                dismiss()
            }
        } else {
            Text("Select a photo first!")
                .font(.custom("DynaPuff", size: 15))
                .foregroundColor(Color(.mylightpink))
        }
    }
}
