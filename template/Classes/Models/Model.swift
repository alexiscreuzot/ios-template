//
//  MyModel.swift
//  template
//
//  Created by Alexis Creuzot on 20/03/2020.
//  Copyright © 2020 alexiscreuzot. All rights reserved.
//

import Foundation

class MyModel: Codable, Hashable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
    }
    
    var id : UUID
    var title : String
    
    // MARK - Hahshable, Equatable
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    static func == (lhs: MyModel, rhs: MyModel) -> Bool {
        return lhs.id == rhs.id
    }
}
