#!/usr/bin/swift

import Foundation

func scanHost(ip:String, startPort:Int, endPort:Int){
    print("Starting TCP port scan on  \(ip)")
    tcp_scan(ip: ip, startPort: startPort, endPort: endPort)
    print("TCP scan on host %s complete \(ip)")
}

func tcp_scan(ip:String, startPort:Int, endPort:Int){
    print(ip)
    print(startPort)
    print(endPort)
    var tcp: TCPClient?
    for port in startPort...endPort{
        tcp = TCPClient(address: ip, port: Int32(port))
        guard let client = tcp else { return }
        switch client.connect(timeout: 10) {
        case .success:
            print("TCP Open \(tcp!.address) \(tcp!.port) ")
        case .failure(_):
            //fail
            print()
        }
        tcp?.close()
    }
}

func scanRange(network:String, startPort:Int, endPort:Int){
    print(" Starting TCP port scan on network \(network)")
    for host in 1..<255{
        let ip = network + "." + String(host)
        tcp_scan(ip: ip, startPort: startPort, endPort: endPort)
        print("TCP scan on network %s.0 complete \(network)")
    }
}



let arguments = CommandLine.arguments
if arguments.count<4 {
    print("Usage: ./portscan <IP address> <start port> <end port>")
    print("Example: ./portscan 192.168.1.10 1 65535\n")
    print("Usage: ./portscan <network> <start port> <end port> -n")
    print("Example: ./portscan 192.168.1 1 65535 -n")
}else if arguments.count >= 4{
    let network   = arguments[1]
    let startPort = Int(arguments[2])
    let endPort   = Int(arguments[3])


    if arguments.count == 4{
        scanHost(ip: network, startPort: startPort!, endPort: endPort!)
    } else if arguments.count == 5{
        scanRange(network: network, startPort: startPort!, endPort: endPort!)
    }
}
