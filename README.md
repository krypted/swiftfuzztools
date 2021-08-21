# swiftfuzztools

The Mac is changing. We've long had a platform where out-of-the-box we were able to compile and run tools in a variety of languages. Over the years the evolving security posture has us moving from a POSIX-compliant platform capable of being used for widespread security research to a sandboxed operating system. And yet we need to be able to perform basic security research on a machine in an unaltered state. 

Many applications now use a web or rest-based exchange of information. However, legacy tools and others still rely on socket comms. Thus we need to be able to interrogate, establish communications, and test the security of those using native Apple technologies. These tools are meant to provide ways for security researchers to borrow components for use in their own tools. 

## Directories/Files in this project

• Fuzz Xcode Project: A full xcode project that is the later evolution of the fuzz_SwiftLibrary

• buff Xcode Project: A full xcode project (w/ swift package) to send the stream

• executable binaries: Stand-alone executables that can run from the above projects

• badchars: ascii characters known to break code/stream execution

• portscan1: Swift-based port scanner built using SwiftSocket (not yet completed)


## Related(ish) Projects

Many of these need to be converted/modernized but lay the framework for poking around at this and that, here and there:

• https://github.com/krypted/contentblockblock: another project used to test bypassing SFContentBlockerManager 

• https://github.com/krypted/DisplayPush: another project used to investigate URIs in APNs 

• https://github.com/krypted/Word-Replacer-Safari-Extension: another project for Safari Extensions

• https://github.com/krypted/JSONhashandvalidate: json hashing services

• https://github.com/krypted/lightweightrecommender: Simple recommender for pipelining fuzzing results to a machine learning framework

• https://github.com/krypted/lightweightcategorizer: Categorizing machine learning sample to pipeline results to/from

• https://github.com/krypted/mobileconfigsigner: Signs mobileconfigs for further localized testing options

• https://github.com/krypted/shortcutter: Used to automate iOS "Shortcuts" testing

• https://github.com/krypted/maccvecheck: Lookup cves on a Mac

• https://github.com/krypted/looto: Opposite of otool - looks up dependencies

• https://github.com/krypted/ipasign: re-signs an .ipa bundle

## Assets From Other Developers/Researchers

• https://github.com/danielmiessler/SecLists/blob/master/Fuzzing/big-list-of-naughty-strings.txt Strings for fuzzing that can be dropped in this project

• https://www.matteomalvica.com/tutorials/buffer_overflow/ One of many fuzzing journeys using the common python options (shorter than most so thought it might be easier to follow along with) 

• Domato: A DOM fuzzer from Google Project Zero https://github.com/googleprojectzero/domato
