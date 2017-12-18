//
//  Dictionary+Encodable.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 19.12.2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import Foundation

extension Encodable {
    func asDictionary() -> [String: AnyObject]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject] else {
            return nil
        }
        return dictionary
    }
}
