# swiftfuzztools

The Mac is changing. We've long had a platform where out-of-the-box we were able to compile and run tools in a variety of languages. Over the years the evolving security posture has us moving from a POSIX-compliant platform capable of being used for widespread security research to a sandboxed operating system. And yet we need to be able to perform basic security research on a machine in an unaltered state. 

Many applications now use a web or rest-based exchange of information. However, legacy tools and others still rely on socket comms. Thus we need to be able to interrogate, establish communications, and test the security of those using native Apple technologies. These tools are meant to provide ways for security researchers to borrow components for use in their own tools. 

##Directories/Files in this project

• portscan: Swift-based port scanner

• fuzz_SwiftLibrary: A couple of tools using swiftsocket (so pod 'SwiftSocket' in the podfile)

• fuzz_sendstuff: Opens a socket and streams to attempt to open a remote shell

• badchars: ascii characters known to break code/stream execution

