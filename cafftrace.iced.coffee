fs    = require 'fs'
{log} = console


indentChar = "\t"
cutStackOffAt = "Foundation"
stackcut = new RegExp "^#{cutStackOffAt}"


red = (s = '') -> "\u001b[31m#{s}"
green = (s = '') -> "\u001b[32m#{s}"
white = (s = '') -> "\u001b[37m#{s}"

error = (msg) ->
	log red "Error: #{msg}"
	process.exit()


file = process.argv[process.argv.length - 1]
unless file
	error "Requires filename as argument."

await fs.readFile file, defer err, data
if err
	error "reading file -- #{err}"

wellformed = data.toString().trim().replace /,\s*,([^{]|\n)+/g, ","
wellformed = wellformed.replace /\n/g, ""
if wellformed[wellformed.length - 1] is ","
	wellformed = wellformed.substr 0, wellformed.length - 1
wellformed = "[#{wellformed}]"

unsorted = JSON.parse wellformed
unless unsorted
	error "Parsing JSON failed."

sorted = []

for fncall in unsorted
	i = fncall.order - 1
	sorted[i] = fncall
	if fncall.stack
		sorted[i].stack = (fncall.stack.trim().replace /\s\s+/g, '\n').split '\n'
		sorted[i].stack.shift()

if process.argv[process.argv.length - 2] is '--json'
	log sorted
	process.exit()

for f in sorted
	continue unless f

	callstring = ""
	indent = ""
	level = 0
	
	while level < f.level
		indent += indentChar
		level++
	
	callstring += green "#{indent}#{f.probemod} #{f.probefunc}" + white()
	if f.direction is 'entry'
		if f.stack
			shortstack = (s for s in f.stack when not stackcut.exec s)
			callstring += white "\n#{indent}" + shortstack.join "\n#{indent}"
	else callstring += " RETURN\n" + white()
	log callstring

log white "Sorted!"