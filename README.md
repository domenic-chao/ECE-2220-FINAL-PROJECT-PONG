# PONG

Here is our version of Pong created using Verilog for our ECE 2220 Digital Logic Class.

Our version of pong has many similar aspects to the orginal game such as
  1) Scoring
  2) Two Player Mode
  3) Menus

## File Info
Pong - the top entry file, that has all of the pin outs for the project
Ball_Logic - the logic file that control the movemenet of objects and scoring
VGA_Output - the output file that control what the user sees on screen
  Char_to_Vga - Converts the character A-Z, 0-9, space, ":" to pixel arrays to be displayed on the VGA_output
Num_to_sev_seg - the output file that control what the user sees on the seven segment displays for score
