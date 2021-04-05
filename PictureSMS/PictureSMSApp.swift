//
//  PictureSMSApp.swift
//  PictureSMS
//
//  Created by Aung Ko Min on 2/4/21.
//

import SwiftUI

@main
struct PictureSMSApp: App {
    
    @AppStorage(UserdefaultManager.shared._fontDesign) private var fontDesign: Int = UserdefaultManager.shared.fontDesign.rawValue
    @AppStorage(UserdefaultManager.shared._hasShownOnboarding) private var hasShownOnboarding: Bool = UserdefaultManager.shared.hasShownOnboarding
    @AppStorage(UserdefaultManager.shared._doneSetup) private var doneSetup: Bool = UserdefaultManager.shared.doneSetup
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if hasShownOnboarding {
                    ContentView()
                }else {
                    OnboardingView(isFirstTime: true)
                }
            }
            
            .font(.system(size: UIFont.buttonFontSize, weight: .regular, design: FontDesign(rawValue: fontDesign)?.design ?? .default))
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
