# Hamming ECC 

## Functionalities of the Program
- The program accepts either an 8-bit or 12-bit binary word as input.
    - If an 8-bit binary word is used as input:
         - The program calculates the parity bits of the provided 8-bit word.
         - The program combines the parity bits with the 8-bit word to produce and output a 12-bit word.  
    - If an 12-bit binary word is used as input:
         - The program extracts the parity bits from the 12-bit word.
         - The program finds the position of the incorrect bit in the 12-bit word and corrects the error.

## Executing the Program
1. Download the provided code in this repository. 
2. Open your preferred IDE used to run VHDL programs
3. Compile the .vhd files in your IDE.
4. Open a new waveform, initialize the simulation with the
   testbench data, and run the code.
5. An input box will appear, please read the message
    that is displayed on the console at the bottom of the screen. 
    You MUST enter the number 12 or 8 into the first input box. 
6. A second input box will appear, enter a 12-bit word if you entered
    '12' into the first input box; enter a 8-bit word if you 
	  entered '8' into the first input box.
7. View your results both on the waveform and the console. 
8. Restart the simulation to test another value.

## Sample Output
