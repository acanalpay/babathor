# babathor
A secure chat system implemented with Flutter/Dart for a Cyber Security Contest called Hackathor.

## Getting Started
			
HACKATHOR:	Cyber Security Hackathon by Turkish Cyber Security Cluster
Group Name:	BabaThor
App Name:	SecureChat

Our biggest difference from other chat systems is that we store messages in the users phone.

Thus, no one else get access to others messages. In order to do that, we planned to use peer-to-peer connection between phones. 

Each person enters  ID -which created randomly after user enters its name- to each other and through server, port will be created between users that want to talk. 
After that, their messages will send through this port and will written in to the local file of the phones. 
Thus, without using cloud or firebase users will be able to send messages to each other. 

Currently our application creates and stores the local files of the messages, but messages are send through database, after receiver open the application messages are deleting from the database.

## License
The MIT License (MIT)

Copyright (c) 2015 Chris Kibble

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
