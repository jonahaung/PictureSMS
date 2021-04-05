//
//  ContentView.swift
//  PictureSMS
//
//  Created by Aung Ko Min on 2/4/21.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack(spacing: 2) {
            Spacer()
            Text("Collaborate")
                .font(.largeTitle)
                .foregroundColor(.secondary)
                .padding(.top)
               
            Text("Thank you. Collaborate and share knowledge with a private group.")
                .font(.title3)
                .foregroundColor(.secondary)
                
            Spacer()
            NavigationLink(destination: CreateSMSView()) {
                Text("Send Message")
                    .bold()
                    .foregroundColor(.accentColor)
                    .frame(width: 220, height: 60)
                    .border(Color.accentColor, width: 3)
                    .cornerRadius(5)
            }

            NavigationLink(destination: ViewSMSView()) {
                Text("View Message")
                    .bold()
                    .foregroundColor(.accentColor)
                    .frame(width: 220, height: 60)
                    .border(Color.accentColor, width: 3)
                    .cornerRadius(5)
            }
            Spacer()
            Text("Thank you. Collaborate and share knowledge with a private group.")
                .foregroundColor(.secondary)
                
        }
        .multilineTextAlignment(.center)
        .padding()
        .navigationTitle("Picture SMS")
        .navigationBarItems(trailing: settingsButton)
    }
    
    private var settingsButton: some View {
        return NavigationLink(destination: SettingsView()) {
            Image(systemName: "scribble")
        }
    }
}
