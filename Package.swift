//
//  Package.swift.swift
//  LabibaBotFramework
//
//  Created by Mohammad Khalil on 08/12/2025.
//  Copyright © 2025 Abdul Rahman. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "LabibaBotFramework",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "LabibaBotFramework",
            targets: ["LabibaBotFramework"]
        )
    ],
    targets: [
        .target(
            name: "LabibaChatBot",
            path: "Sources"
        )
    ]
)
