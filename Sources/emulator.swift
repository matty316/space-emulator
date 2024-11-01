//
//  emulator.swift
//  space-emulator
//
//  Created by Matthew Reed on 10/25/24.
//

import ArgumentParser
import Foundation

enum EmulatorError: Error {
    case invalidOpcode
    case unimplimentedOpcode
}

struct ConditionCodes {
    var z = true
    var s = true
    var p = true
    var cy = true
    var ac = true
    var pad: UInt8 = 3
}

struct State8080 {
    var a: UInt8
    var b: UInt8
    var c: UInt8
    var d: UInt8
    var e: UInt8
    var h: UInt8
    var l: UInt8
    var sp: UInt16
    var pc: UInt16
    var memory: Data
    var cc: ConditionCodes
    var int_enable: UInt8
}

class Emulator {
    var state: State8080
    
    init(state: State8080) {
        self.state = state
    }
    
    func Emulate8080p() throws {
        let opcode = state.memory[Int(state.pc)]
        
        switch opcode {
        case 0x00:
            break
        case 0x01:
            state.c = state.memory[Int(state.pc) + 1]
            state.b = state.memory[Int(state.pc) + 2]
            state.pc += 2
        case 0x03:
            let bc = (UInt16(state.b) << 8) | UInt16(state.c)
            let answer = bc + 1
            state.b = UInt8(answer >> 8)
            state.c = UInt8(answer & 0x00ff)
        case 0x04:
            let answer = state.b + 1
            state.cc.z = (answer & 0xff) == 0
            state.cc.s = ((answer & 0x80) != 0)
            state.cc.p = parity(UInt16(answer) & 0xff)
            state.b = answer & 0xff
        case 0x05:
            let answer = state.b - 1
            state.cc.z = (answer & 0xff) == 0
            state.cc.s = ((answer & 0x80) != 0)
            state.cc.p = parity(UInt16(answer) & 0xff)
            state.b = answer & 0xff
        case 0x09:
            let bc = (UInt16(state.b) << 8) | UInt16(state.c)
            let hl = (UInt16(state.h) << 8) | UInt16(state.l)
            let answer = hl + bc
            state.cc.cy = answer > 0xffff
            state.h = UInt8(answer >> 8)
            state.l = UInt8(answer & 0x00ff)
        case 0x0b:
            let bc = (UInt16(state.b) << 8) | UInt16(state.c)
            let answer = bc - 1
            state.b = UInt8(answer >> 8)
            state.c = UInt8(answer & 0x00ff)
        case 0x0c:
            let answer = state.c + 1
            state.cc.z = (answer & 0xff) == 0
            state.cc.s = ((answer & 0x80) != 0)
            state.cc.p = parity(UInt16(answer) & 0xff)
            state.c = answer & 0xff
        case 0x0d:
            let answer = state.c - 1
            state.cc.z = (answer & 0xff) == 0
            state.cc.s = ((answer & 0x80) != 0)
            state.cc.p = parity(UInt16(answer) & 0xff)
            state.c = answer & 0xff
        case 0x13:
            let de = (UInt16(state.d) << 8) | UInt16(state.e)
            let answer = de + 1
            state.d = UInt8(answer >> 8)
            state.e = UInt8(answer & 0x00ff)
        case 0x14:
            let answer = state.d + 1
            state.cc.z = (answer & 0xff) == 0
            state.cc.s = ((answer & 0x80) != 0)
            state.cc.p = parity(UInt16(answer) & 0xff)
            state.d = answer & 0xff
        case 0x15:
            let answer = state.d - 1
            state.cc.z = (answer & 0xff) == 0
            state.cc.s = ((answer & 0x80) != 0)
            state.cc.p = parity(UInt16(answer) & 0xff)
            state.d = answer & 0xff
        case 0x19:
            let de = (UInt16(state.d) << 8) | UInt16(state.e)
            let hl = (UInt16(state.h) << 8) | UInt16(state.l)
            let answer = hl + de
            state.cc.cy = answer > 0xffff
            state.h = UInt8(answer >> 8)
            state.l = UInt8(answer & 0x00ff)
        case 0x1b:
            let de = (UInt16(state.d) << 8) | UInt16(state.e)
            let answer = de - 1
            state.d = UInt8(answer >> 8)
            state.e = UInt8(answer & 0x00ff)
        case 0x1c:
            let answer = state.e + 1
            state.cc.z = (answer & 0xff) == 0
            state.cc.s = ((answer & 0x80) != 0)
            state.cc.p = parity(UInt16(answer) & 0xff)
            state.e = answer & 0xff
        case 0x1d:
            let answer = state.e - 1
            state.cc.z = (answer & 0xff) == 0
            state.cc.s = ((answer & 0x80) != 0)
            state.cc.p = parity(UInt16(answer) & 0xff)
            state.e = answer & 0xff
        case 0x23:
            let hl = (UInt16(state.h) << 8) | UInt16(state.l)
            let answer = hl + 1
            state.h = UInt8(answer >> 8)
            state.l = UInt8(answer & 0x00ff)
        case 0x24:
            let answer = state.h + 1
            state.cc.z = (answer & 0xff) == 0
            state.cc.s = ((answer & 0x80) != 0)
            state.cc.p = parity(UInt16(answer) & 0xff)
            state.h = answer & 0xff
        case 0x25:
            let answer = state.h - 1
            state.cc.z = (answer & 0xff) == 0
            state.cc.s = ((answer & 0x80) != 0)
            state.cc.p = parity(UInt16(answer) & 0xff)
            state.h = answer & 0xff
        case 0x27:
            throw EmulatorError.unimplimentedOpcode
        case 0x29:
            let hl = (UInt16(state.h) << 8) | UInt16(state.l)
            let answer = hl + hl
            state.cc.cy = answer > 0xffff
            state.h = UInt8(answer >> 8)
            state.l = UInt8(answer & 0x00ff)
        case 0x2b:
            let hl = (UInt16(state.h) << 8) | UInt16(state.l)
            let answer = hl - 1
            state.h = UInt8(answer >> 8)
            state.l = UInt8(answer & 0x00ff)
        case 0x2c:
            let answer = state.l + 1
            state.cc.z = (answer & 0xff) == 0
            state.cc.s = ((answer & 0x80) != 0)
            state.cc.p = parity(UInt16(answer) & 0xff)
            state.l = answer & 0xff
        case 0x2d:
            let answer = state.l - 1
            state.cc.z = (answer & 0xff) == 0
            state.cc.s = ((answer & 0x80) != 0)
            state.cc.p = parity(UInt16(answer) & 0xff)
            state.l = answer & 0xff
        case 0x34:
            let offset = (state.h << 8) | state.l
            let answer = state.memory[Int(offset)] + 1
            state.cc.z = (answer & 0xff) == 0
            state.cc.s = ((answer & 0x80) != 0)
            state.cc.p = parity(UInt16(answer) & 0xff)
            state.memory[Int(offset)] = answer & 0xff
        case 0x35:
            let offset = (state.h << 8) | state.l
            let answer = state.memory[Int(offset)] - 1
            state.cc.z = (answer & 0xff) == 0
            state.cc.s = ((answer & 0x80) != 0)
            state.cc.p = parity(UInt16(answer) & 0xff)
            state.memory[Int(offset)] = answer & 0xff
        case 0x3c:
            let answer = state.a + 1
            state.cc.z = (answer & 0xff) == 0
            state.cc.s = ((answer & 0x80) != 0)
            state.cc.p = parity(UInt16(answer) & 0xff)
            state.a = answer & 0xff
        case 0x3d:
            let answer = state.a - 1
            state.cc.z = (answer & 0xff) == 0
            state.cc.s = ((answer & 0x80) != 0)
            state.cc.p = parity(UInt16(answer) & 0xff)
            state.a = answer & 0xff
        case 0x41: state.b = state.c
        case 0x42: state.b = state.d
        case 0x43: state.b = state.e
        case 0x80: add(to: state.b)
        case 0x81: add(to: state.c)
        case 0x82: add(to: state.d)
        case 0x83: add(to: state.e)
        case 0x84: add(to: state.h)
        case 0x85: add(to: state.l)
        case 0x86: addM()
        case 0x87: add(to: state.a)
        case 0x88: adc(to: state.b)
        case 0x89: adc(to: state.c)
        case 0x8A: adc(to: state.d)
        case 0x8B: adc(to: state.e)
        case 0x8C: adc(to: state.h)
        case 0x8D: adc(to: state.l)
        case 0x8E: adcM()
        case 0x8F: adc(to: state.a)
        case 0x90: sub(from: state.b)
        case 0x91: sub(from: state.c)
        case 0x92: sub(from: state.d)
        case 0x93: sub(from: state.e)
        case 0x94: sub(from: state.h)
        case 0x95: sub(from: state.l)
        case 0x96: subM()
        case 0x97: sub(from: state.a)
        case 0x98: subB(from: state.b)
        case 0x99: subB(from: state.c)
        case 0x9A: subB(from: state.d)
        case 0x9B: subB(from: state.e)
        case 0x9C: subB(from: state.h)
        case 0x9D: subB(from: state.l)
        case 0x9E: sbbM()
        case 0x9F: subB(from: state.a)
        case 0xC6: adiData()
        case 0xCE: aciData()
        case 0xD6: suiData()
        case 0xDE: sbiData()
        default: throw EmulatorError.invalidOpcode
        }
        
        state.pc += 1
    }
    
