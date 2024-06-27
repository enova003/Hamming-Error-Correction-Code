--What this program does:
--1. The program accepts a 8-bit word.  
--2. The program calculates the parity bits of the provided 8-bit word.
--3. Once the parity bits are calculated, the program combines the parity bits with the 8-bit word to produce and output a 12-bit word.  
--4. The program can also accept a 12-bit word.
--5. The program extracts the parity bits from the 12-bit word.
--6. Using the parity bits, the program finds the position of the incorrect bit in the 12-bit word and corrects the error.

library ieee;
use ieee.std_logic_1164.all; 
use ieee.NUMERIC_STD.all;	  
library std;
use std.textio.all;	

entity hamming_code is
	port (
		data_in_8 : in std_logic_vector(8 downto 1);
		data_in_12 : in std_logic_vector(12 downto 1)
		);
end hamming_code;

architecture Behavioral of hamming_code is
	signal parity_8bits : std_logic_vector(4 downto 1);
	signal parity_and_8bit : std_logic_vector(12 downto 1);
	signal parity_12bits : std_logic_vector(4 downto 1);
	signal corrected_12bit : std_logic_vector(12 downto 1);
	signal error_detected : integer := 0;
	signal error_position : integer := 0;
	signal bit_to_flip : integer := 0;
	
	function calculate_parity_8bit (data : std_logic_vector(8 downto 1); bit_position : integer) return std_logic is 
	begin																																																																																			
		case bit_position is
			when 8 => return data(8) xor data(7) xor data(5) xor data(4) xor data(2); 
			when 4 => return data(8) xor data(6) xor data(5) xor data(3) xor data(2); 
			when 2 => return data(7) xor data(6) xor data(5) xor data(1);	          
			when 1 => return data(4) xor data(3) xor data(2) xor data(1);			
			when others => return 'X'; -- For invalid positions	 
		end case;
	end function calculate_parity_8bit;	 
	
	function calculate_parity_12bit (data : std_logic_vector(12 downto 1); bit_position : integer) return std_logic is 
	begin
		case bit_position is
			when 8 => return data(10) xor data(8) xor data(6) xor data(4) xor data(2); 
			when 4 => return data(10) xor data(7) xor data(6) xor data(3) xor data(2); 
			when 2 => return data(8) xor data(7) xor data(6) xor data(1);	          
			when 1 => return data(4) xor data(3) xor data(2) xor data(1);			   
			when others => return 'X'; -- For invalid positions
		end case;
	end function calculate_parity_12bit; 
	
	--Function to convert a vector to a string (Used to output data to the console)
	function to_string(input_vector: std_logic_vector) return string is
		variable result_string: string(1 to input_vector'length);
	begin
		for i in input_vector'range loop
			if input_vector(i) = '1' then 
				result_string(input_vector'length - i + 1) := '1';
			elsif input_vector(i) = '0' then 
				result_string(input_vector'length - i + 1) := '0';
			end if;
		end loop;
		return result_string;
	end function to_string;
	
begin
	
	-- Calculate parity bits of 8-bit word
	parity_8bits <= calculate_parity_8bit(data_in_8, 8) & 
	calculate_parity_8bit(data_in_8, 4) &				  
	calculate_parity_8bit(data_in_8, 2) &				  
	calculate_parity_8bit(data_in_8, 1); 
	
	-- Output parity bits combined with 8-bit word
	parity_and_8bit(12) <= parity_8bits(4);  
	parity_and_8bit(11) <= parity_8bits(3); 
	parity_and_8bit(10) <= data_in_8(8); 
	parity_and_8bit(9) <= parity_8bits(2);	 
	parity_and_8bit(8) <= data_in_8(7); 
	parity_and_8bit(7) <= data_in_8(6);
	parity_and_8bit(6) <= data_in_8(5);
	parity_and_8bit(5) <= parity_8bits(1);	  
	parity_and_8bit(4) <= data_in_8(4); 
	parity_and_8bit(3) <= data_in_8(3);	  
	parity_and_8bit(2) <= data_in_8(2); 
	parity_and_8bit(1) <= data_in_8(1); 
	
	-- Extract parity bits of 12-bit word
	parity_12bits <= calculate_parity_12bit(data_in_12, 8) &
	calculate_parity_12bit(data_in_12, 4) &
	calculate_parity_12bit(data_in_12, 2) &
	calculate_parity_12bit(data_in_12, 1); 
	
	-- Process to check for error
	process(parity_12bits, data_in_12) 
		variable error_pos : integer;
		variable flip_this_bit : integer;
		variable detected_error : integer; 
	begin	
		-- Initialize signals to zero
		error_pos := 0;
		flip_this_bit := 0;
		detected_error := 0;
		corrected_12bit <= (others => '0');
		
		if parity_12bits /= "0000" then
			
			--Used to calculate the position of the bit with the error
			if parity_12bits(4) /= data_in_12(12) then 
				error_pos := error_pos + 1;
			end if;	  
			
			if parity_12bits(3) /= data_in_12(11) then 
				error_pos := error_pos + 2;
			end if;
			
			if parity_12bits(2) /= data_in_12(9) then 
				error_pos := error_pos + 4;
			end if;
			
			if parity_12bits(1) /= data_in_12(5) then 
				error_pos := error_pos + 8;
			end if;
			
			if error_pos /= 0 then
				detected_error := 1;
			end if;	
			
			-- Vectors are reversed in VHDL; bit 1 is actually bit 12, bit 2 is actually bit 11, bit 3 is actually bit 10, etc., so I need to reverse the error_pos bit
			flip_this_bit := 13 - error_pos;
			
			-- Correct error if detected (flip the bit)
			if flip_this_bit > 0 and flip_this_bit < 13 then 
				
				-- Flip the bit at the error position
				corrected_12bit <= data_in_12;
				corrected_12bit(flip_this_bit) <= not corrected_12bit(flip_this_bit); 
				
			else
				corrected_12bit <= data_in_12; -- No error, output original word
				
				-- Reset the signals
				detected_error := 0;
				error_pos := 0;
				flip_this_bit := 0;
				
			end if;
			-- Update signals for waveform
			error_detected <= detected_error;
			error_position <= error_pos;
			bit_to_flip <= flip_this_bit;
			
		else
			corrected_12bit <= data_in_12; -- No error, output original word
		end if;			
	end process;
	
	-- Output data to the console
	process(data_in_8, data_in_12, parity_8bits, parity_and_8bit, parity_12bits, error_detected, corrected_12bit)
	begin 	
		write(output, string'(" "));
		write(output, string'("------INFO FOR 8-BIT WORD------"));
		write(output, string'("Your 8-bit word: " & to_string(data_in_8)));
		write(output, string'("The calculated parity bits are: " & to_string(parity_8bits)));
		write(output, string'("Your 8-bit word combined with the parity bits: " & to_string(parity_and_8bit)));
		write(output, string'(" "));
		
		write(output, string'(" "));
		write(output, string'("------INFO FOR 12-BIT WORD------"));
		write(output, string'("Your 12-bit word: " & to_string(data_in_12)));
		write(output, string'("The calculated parity bits are: " & to_string(parity_12bits)));	
		write(output, string'("Error detected ('1' for yes; '0' for no): " & integer'image(error_detected)));
		write(output, string'("Corrected word (if an error is NOT detected, the original word will be output): " & to_string(corrected_12bit)));	
		write(output, string'(" "));
	end process;
	
end Behavioral;
