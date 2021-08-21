import Foundation
import Darwin.C.stdlib
import ArgumentParser
import Socket

// // Returns the number of arguments passed to the program.
// let argumentCount:Int = CommandLine.arguments.count

// // Returns an array/list(pythonic) of arguments passed to the program
// let args = CommandLine.arguments

// // ====START-HIGH_QUALITY_COMMANDLINE_PARSING====.

let banner: String =
#"""
krypted's
     ______   __  __     ______     ______     ______     ______
    /\  ___\ /\ \/\ \   /\___  \   /\___  \   /\  ___\   /\  == \
    \ \  __\ \ \ \_\ \  \/_/  /__  \/_/  /__  \ \  __\   \ \  __<
     \ \_\    \ \_____\   /\_____\   /\_____\  \ \_____\  \ \_\ \_\
      \/_/     \/_____/   \/_____/   \/_____/   \/_____/   \/_/ /_/
                                                                   
"""#

print(banner)

// // Oops ... my bad ... Ended up not using this enum though.
//enum SocketError: String {
//    case ConnectError
//    case socketCreateFailed = "[*] Failed to create socket! ... that's unexpected though ... "
//}


 struct Fuzz: ParsableCommand {
     @Option(name: [.short, .customLong("ip")], help: "IP Address to connect to. defaults to localhost(127.0.0.1).")
     var ipAddress: String = "127.0.0.1"

     @Option(name: [.short, .customLong("port")], help: "Port Number to connect with on specified host. defaults to 1337")
     var portNumber: Int32 = 1337

    @Option(name: [.short, .customLong("timeout")], help: "Number of seconds to wait before connection times out. defaults to 10s.")
     var timeOutPeriod: UInt = 10
    
    @Option(name: [.short, .customLong("verbose")], help: "Verbose info. defaults to false")
    var verbose: Bool = false
    
     mutating func run() throws {

        print("[+] Using: IP:\(ipAddress), Port:\(portNumber), Timeout:\(timeOutPeriod)")
        var buffer = [String]()
        var counter: Int = 100
        let loopLimit: Int = 30
        
        // Convert seconds given to milliseconds!.
        timeOutPeriod = timeOutPeriod * 1000

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
            
            var sock:Socket;
            do {
                // Create a socket connection
                sock = try Socket.create()
                if verbose {print("[+] Socket created successfully! ...")}
            } catch {
                print("[*] Failed to create socket! ... that's unexpected though ... ")
                Fuzz.exit(withError: EXIT_SUCCESS as? Error)
            }
            do {
                // Calls "connect" method to actually connect to specified
                // host. with IP address, PORT NUMBER and TIMEOUT period as
                // arguments
                try sock.connect(to: ipAddress, port: portNumber, timeout: timeOutPeriod)
                if verbose {print("[+] Connection created successfully! ...")}
            
            } catch {
                print("[*] Could not connect to: \(ipAddress) on port: \(portNumber)")
                Fuzz.exit(withError: EXIT_SUCCESS as? Error)
            }
            
            // Perform a read of the returned socket.
            // No. of bytes to read as argument.
            // NOTE:: All of the read APIs below can return zero (0).
            // This can indicate that the remote connection was closed
            // or it could indicate that the socket would block
            let buffer = UnsafeMutablePointer<CChar>.allocate(capacity: 1024)
            //pointer.initialize(to: arr)
            //If the host connected to, does not send anything!, the program would block!, forever waiting to read something!!.
            //Comment out the sock.read call below to avoid such!.
            let _ = try? sock.read(into: buffer, bufSize: 1024, truncate:false)
            print("[+] Fuzzing with", bufstring.count, " bytes")
            
             // Here we convert concatenated string to byte in preparation
             // You can specify required encoding.
             let dataTosend: Data = "OVERFLOW1 \(bufstring)\r\n".data(using: .utf8)!
            let _ = try sock.write(from: dataTosend) // Send bytes "OverTheWire" lol
            
             // Perform another read of the socket
             // No. of bytes to read as argument.
             // If the host connected to, does not send anything!, the program would block!, forever waiting to read something!!.
            //Comment out the sock.read call below to avoid such!.
            let _ = try? sock.read(into: buffer, bufSize: 1024, truncate:false)
            
//           // Then we finnally close our goddamn! socket, oops language!.
             sock.close()
         }
         }

     }
 //}
 Fuzz.main()


// //**UNDERSCORE(_) USED THROUGHOUT PROGRAM AS PLACEHOLDER ... i don't like seeing compiler warnings! lol.

