//
//  FarmPage.swift
//  Farm-Finder
//
//  Created by vatran robert on 2022-01-12.
//

import Foundation
import SwiftUI

class FarmPage {
  var entries = [FarmEntry]()
    
    init(){
        addMockdata()
    }
    
    
    func addMockdata() {
        entries.append(FarmEntry.init(name: "Dallas", content: "Sell meat eggs eko", image: "egg",location: "Haninge", latitude: 59.11966,longitude: 18.11518))
        entries.append(FarmEntry.init(name: "Österhaninge Gård", content: "Sell eko chicken meat and vegetables", image: "farm",location : "Västerhaninge" ,latitude:59.1216 ,longitude: 17.0973 ))
        entries.append(FarmEntry.init(name: "Gårdsmejeri", content: "Sell eko chese", image: "chese" , location : "Årsta" ,latitude:59.1216 ,longitude: 19.0973 ))
    }
}
