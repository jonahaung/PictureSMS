//
//  ContentView.swift
//  PictureSMS
//
//  Created by Aung Ko Min on 2/4/21.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        ZStack {
            Image("bg")
            VStack(spacing: 2) {
                Spacer()
                Text("Collaborate")
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(.secondary)
                    .padding(.top)

                Text("Thank you. Collaborate and share knowledge with a private group.")
                    .font(.title3)
                    .foregroundColor(.secondary)

                Spacer()
                NavigationLink(destination: CreateSMSView()) {
                    Text("Create Photo Message")
                        .bold()
                        .foregroundColor(.accentColor)
                        .frame(width: 250, height: 60)
                        .background(Color(.systemBackground))
                        .border(Color.accentColor, width: 3)
                        .cornerRadius(5)
                }

                NavigationLink(destination: ViewSMSView()) {
                    Text("View Photo Message")
                        .bold()
                        .foregroundColor(.accentColor)
                        .frame(width: 250, height: 60)
                        .background(Color(.systemBackground))
                        .border(Color.accentColor, width: 3)
                        .cornerRadius(5)
                }
                Spacer()
                Text("Thank you. Collaborate and share knowledge with a private group.")
                    .foregroundColor(.secondary)
                Spacer()
                HStack {
                    NavigationLink(destination: InboxView()) {
                        Text("Inbox")
                            .underline()
                    }.padding()
                    Spacer()
                }
                    
            }
            .multilineTextAlignment(.center)
            .padding()
            .navigationTitle("Photo SMS")
            .navigationBarItems(trailing: settingsButton)
        }
    }
    
    private var settingsButton: some View {
        return NavigationLink(destination: SettingsView()) {
            Image(systemName: "scribble").padding()
        }
    }
}
