//
//  UserdefaultManager.swift
//  MyCamera
//
//  Created by Aung Ko Min on 9/3/21.
//

import SwiftUI

class UserdefaultManager {
    
    static let shared = UserdefaultManager()
    private let manager = UserDefaults.standard
    
    let _hasShownOnboarding = "hasShownOnboarding"
    let _doneSetup = "doneSetup"
    let _offShutterSound = "playShutterSound"
    let _fontDesign = "fontDesign"

    var fontDesign: FontDesign {
        get {
            return FontDesign(rawValue: manager.integer(forKey: _fontDesign)) ?? .rounded
        }
        set {
            manager.setValue(newValue.rawValue, forKey: _fontDesign)
        }
    }
    
    var hasShownOnboarding: Bool {
        get { return manager.bool(forKey: _hasShownOnboarding) }
        set { manager.setValue(newValue, forKey: _hasShownOnboarding) }
    }
    
    var doneSetup: Bool {
        get { return manager.bool(forKey: _doneSetup) }
        set { manager.setValue(newValue, forKey: _doneSetup) }
    }
}

enum FontDesign: Int, CaseIterable {
    
    case rounded, monoSpaced, serif
    
    var design: Font.Design {
        switch self {
        case .rounded:
            return .rounded
        case .monoSpaced:
            return .monospaced
        case .serif:
            return .serif
        }
    }
    
    var name: String {
        switch self {
        case .monoSpaced:
            return "Monospaced"
        case .serif:
            return "Serif"
        case .rounded:
            return "Rounded"
        }
    }
}

