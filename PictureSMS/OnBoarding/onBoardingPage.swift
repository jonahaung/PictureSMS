//
//  onBoardingPage.swift
//  Food
//
//  Created by BqNqNNN on 7/13/20.
//

import Foundation

struct Page : Identifiable {
    var id : Int
    var image : String
    var title : String
    var descrip : String
}

var OnboardingData = [
    Page(id: 0, image: "photoAlbum", title: "About PhotoSMS", descrip: "An app that provides offline pictures sharing through SMS"),
    
    Page(id: 1, image: "photoAlbum", title: "How Does It Works", descrip: "We send pictures through SMS over GSM network without using internet"),
    Page(id: 2, image: "photoAlbum", title: "Why was this app created", descrip: "To help people communicate even when the internet is not available, especially for the people living in Myanmar where the military has imposed an internet blackout across the country"),
]
