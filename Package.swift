//
//  Package.swift
//  LabibaBotFramework
//
//  Created by Mohammad Khalil on 08/12/2025.
//  Copyright © 2025 Abdul Rahman. All rights reserved.
//


// swift-tools-version:6.2

import PackageDescription

let package = Package(
    name: "LabibaBotFramework",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "LabibaBotFramwork",
            targets: ["LabibaBotFramework"]
            
        )
    ],
    targets: [
        .target(
            name: "LabibaBotFramwork",
            path: "Sources/LabibaBotFramwork"
        )
    ]
)
