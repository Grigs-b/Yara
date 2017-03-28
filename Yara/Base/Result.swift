//
//  Result.swift
//  Yara
//
//  Created by Ryan Grigsby on 3/24/17.
//  Copyright © 2017 Grigs-b. All rights reserved.
//

import Foundation

enum Result<S, F> {
    case success(S)
    case failure(F)
}
