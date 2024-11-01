//
//  space_emulator_tests.swift
//  space-emulator-tests
//
//  Created by Matthew Reed on 11/1/24.
//

import Testing
import Foundation
@testable import spaceEmu

struct space_emulator_tests {

    @Test func testInx() async throws {
        let memory = Data([0x03])
        let state = State8080(a: 0, b: 0x1f, c: 0xff, d: 0, e: 0, h: 0, l: 0, sp: 0, pc: 0, memory: memory, cc: ConditionCodes(), int_enable: 0)
        let emu = Emulator(state: state)
        try emu.Emulate8080p()
        #expect(emu.state.b == 0x20)
        #expect(emu.state.c == 0x00)
    }

}
