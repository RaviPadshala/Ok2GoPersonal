import Foundation
import CoreBluetooth

// MARK: - Eddystone UID Model

struct EddystoneUID {
    
    let namespace: String
    let instance: String
    let rssi: Int
    let peripheralID: UUID
    let deviceName: String
    
    var uid: String {
        return "\(namespace)-\(instance)"
    }
}

// MARK: - Eddystone Beacon Helper

final class EddystoneBeaconHelper: NSObject {
    
    // MARK: Singleton
    
    static let shared = EddystoneBeaconHelper()
    
    private override init() {
        super.init()
        
        centralManager = CBCentralManager(
            delegate: self,
            queue: .main
        )
    }
    
    // MARK: Bluetooth
    
    private var centralManager: CBCentralManager!
    
    private let eddystoneUUID =
    CBUUID(string: "FEAA")
    
    private var isScanning = false
    
    // Prevent duplicate UID callbacks
    private var discoveredUIDs = Set<String>()
    
    // MARK: Callbacks
    
    /// Called whenever a new Eddystone UID is found
    var onUIDFound: ((EddystoneUID) -> Void)?
    
    /// Called when Bluetooth state changes
    var onBluetoothStateChanged: ((CBManagerState) -> Void)?
    
    /// Called when scanning starts
    var onScanStarted: (() -> Void)?
    
    /// Called when scanning stops
    var onScanStopped: (() -> Void)?
    
    // MARK: Public Properties
    
    var scanning: Bool {
        return isScanning
    }
    
    // MARK: Start Scanning
    
    func startScanning() {
        
        guard centralManager.state == .poweredOn else {
            
            print("Eddystone: Bluetooth is not available")
            
            return
        }
        
        // Clear previously discovered UID
        discoveredUIDs.removeAll()
        
        centralManager.scanForPeripherals(
            withServices: [eddystoneUUID],
            options: [
                CBCentralManagerScanOptionAllowDuplicatesKey: true
            ]
        )
        
        isScanning = true
        
        onScanStarted?()
        
        print("Eddystone: Scan started")
    }
    
    // MARK: Stop Scanning
    
    func stopScanning() {
        print("Eddystone: Scan stopped")
        guard isScanning else {
            return
        }
        
        centralManager.stopScan()
        
        isScanning = false
        
        onScanStopped?()
        
        
    }
    
    func scanForUIDs(
        duration: TimeInterval = 5.0,
        completion: @escaping ([EddystoneUID]) -> Void
    ) {

        discoveredUIDs.removeAll()

        var results: [EddystoneUID] = []

        let previousCallback = onUIDFound

        onUIDFound = { beacon in

            if !results.contains(where: {
                $0.uid == beacon.uid
            }) {
                results.append(beacon)
            }
            previousCallback?(beacon)
        }

        startScanning()

        DispatchQueue.main.asyncAfter(
            deadline: .now() + duration
        ) { [weak self] in

            guard let self = self else {
                return
            }

            self.stopScanning()

            self.onUIDFound = previousCallback

            completion(results)
        }
    }
    
    // MARK: Clear
    
    func clearUIDs() {
        
        discoveredUIDs.removeAll()
    }
    
    // MARK: Process Advertisement
    
    private func processBeacon(
        peripheral: CBPeripheral,
        advertisementData: [String: Any],
        rssi: NSNumber
    ) {
        
        guard let serviceData =
                advertisementData[
                    CBAdvertisementDataServiceDataKey
                ] as? [CBUUID: Data]
        else {
            return
        }
        
        guard let data =
                serviceData[eddystoneUUID]
        else {
            return
        }
        
        // ------------------------------------------------
        // Eddystone UID frame
        //
        // Byte 0     = Frame Type (0x00)
        // Byte 1     = TX Power
        // Byte 2-11  = Namespace (10 bytes)
        // Byte 12-17 = Instance (6 bytes)
        // ------------------------------------------------
        
        guard data.count >= 18 else {
            return
        }
        
        // Must be Eddystone-UID
        guard data[0] == 0x00 else {
            return
        }
        
        // MARK: Namespace
        
        let namespace = data[2..<12]
            .map {
                String(format: "%02X", $0)
            }
            .joined()
        
        // MARK: Instance
        
        let instance = data[12..<18]
            .map {
                String(format: "%02X", $0)
            }
            .joined()
        
        let uid = "\(namespace)-\(instance)"
        
        // ------------------------------------------------
        // Ignore duplicate UID
        // ------------------------------------------------
        
        guard !discoveredUIDs.contains(uid) else {
            return
        }
        
        discoveredUIDs.insert(uid)
        
        let deviceName =
        peripheral.name ??
        advertisementData[
            CBAdvertisementDataLocalNameKey
        ] as? String ??
        "Unknown Device"
        
        let result = EddystoneUID(
            namespace: namespace,
            instance: instance,
            rssi: rssi.intValue,
            peripheralID: peripheral.identifier,
            deviceName: deviceName
        )
        
//        print("""
//        ==============================
//        EDDYSTONE UID FOUND
//        ==============================
//        Device   : \(deviceName)
//        Namespace: \(namespace)
//        Instance : \(instance)
//        UID      : \(uid)
//        RSSI     : \(rssi.intValue)
//        UUID     : \(peripheral.identifier.uuidString)
//        ==============================
//        """)
        
        onUIDFound?(result)
    }
}

// MARK: - CBCentralManagerDelegate

extension EddystoneBeaconHelper: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        onBluetoothStateChanged?(central.state)
        
        switch central.state {
            
        case .poweredOn:
            
            print("Eddystone: Bluetooth ON")
            
        case .poweredOff:
            
            print("Eddystone: Bluetooth OFF")
            
            if isScanning {
                stopScanning()
            }
            
        case .unauthorized:
            
            print("Eddystone: Bluetooth permission denied")
            
        case .unsupported:
            
            print("Eddystone: Bluetooth not supported")
            
        case .resetting:
            
            print("Eddystone: Bluetooth resetting")
            
        case .unknown:
            
            print("Eddystone: Bluetooth state unknown")
            
        @unknown default:
            break
        }
    }
    
    func centralManager(_ central: CBCentralManager,didDiscover peripheral: CBPeripheral,advertisementData: [String: Any],rssi RSSI: NSNumber) {
        processBeacon(peripheral: peripheral,advertisementData: advertisementData,rssi: RSSI)
    }
}
