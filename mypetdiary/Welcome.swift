//
//  Welcome.swift
//  mypetdiary
//
//  Created by Laura Páez on 12/17/24.
//

import SwiftUI

struct Welcome: View {
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    @State private var userName: String = ""
    @State private var inputImage: UIImage?
    @State private var showHi = false
    @State private var showConfirmationDialog = false
    @State private var showImagePicker = false
    @State private var imageSource:
    UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    
    var body: some View {
        VStack {
            Text("Welcome to your Pet Diary!")
                .font(.custom("DynaPuff", size: 50))
                .foregroundColor(Color(.mymutedpurple))
                .multilineTextAlignment(.center)
                .padding()
            
            Text("Keep track of your pets photos and add notes to your memories!")
                .font(.custom("DynaPuff", size: 20))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(.hookersgreen))
                .padding()
        }
        
        VStack {
            if showHi {
                Text("Nice to meet you, \(userName) !")
                    .disableAutocorrection(true)
                    .font(.custom("DynaPuff", size: 30))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(.mylightpink))
                Button("Re-enter name"){
                    userName = ""
                    showHi = false
                }
                .padding()
                .font(.custom("DynaPuff", size: 15))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(.mylightpink))
            } else {
                Text("Let's be friends!")
                    .padding()
                    .font(.custom("DynaPuff", size: 30))
                    .foregroundColor(Color(.mylightpink))
                    .multilineTextAlignment(.center)
                
                // arrow down
                Image(systemName: "arrowshape.down.fill")
                    .foregroundColor(Color(.mylightpink))
                    .multilineTextAlignment(.center)
                    
                TextField("Enter name", text: $userName)
                    .padding()
                    .font(.custom("DynaPuff", size: 30))
                    .foregroundColor(Color(.mylightpink))
                    .multilineTextAlignment(.center)
                    .onSubmit {
                        showHi = true
                    }
            }
        }
        
        if let image = selectedImage {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 5)
                .frame(maxWidth: 300, maxHeight: 300)
            
            if inputImage != nil && userName != "" {
                Button("Save") {
                    UserDefaults.standard.set(userName, forKey: "userName")
                    if let inputImage = inputImage, let imageData = inputImage.jpegData(compressionQuality: 0.8) {
                        UserDefaults.standard.set(imageData, forKey: "profilePicture")
                    }
                    isFirstLaunch = true
                }
                .font(.custom("DynaPuff", size: 40))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(.mylightpink))
                
            }
        } else {
            Text("")
            Button("Upload Profile Photo") {
                showConfirmationDialog = true
            }
            .font(.custom("DynaPuff", size: 18))
            .padding()
            .background(Color.mylightsage)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .shadow(radius: 5)
            .confirmationDialog(
                "Choose a source",
                isPresented: $showConfirmationDialog,
                titleVisibility: .visible
            ) {
                Button("Camera") {
                    self.imageSource = .camera         // Set the data
                    self.showImagePicker = true     // Flip the trigger to TRUE
                }
                
                Button("Photo Library") {
                    self.imageSource = .photoLibrary   // Set the data
                    self.showImagePicker = true     // Flip the trigger to TRUE
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(sourceType: self.imageSource, selectedImage: $selectedImage)
            }
        }
            
    }
    
    
    
}

