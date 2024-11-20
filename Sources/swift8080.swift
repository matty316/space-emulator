//
//  swift8080.swift
//  swift8080
//
//  Created by Matthew Reed on 11/20/24.
//

import ArgumentParser
import Foundation

@main
struct Swift8080: ParsableCommand {
    @Argument var inputs: [String]
    
    func run() throws {
        var rom = Data()
        for input in inputs {
            let url = URL(fileURLWithPath: input)
            let data = try Data(contentsOf: url)
            
            rom.append(data)
        }
        
        let emu = Emu(rom: rom)
        try emu.emulate()
    }
}
