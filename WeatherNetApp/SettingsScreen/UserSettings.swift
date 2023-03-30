//
//  UserSettings.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 28.03.2023.
//

import Foundation

final class UserSettings {

    enum SettingsKeys: String, CaseIterable {
//        case isOnboarding
        case isFahrenheit
        case isImperial
        case isTwelve
        case isNotification
    }

//    static var isOnboarding: Bool {
//        get {
//            UserDefaults.standard.bool(forKey: SettingsKeys.isOnboarding.rawValue)
//        } set {
//            UserDefaults.standard.set(newValue, forKey: SettingsKeys.isOnboarding.rawValue)
//        }
//    }
    static var isFahrenheit: Bool {
        get {
            UserDefaults.standard.bool(forKey: SettingsKeys.isFahrenheit.rawValue)
        } set {
            UserDefaults.standard.set(newValue, forKey: SettingsKeys.isFahrenheit.rawValue)
        }
    }
    static var isImperial: Bool {
        get {
            UserDefaults.standard.bool(forKey: SettingsKeys.isImperial.rawValue)
        } set {
            UserDefaults.standard.set(newValue, forKey: SettingsKeys.isImperial.rawValue)
        }
    }
    static var isTwelve: Bool {
        get {
            UserDefaults.standard.bool(forKey: SettingsKeys.isTwelve.rawValue)
        } set {
            UserDefaults.standard.set(newValue, forKey: SettingsKeys.isTwelve.rawValue)
        }
    }
    static var isNotification: Bool {
        get {
            UserDefaults.standard.bool(forKey: SettingsKeys.isNotification.rawValue)
        } set {
            UserDefaults.standard.set(newValue, forKey: SettingsKeys.isNotification.rawValue)
        }
    }


}
