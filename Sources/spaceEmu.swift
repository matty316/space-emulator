//
//  spaceEmu.swift
//  spaceEmu
//
//  Created by Matthew Reed on 10/25/24.
//

import Foundation
import ArgumentParser

@main
struct SpaceEmulator: ParsableCommand {
    @Argument var input: String
    
    func run() throws {
        let url = URL(fileURLWithPath: input)
        
        let data = try Data(contentsOf: url)
        
        var pc = 0
        
        while pc < data.count {
            pc += Disassembler.disassemble(codeBuffer: data, pc: pc)
        }
    }
}

