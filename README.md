#dtrace-json

Traces Objective-C method calls by class in a running process, outputting near-JSON data that can be parsed and sorted.

##Usage:

###Dump malformed JSON to text

*Depends on psgrep: https://github.com/jvz/psgrep*

Attaches to a running process by name and dumps output to file.
    
    $ sudo traceapp AppName.app > tracedump.txt

Press **Ctrl+C** when done collecting data.  If traced threads move CPU and lose data, some hand-cleaning of the JSON may be required before parsing.


### Sort and parse dtrace tracedump

*Depends on iced-coffee-script*

Show sorted and indented method calls with stacktrace:
    
    $ iced -I inline cafftrace.iced.coffee tracedump.txt

Output sorted, well-formed JSON:
    
    $ iced -I inline cafftrace.iced.coffee --json tracedump.txt


### Comparing stack traces

Dump each formatted trace to file:

    $ iced -I inline cafftrace.iced.coffee tracedump.txt > prettytrace
    $ iced -I inline cafftrace.iced.coffee tracedump2.txt > prettytrace-2

Side-by-side wide diff to see where traces diverge:

    $ sdiff -w270 prettytrace prettytrace-2


Based off of:

http://stackoverflow.com/questions/10749452/can-the-messages-sent-to-an-object-in-objective-c-be-monitored-or-printed-out/10749819#10749819

http://lists.apple.com/archives/xcode-users/2008/Oct/msg00114.html

**dtrace-json** is MIT licensed.  Copyright 2013 Double Rebel.