# Toy Robot
This is a Ruby implementation of Toy Robot game.

UPDATE 26/10/21: added a [new](https://github.com/fedeth/toy-robot/tree/feature/add-new-table-validator) validator based on ASCII (TableMap)

## Usage
```bash
$ ruby examples/sample_with_file.rb
```
or

```bash
$ ruby examples/sample_with_stdin.rb
```

## Design and considerations
 ![Game design picture](https://i.ibb.co/BP01g6S/Screenshot-from-2021-10-25-12-21-04.png)
 There are 3 main entities that cooperate together to run this game.

### Command reader
Command reader classes are responsible to provide commands to the game. I have implemented 2 types:
- StandardInputReader, which reads commands from the stdin.
- FileReader, which reads commands from a file

It is also possible to add others readers with a minimal effort( see EmailReader class)

### Tabletop
Tabletops are responsible to check if a specific move is allowed or not on the board. In its basic implementation, it checks only if a move is executed within the field boundaries, but it is possible to increase the logical complexity by adding more strict constraints

### Robot
A Robot contains the set of allowed instructions and it is initialized with a specific tabletop in which it can move.
The Robot has an internal state that contains the coordinates and the orientation of the robot at any single time.

## Flow
- A new game is initialized with a reader, a tabletop and a Robot class.
- The game instantiates a new robot, and ask the command reader for the next instruction. (A)
- The robot checks if it can execute the instruction and eventually ask tabletop if the new position is allowed.(B)
- Tabletop replies with a boolean answer. (C) 
- The robot asks the internal state to read/update the internal state. (D)
