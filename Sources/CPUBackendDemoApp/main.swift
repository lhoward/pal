//
// main.swift
// Fireblade Engine
//
// Created by Christian Treffs on 14.04.2021.
//
// Copyright © 2021 Fireblade Team. All rights reserved.
// Licensed under GNU General Public License v3.0. See LICENSE file for details.

import FirebladePAL

Platform.initialize()
print("Platform version: \(Platform.version)")

// either use a custom surface sub-class
// or use the default implementation directly
// let surface = CPUSurface()
let window = try Window(properties: WindowProperties(title: "Title", frame: .init(0, 0, 800, 600)),
                        surface: { try CPUWindowSurface(in: $0) })

try window.setupSurface()

guard let surface = window.surface as? CPUWindowSurface else {
    fatalError("no window surface")
}

var event = Event()

var quit = false

while !quit {
    Events.pumpEvents()

    while Events.pollEvent(&event) {
        switch event.variant {
        case .userQuit:
            quit = true

        case .window:
            if case let .resizedTo(newSize) = event.window.action {
                try surface.handleWindowResize()
            }

        default:
            break
        }
    }

    surface.clear()
    surface.flush()
}

Platform.quit()