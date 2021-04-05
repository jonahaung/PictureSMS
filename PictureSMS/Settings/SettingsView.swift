//
//  SettingsView.swift
//  PictureSMS
//
//  Created by Aung Ko Min on 3/4/21.
//

import SwiftUI
import AVFoundation
import MessageUI

private enum PresentViewType: Identifiable {
    var id: PresentViewType { return self }
    case eulaView, onboardingView, mailCompose, activityView, instructionsView
}

struct SettingsView: View {
    
    @AppStorage(UserdefaultManager.shared._hasShownOnboarding) private var hasShownOnboarding: Bool = UserdefaultManager.shared.hasShownOnboarding
    @State private var presentViewType: PresentViewType?
    
    @AppStorage(UserdefaultManager.shared._fontDesign) private var fontDesignIndex: Int = UserdefaultManager.shared.fontDesign.rawValue
    
    
    var body: some View {
        Form {
            
            Section(header: Text("Device Settings").foregroundColor(Color(.tertiaryLabel))) {
                
                Picker(selection: $fontDesignIndex, label: Text("Font Design")) {
                    Text(FontDesign.rounded.name).tag(FontDesign.rounded.rawValue)
                    Text(FontDesign.monoSpaced.name).tag(FontDesign.monoSpaced.rawValue)
                    Text(FontDesign.serif.name).tag(FontDesign.serif.rawValue)
                }
                
                Button(action: {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                }) {
                    Text("Open Device Settings")
                }
            }
            
            Section(header: Text("App Settings").foregroundColor(Color(.tertiaryLabel))) {
                SettingCell(text: "App Version", subtitle: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String, imageName: "app.badge")
                    .foregroundColor(.secondary)
                Button(action: {
                    presentViewType = .onboardingView
                }) {
                    SettingCell(text: "App Walkthrough", subtitle: nil, imageName: "greetingcard")
                }
                Button(action: {
                    presentViewType = .instructionsView
                }) {
                    SettingCell(text: "How to use the app", subtitle: nil, imageName: "greetingcard")
                }
                Button(action: {
                    presentViewType = .eulaView
                }) {
                    SettingCell(text: "User License Agreement", subtitle: nil, imageName: "scroll")
                }
                Button(action: {
                    SettingManager.shared.gotoPrivacyPolicy()
                }) {
                    SettingCell(text: "Privacy Policy Website", subtitle: nil, imageName: "exclamationmark.shield")
                }
                
            }
            
            Section(header: Text("App Informations").foregroundColor(Color(.tertiaryLabel))) {
                
                Button(action: {
                    presentViewType = .activityView
                }) {
                    SettingCell(text: "Share App", subtitle: nil, imageName: "app.gift")
                }
                Button(action: {
                    SettingManager.shared.rateApp()
                }) {
                    SettingCell(text: "Rate on AppStore", subtitle: nil, imageName: "line.horizontal.star.fill.line.horizontal")
                }
            }
            
            Section(header: Text("Contacts").foregroundColor(Color(.tertiaryLabel)), footer: Text("Aung Ko Min (iOS Developer)\nSingapore\n+65 88585229\njonahaung@gmail.com").foregroundColor(.secondary).padding()) {
                Button(action: {
                    if MFMailComposeViewController.canSendMail() {
                        presentViewType = .mailCompose
                    }
                    
                }) {
                    SettingCell(text: "Contact Us", subtitle: nil, imageName: "mail")
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .navigationTitle("Settings")
        .sheet(item: $presentViewType) { type in
            switch type {
            case .eulaView:
                EULAView(showAgreementButton: false)
            case .onboardingView:
                OnboardingView(isFirstTime: false)
            case .mailCompose:
                MailComposeView()
            case .activityView:
                let url = URL(string: "https://apps.apple.com/us/app/bmcamera/id1560405807")
                ActivityView(activityItems: [url!])
            case .instructionsView:
                InstructionsView()
            }
        }
    }
}
