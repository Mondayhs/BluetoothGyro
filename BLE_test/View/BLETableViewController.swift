//
//  BLETableViewController.swift
//  BLE_test
//
//  Created by zhou Chou on 2023/6/13.
//

import UIKit
import CoreBluetooth



class BLETableViewController: UITableViewController, CBCentralManagerDelegate, CBPeripheralDelegate {

    
//    @IBOutlet weak var AcromaxButton: UIBarButtonItem!
    
    private var centralManager: CBCentralManager!
    private var peripherals: [CBPeripheral] = []
    private var peripheralNames:[String] = []
    public var selectedPeripheral : CBPeripheral?
    var showDisconnectionWarning: Bool = true
    var Deviceservices: [CBService] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        let button = UIButton()
        button.Buildbarbutton(selector:#selector(AcromaxButtonPress), target:self)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    @objc private func AcromaxButtonPress(_ sender: UIBarButtonItem) {
            print("Acromax")
        UIApplication.shared.open(URL(string: "https://acromaxinc.com/homepage-zhtw/")!)
    }

    @IBAction func onScan(_ sender: UIBarButtonItem) {
        
        if (self.selectedPeripheral != nil) {
            self.showDisconnectionWarning = false
            centralManager?.cancelPeripheralConnection(self.selectedPeripheral!)
            self.selectedPeripheral = nil
        }
        self.peripherals = []
        self.peripheralNames = []
        self.tableView.reloadData()
        self.centralManager.scanForPeripherals(withServices: nil)
    }
    
    func resizeImage(image: UIImage, width: CGFloat) -> UIImage {
            let size = CGSize(width: width, height:
                image.size.height * width / image.size.width)
            let renderer = UIGraphicsImageRenderer(size: size)
            let newImage = renderer.image { (context) in
                image.draw(in: renderer.format.bounds)
            }
            return newImage
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return peripheralNames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("in table0")
        // Configure the cell...
        let cellidentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellidentifier, for: indexPath)
        if peripheralNames[indexPath.row] != "unamed device" {
            cell.textLabel?.text = "\(peripheralNames[indexPath.row])"
        }
        return cell
    }
    
    // choose Device
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        if indexPath.row < self.peripherals.count {
            self.selectedPeripheral = self.peripherals[indexPath.row]
//            print("thiseself:", self.selectedPeripheral)
//            print("thiseselect:", self.peripherals[indexPath.row])
            centralManager.connect(selectedPeripheral!, options: nil)
            self.performSegue(withIdentifier: "showDevice", sender: self)
//            print("connect?:" ,connectToPeripheral())
            if centralManager != nil && centralManager.state != .poweredOn {
                let alert = UIAlertController(title: "Bluetooth is off", message: "Please enable it in settings", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        centralManager?.stopScan()
    }   // END tableView( didSelectRowAt )
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
            return true
    }
    
    

    
    // MARK: - Find bluetooh Device
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case   .poweredOn:
            print("Bluetooth open")
        case   .unauthorized:
            print("unauthorized")
        case   .poweredOff:
            print("Bluetooth off")
        default:
            print("Unknow")
        }
        central.scanForPeripherals(withServices: nil)
        print("Scanning")
//        self.tableView.reloadData()
    }   // END func centralManagerDidUpdateState
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//        print(peripheral)
//        decodePeripheralState(peripheralState: peripheral.state)
        guard peripheral.name != nil else { return }    // 如果是 unknow 則不紀錄
        if !peripherals.contains(peripheral) {          // 如果不重複就存
//            print(peripheral.name ?? default value)
            peripherals.append(peripheral)
            
            peripheralNames.append(peripheral.name ?? "unamed device")
        }
        self.tableView.reloadData()
    }   // END func centralManager
    
    // MARK: - connect bluetooh
//    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//        print("dooo didconnecttt")
//        print("11111:", centralManager as Any)
//        print("1111-ph:", peripheral as Any)
////        // discover all service
////        peripheral.discoverServices(nil)
////        peripheral.delegate = self
//////        self.performSegue(withIdentifier: "showDevice", sender: self)
////
//    } // END func centralManager didConnect
//
//    func centralManager(_ central: CBCentralManager, didDisconnect peripheral: CBPeripheral) {
//        print("-------",self.showDisconnectionWarning)
//        if self.showDisconnectionWarning {
//            let alert = UIAlertController(title: "Disconnected", message: "The peripheral \(String(describing: peripheral.name!)) has been disconnected", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
//                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "ConnectionLost")))
//            }))
//            self.present(alert, animated: true, completion: nil)
//        }
//        self.showDisconnectionWarning = true
//
//    } // END func centralManager didDisConnect
//    
    
    
    func connectToPeripheral() -> Bool {
        guard self.centralManager.state == .poweredOn else {
            return false
        }
        guard self.selectedPeripheral!.state == .connected else {
            return false
        }
//        centralManager.connect(peripheral, options: nil)
        return true
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDevice" {
            guard segue.destination is DeviceViewController else {
                assert(false, "Error retrieving destination")
                return
            }
            let backButton = UIBarButtonItem()
            backButton.title = "MainPage"
            navigationItem.backBarButtonItem = backButton
            
            let vc = segue.destination as! DeviceViewController
            vc.peripheral = self.selectedPeripheral
            print("need to tx:", self.centralManager as Any)
            vc.centralManager = self.centralManager
        }
        
        
    }
    

}



