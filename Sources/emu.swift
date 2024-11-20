//
//  emu.swift
//  swift8080
//
//  Created by Matthew Reed on 11/20/24.
//

import Foundation

enum EmuError: Error {
    case unimplementedInstruction
}

enum Flags {
    case z, s, p, cy
}

class Emu {
    let memory: Data
    var pc = 0
    var sp = 0xf000
    
    //MARK: Registers
    var a: UInt8 = 0
    var b: UInt8 = 0
    var c: UInt8 = 0
    var d: UInt8 = 0
    var e: UInt8 = 0
    var h: UInt8 = 0
    var l: UInt8 = 0
    
    //MARK: Flags
    var z: UInt8 = 1
    var s: UInt8 = 1
    var p: UInt8 = 1
    var cy: UInt8 = 1
    var ac: UInt8 = 1
    var pad: UInt8 = 3
    
    var intEnable: UInt8 = 0
    
    
    init(rom: Data) {
        var memory = Data(count: 0x4000)
        
        for (index, byte) in rom.enumerated() {
            memory[index] = byte
        }

        self.memory = memory
    }
    
    func emulate() throws {
        guard let op = OpCode(rawValue: memory[pc]) else {
            throw EmuError.unimplementedInstruction
        }
        
        pc += 1
        switch op {
        case .nop: break
        case .lxiB:
            b = memory[pc + 1]
            c = memory[pc]
            pc += 2
        case .staxB:
            a = getMem(hi: b, lo: c)
        case .inxB:
            let bc = getRP(hi: b, lo: c)
            let answer = bc + 1
            b = UInt8(answer >> 8)
            c = UInt8(answer & 0x00ff)
        case .inrB:
            let answer = UInt16(b) + 1
            setFlags(answer, flagsToSet: [.z, .s, .p])
        case .dcrB:
            let answer = UInt16(b) + 1
            setFlags(answer, flagsToSet: [.z, .s, .p])
        case .mviB:
            b = memory[pc]
            pc += 1
        case .rlc:
            let hiBit = (a & 0x80) >> 7
            a = a << 1 | hiBit
            cy = hiBit
        }
    }
    
    private func getMem(hi: UInt8, lo: UInt8) -> UInt8 {
        let address = Int(hi) << 8 | Int(lo)
        return memory[address]
    }
    
    private func getRP(hi: UInt8, lo: UInt8) -> UInt16 {
        return UInt16(hi) << 8 | UInt16(lo)
    }
    
    private func setFlags(_ answer: UInt16, flagsToSet: [Flags]) {
        if flagsToSet.contains(.z) {
            let lo = answer & 0x00ff
            self.z = lo == 0 ? 1 : 0
        }
        
        if flagsToSet.contains(.s) {
            let hiBit = answer & 0x80
            self.s = hiBit != 0 ? 1 : 0
        }
        if flagsToSet.contains(.p) {
            self.p = answer % 2 == 0 ? 1 : 0
        }
        
        if flagsToSet.contains(.cy) {
            self.cy = answer > 0xff ? 1 : 0
        }
    }
}
