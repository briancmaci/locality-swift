//
//  BundleExtension.swift
//  locality-swift
//
//  Created by Brian Maci on 3/1/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
