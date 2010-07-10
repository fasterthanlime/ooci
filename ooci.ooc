/* Let me present you: the ooc repl for poor people with much time - torfppwmt (tm) */

use readline
import readline

import io/[File, FileReader,FileWriter]
import os/Process
import structs/ArrayList
import text/Buffer

checkBunch: func (bunch: String) -> Bool {
    (bunch count('(') == bunch count(')')) && (bunch count('{') == bunch count('}'))
}

REPL new() run()

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
        writer write(text) .write('\n')
        writer close()
    }

    compile: func {
        args := ["rock", "-v", "-tcc", "-r", "repl.ooc"] as ArrayList<String>
        proc := Process new(args)
        proc setCwd("/tmp")
        //proc execute()
        proc getOutput() println()
    }

    readBunch: func -> String {
        buffer := Buffer new()
        first := true
        while(!checkBunch(buffer toString()) || first) {
            line := Readline readLine(first ? ">> " : "   ")
            if(!line isEmpty()) Readline addHistory(line)
            buffer append(line)
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
                if(cmd == "clear") {
                    clear()
                } else {
                    "Unknown command: %s" format(cmd) println()
                }
            } else {
                append(bunch)
                compile()
            }
        }
    }
}
