//
//  main.swift
//  PortScanner
//
//


import Foundation
import ArgumentParser
import Socket
import Darwin.C.stdlib


let banner:String = #"""
krypted.com's
                      __  _____
    ____  ____  _____/ /_/ ___/_________ _____  ____  ___  _____
   / __ \/ __ \/ ___/ __/\__ \/ ___/ __ `/ __ \/ __ \/ _ \/ ___/
  / /_/ / /_/ / /  / /_ ___/ / /__/ /_/ / / / / / / /  __/ /
 / .___/\____/_/   \__//____/\___/\__,_/_/ /_/_/ /_/\___/_/
/_/
                
"""#

print(banner)

struct pscan: ParsableCommand {

    @Argument(help: "IP address to scan. -Used as network ID when (Network scan) flag is specified!.")
    var ipAddress: String;

    @Argument(help: "Start of port range to scan.")
    var startPort: Int;

    @Argument(help: "End of port range to scan.")
    var endPort: Int;

    @Flag(name: .shortAndLong, help: "Network scan flag. When set, performs network scan (as opposed to single host scan).")
    var netscan = false;

    @Flag(name: .shortAndLong, help: "Verbose output")
    var verbose: Bool = false;
    
    @Option(name: .shortAndLong, help:"Timeout in seconds to wait, before moving on. default = 1 seconds. (don't wait forever, love is still out there ... LOL")
    var timeOutInSeconds : UInt = 1;


    func scanHost(ipAddress: String, startPort: Int, endPort: Int) {
        // Starts a TCP scan on a given IP address """
        print("[+] Starting TCP port scan on host: \(ipAddress)")
        print("[-]")

        // Begin TCP Scan on host
        tcpScan(ipAddress: ipAddress, startPort: startPort, endPort: endPort)
        print("[-]")
        print("[+] TCP Scan on host \(ipAddress) complete")
        
        }
    

    // def scanRange(network, startPort, endPort):
    func scanRange(networkId: String, startPort: Int, endPort: Int){

        // """ Starts a TCP scan on a given IP address range """

        print("[+] Starting TCP port scan on network \(networkId)")
        print("[-]")
        // # Iterate over a range of host IP addresses and scan each target
        for host in 1...255 {
            let IP = networkId + "." + String(host)
            tcpScan(ipAddress: IP, startPort: startPort, endPort: endPort)
        }
        print("[-]")
        print("[+] TCP Scan on network \(networkId) complete!.")
    }

        func tcpScan(ipAddress: String, startPort: Int, endPort: Int) {
            
            let timeOutInMilliSeconds : UInt = timeOutInSeconds * 1000
            
            // Creates a TCP socket and attempts to connect via supplied ports """
            //for port in range(startPort, endPort + 1):
            for portNumber in startPort...endPort {
                let _: Socket;
                do{
                    let sock: Socket = try Socket.create(family: Socket.ProtocolFamily.inet, type: Socket.SocketType.stream, proto: Socket.SocketProtocol.tcp);
                    do{
                        if verbose{
                        print("[-] Trying: \(ipAddress):\(portNumber) ... ... ... ", terminator: "")
                        }
                        //if not tcp.connect_ex((ip, port)):
                        try sock.connect(to: ipAddress, port: Int32(portNumber), timeout: timeOutInMilliSeconds)
                        // Print if the port is open
                        if verbose{
                            print("...... OPEN ")
                        } else{
                            print("[+] \(ipAddress):\(portNumber) /TCP Open")
                        }
                        sock.close()
                    } catch {
                        if verbose{
                            print("CLOSED ... ")
                        } else{
                            //print("[*] ", separator: "", terminator: "")
                        }

                    }
                } catch {
                    print("[*] Failed to create socket ... exiting! ")
                    pscan.exit(withError: EXIT_SUCCESS as? Error)
                }
                
            }
            
        }
    
    
        mutating func run() throws {
            
            if netscan {
                print("[+] Network:\(ipAddress), PortRange:\(startPort) -> \(endPort)\n")
                scanRange(networkId: ipAddress, startPort: startPort, endPort: endPort);
            }
            else {
                print("[+] Host:\(ipAddress), PortRange:\(startPort) -> \(endPort)\n")
                scanHost(ipAddress: ipAddress, startPort: startPort, endPort: endPort);
            }
        }
    
}


pscan.main()
