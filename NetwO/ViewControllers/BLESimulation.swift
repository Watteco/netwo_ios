//
//  BLESimulation.swift
//  NetwO
//
//  Simulation BLE pour iOS Simulator
//

import Foundation

enum BLESimulation {

    static var enabled: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }

    struct SimDevice {
        let name: String
        let appeui: String
        let deveui: String
    }

    static let devices: [SimDevice] = [
        SimDevice(name: "WTC-SIM-001", appeui: "0011223344556677", deveui: "8899AABBCCDDEEFF"),
        SimDevice(name: "WTC-SIM-002", appeui: "1122334455667788", deveui: "FFEEDDCCBBAA9988"),
    ]

    static func canScan(bluetoothEnabled: Bool) -> Bool {
        return enabled || bluetoothEnabled
    }

    static func fakePeripheralNames() -> [String] {
        return devices.map { $0.name }
    }

    /// Simule une connexion : envoie APPEUI/DEVEUI + notif "connected"
    static func connect(to index: Int) {
        guard enabled else { return }
        let i = max(0, min(index, devices.count - 1))
        let d = devices[i]

        NotificationCenter.default.post(name: .BLEDeviceConnected, object: nil)
        NotificationCenter.default.post(name: .BLECollectDatas, object: "APPEUI:\(d.appeui)\n")
        NotificationCenter.default.post(name: .BLECollectDatas, object: "DEVEUI:\(d.deveui)\n")
        NotificationCenter.default.post(name: .BLECollectDatas, object: "TX 0/10\n")
    }

    /// Démarre un test "Sxxx" : génère des blocs compatibles avec parseData()
    static func startTest(total: Int) {
        guard enabled else { return }

        let totalClamped = max(1, min(total, 200))
        var current = 0

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            current += 1
            if current > totalClamped {
                timer.invalidate()
                emitResult(total: totalClamped)
                return
            }
            emitSample(current: current, total: totalClamped)
        }
    }

    private static func emitSample(current: Int, total: Int) {
        let gw = Int.random(in: 1...5)
        let margin = Int.random(in: 0...20)
        let sftx = Int.random(in: 7...12)
        let snr = Int.random(in: -12...2)
        let rssi = Int.random(in: (-120)...(-90))
        let windows = Int.random(in: 1...2)
        let sfrx = sftx
        let delay = Int.random(in: 1...5)
        let battery = Int.random(in: 300...370) // -> ~3.0..3.7V avec ton calcul actuel
        let oper = [0, 2, 7, 15, 19].randomElement()!

        let payload =
        """
        \(current)/\(total)
        Gateway:\(gw)
        Margin:\(margin)
        SFTX:\(sftx)
        SNR:\(snr)
        RSSI:\(rssi)
        Windows:\(windows)
        SFRX:\(sfrx)
        Delay:\(delay)
        Battery:\(battery)
        Operator:\(oper)

        """

        NotificationCenter.default.post(name: .BLECollectDatas, object: "TX \(current)/\(total)\n")
        NotificationCenter.default.post(name: .BLECollectDatas, object: payload)
    }

    private static func emitResult(total: Int) {
        // Ton parser lit lines[4..7] quand lines[1] contient "RESULT"
        let payload =
        """
        \(total)/\(total)
        RESULT
        -
        -
        Gateway:3
        Margin:11
        SNR:-6
        RSSI:-110

        """
        NotificationCenter.default.post(name: .BLECollectDatas, object: payload)
    }

    /// Parse "S10,7,1,comment" -> 10
    static func parseTotalFromSCommand(_ s: String) -> Int? {
        let cleaned = s.trimmingCharacters(in: .whitespacesAndNewlines)
        guard cleaned.first == "S" else { return nil }
        let noS = cleaned.dropFirst()
        let parts = noS.split(separator: ",")
        guard let first = parts.first else { return nil }
        return Int(first)
    }
    
    static func bootstrap(forDeviceName name: String?) {
        guard enabled else { return }

        // fallback si nom absent
        let d: SimDevice
        if let name, let found = devices.first(where: { $0.name == name }) {
            d = found
        } else {
            d = devices.first!
        }

        NotificationCenter.default.post(name: .BLECollectDatas, object: "APPEUI:\(d.appeui)\n")
        NotificationCenter.default.post(name: .BLECollectDatas, object: "DEVEUI:\(d.deveui)\n")
        NotificationCenter.default.post(name: .BLECollectDatas, object: "TX 0/10\n")
    }

}
