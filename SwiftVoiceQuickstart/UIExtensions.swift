//
//  UIExtensions.swift
//  SwiftVoiceQuickstart
//
//  Created by Ford Walton on 24/02/2021.
//  Copyright © 2021 Twilio, Inc. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
