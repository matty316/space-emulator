//
//  opcode.swift
//  swift8080
//
//  Created by Matthew Reed on 11/20/24.
//

enum OpCode: UInt8 {
    case nop = 0x00
    case lxiB = 0x01
    case staxB = 0x02
    case inxB = 0x03
    case inrB = 0x04
    case dcrB = 0x05
    case mviB = 0x06
    case rlc = 0x07
}

