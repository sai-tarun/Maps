//
//  MapsApp.swift
//  Maps
//
//  Created by Majji  Sai Tarun on 11/04/25.
//

import SwiftUI
import GoogleMaps
import GooglePlaces


@main
struct MapsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate : NSObject,UIApplicationDelegate {
    let Apikey : String = "AIzaSyD_2ZZZd1hSRwHm0dRC_E2XbqNL16-8C2k"
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        GMSServices.provideAPIKey(Apikey)
        GMSPlacesClient.provideAPIKey(Apikey)
        return true
    }
}