    func incB() {
        
    }
    
    func add(to register: UInt8) {
        let answer = UInt16(state.a) + UInt16(register)
        state.cc.z = (answer & 0xff) == 0
        state.cc.s = ((answer & 0x80) != 0)
        state.cc.cy = answer > 0xff
        state.cc.p = parity(answer & 0xff)
        state.a = UInt8(answer & 0xff)
    }
    
    func adc(to register: UInt8) {
        let answer = UInt16(state.a) + UInt16(register) + (state.cc.cy ? 1 : 0)
        state.cc.z = (answer & 0xff) == 0
        state.cc.s = ((answer & 0x80) != 0)
        state.cc.cy = answer > 0xff
        state.cc.p = parity(answer & 0xff)
        state.a = UInt8(answer & 0xff)
    }
    
    func adiData() {
        add(to: state.memory[Int(state.pc) + 1])
    }
    
    func aciData() {
        adc(to: state.memory[Int(state.pc) + 1])
    }
    
    func addM() {
        let offset = (state.h << 8) | state.l
        add(to: state.memory[Int(offset)])
    }
    
    func adcM() {
        let offset = (state.h << 8) | state.l
        adc(to: state.memory[Int(offset)])
    }
    
    func sub(from register: UInt8) {
        let answer = UInt16(state.a) - UInt16(register)
        state.cc.z = (answer & 0xff) == 0
        state.cc.s = ((answer & 0x80) != 0)
        state.cc.cy = answer < 0
        state.cc.p = parity(answer & 0xff)
        state.a = UInt8(answer & 0xff)
    }
    
    func subB(from register: UInt8) {
        let answer = UInt16(state.a) - UInt16(register) - (state.cc.cy ? 1 : 0)
        state.cc.z = (answer & 0xff) == 0
        state.cc.s = ((answer & 0x80) != 0)
        state.cc.cy = answer < 0
        state.cc.p = parity(answer & 0xff)
        state.a = UInt8(answer & 0xff)
    }
    
    func subM() {
        let offset = (state.h << 8) | state.l
        sub(from: state.memory[Int(offset)])
    }
    
    func sbbM() {
        let offset = (state.h << 8) | state.l
        subB(from: state.memory[Int(offset)])
    }
    
    func suiData() {
        sub(from: state.memory[Int(state.pc) + 1])
    }
    
    func sbiData() {
        subB(from: state.memory[Int(state.pc) + 1])
    }
    
    func parity(_ value: UInt16) -> Bool {
        //TODO
        return true
    }
}
