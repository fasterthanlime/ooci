/* Let me present you: the ooc repl for poor people with much time - torfppwmt (tm) */

use readline, rock
import readline
import rock/frontend/CommandLine

import io/[File, FileReader,FileWriter]
import os/Process
import structs/ArrayList
import text/Buffer

checkBunch: func (bunch: String) -> Bool {
    (bunch count('(') == bunch count(')')) && (bunch count('{') == bunch count('}'))
}

main: func (args: ArrayList<String>) {
    REPL new() run()
}

REPL: class {
    file: File

    init: func {
        file = File new("/tmp/repl.ooc")
        clear()
    }

    clear: func {
        writer := FileWriter new(file)
        writer write("") .close()
    }

    append: func (text: String) {
        writer := FileWriter new(file, true)
        writer write(text)
        writer close()
    }

    compile: func {
        CommandLine new(["rock", "-tcc", "-sourcepath=/tmp", "-q", "-o=/tmp/repl", "repl.ooc"] as ArrayList<String>)
        Process new(["/tmp/repl"] as ArrayList<String>) execute()
    }

    readBunch: func -> String {
        buffer := Buffer new()
        first := true
        while(!checkBunch(buffer toString()) || first) {
            line := Readline readLine(first ? "ooc > " : "      ")
            if(!line isEmpty()) Readline addHistory(line)
            buffer append(line). append('\n')
            free(line)

            first = false
        }
        buffer toString()
    }

    run: func {
        while(true) {
            bunch := readBunch()
            if(bunch startsWith('#')) {
                cmd := bunch substring(1)

                match cmd {
                    case "clear" => clear()
                    case "exit"  => exit(0)
                    case         => "Unknown command: %s" format(cmd) println()
                }
            } else {
                append(bunch)
                compile()
            }
        }
    }
}
