//
//  Character.swift
//  WireCharacterViewer
//
//  Created by Gregory Jones on 7/4/19.
//  Copyright © 2019 Gregory Jones. All rights reserved.
//

import Foundation

struct Initial: Decodable {
    var RelatedTopics: [CharacterDetails]
    
}

struct CharacterDetails: Decodable {
    var Result: String?
    var Text: String?
    var FirstURL: URL?
    var Icon: CharacterIcons
    
    
    init(Result: String, Text: String, FirstURL: URL, Icon: CharacterIcons) {
        self.Result = Result
        self.Text = Text
        self.FirstURL = FirstURL
        self.Icon = Icon
        
    }
}

struct CharacterIcons: Decodable {
    var URL: String?
    
    init(URL: String) {
        self.URL = URL
    }
}
