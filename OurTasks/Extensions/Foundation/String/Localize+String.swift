//
//  Localize+String.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 09.11.2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import Foundation

extension String {
    public func localize() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
