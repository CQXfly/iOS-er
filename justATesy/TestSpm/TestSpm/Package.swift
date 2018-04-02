// swift-tools-version:4.0
//
//  Package.swift
//  TestSPM
//
//  Created by fox on 2018/4/2.
//  Copyright © 2018年 fox. All rights reserved.
//
import PackageDescription

let package = Package(
    name: "TestSPM",

    dependencies: [
        /* Add your package dependencies in here
        .package(url: "https://github.com/AlwaysRightInstitute/cows.git",
                 from: "1.0.0"),
        */
        .package(url: "https://github.com/AlwaysRightInstitute/cows.git", from: "1.0.0"),
    ],

    targets: [
        // "." is because we do not have the sources in Sources,
        .target(name: "TestSPM", 
                dependencies: [
                  /* Add your target dependencies in here, e.g.: */
                  // "cows",
                  "cows",
                ],
                path: ".")
    ]
)
