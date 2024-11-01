//
//  disassembler.swift
//  space-emulator
//
//  Created by Matthew Reed on 10/25/24.
//

import Foundation

struct Disassembler {
    static func disassemble(codeBuffer: Data, pc: Int) -> Int {
        let code = codeBuffer[pc]
        var opBytes = 1;
        print("\(pc)")
        switch code {
        case 0x00:
            print("NOP")
        case 0x01:
            print("LXI    B, \(codeBuffer[2]) \(codeBuffer[1])")
            opBytes = 3
        case 0x02:
            print("STAX   B")
        case 0x03:
            print("INX    B")
        case 0x04:
            print("INR    B")
        case 0x05:
            print("DCR    B")
        case 0x06:
            print("MVI    B, \(codeBuffer[1])")
            opBytes = 2
        case 0x07:
            print("RLC")
        case 0x08:
            print("NOP")
        case 0x3e:
            print("MVI    A, \(codeBuffer[1])")
            opBytes = 2
        case 0xc3:
            print("JMP    (\(codeBuffer[2]) \(codeBuffer[1]))")
            opBytes = 3
        default: break
        }
        
        return opBytes
    }
}
