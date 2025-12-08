//
//  Package.swift.swift
//  LabibaBotFramework
//
//  Created by Mohammad Khalil on 08/12/2025.
//  Copyright © 2025 Abdul Rahman. All rights reserved.
//


import PackageDescription

let package = Package(
    name: "Labiba_Chatbot_pack_IOS",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "Labiba_Chatbot_pack_IOS",
            targets: ["Labiba_Chatbot_pack_IOS"]
        )
    ],
    targets: [
        .target(
            name: "Labiba_Chatbot_pack_IOS",
            path: "Sources"
        )
    ]
)

