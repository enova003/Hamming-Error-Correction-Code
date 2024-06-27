-- INSTRUCTIONS:
--
-- 1. Open a new waveform, initialize the simulation with this 
--    testbench data, and click the green 'run' button.
--
-- 2. An input box will appear, please read the message
--    that is displayed on the console at the bottom of the screen. 
--    You MUST enter the number 12 or 8 into the first input box. 
--
-- 3. A second input box will appear, enter a 12-bit word if you entered
--	  '12' into the first input box; enter a 8-bit word if you 
--	  entered '8' into the first input box.
--
-- 4. View your results both on the waveform and the console. 
--
-- 5. Restart the simulation to test another value.


library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;  
library std;
use std.textio.all;	 

entity hamming_code_tb is
end hamming_code_tb;

architecture TB_ARCHITECTURE of hamming_code_tb is
	component hamming_code
		port(
			data_in_8 : in STD_LOGIC_VECTOR(8 downto 1);
			data_in_12 : in STD_LOGIC_VECTOR(12 downto 1)
			);
	end component;
	
	signal data_in_8_tb : STD_LOGIC_VECTOR(8 downto 1);
	signal data_in_12_tb : STD_LOGIC_VECTOR(12 downto 1);
	
begin 
	-- Unit Under Test port map
	UUT : hamming_code
	port map (
		data_in_8 => data_in_8_tb,
		data_in_12 => data_in_12_tb
		);
	
	--	stimulus_8bit_words: process -- Stimulus test for all 256 8-bit words
	--	begin	
	--		for i in 0 to 255 loop
	--			data_in_8_tb <= std_logic_vector(to_unsigned(i, 8));
	--			wait for 10 ns; 
	--		end loop;
	--		wait;
	--	end process stimulus_8bit_words;
	--	
	--	stimulus_12bit_words: process -- Stimulus to test a random set of 256 12-bit words 
	--	begin	 
	--		for i in 3100 to 3355 loop	
	--			data_in_12_tb <= std_logic_vector(to_unsigned(i, 12)); 	
	--			wait for 10 ns;
	--		end loop;
	--		wait;
	--	end process stimulus_12bit_words;
	
	-- USED TO TEST INDIVIDUAL VALUES
	--	data_in_8_tb <= "10011010";
	--	data_in_12_tb <= "011100101010";
	--	data_in_12_tb <= "011100101110";
	--	data_in_12_tb <= "110011010110"; 
	
	
	--Process to prompt a user to enter a 12-bit or 8-bit word
	process
		variable twelve_or_eight : line;
		variable input_line : line;
	begin	 
		write(output, string'("Would you like to enter a 12-bit word or a 8-bit word? (Enter '12' or '8' in the input box)"));
		readline(input, twelve_or_eight);
		
		if(twelve_or_eight(1) = '1' and twelve_or_eight(2) = '2') then				
			write(output, string'("Enter a 12-bit data word in the input box"));
			readline(input, input_line);
			
			for i in data_in_12_tb'range loop
				case input_line(data_in_12_tb'high - i + 1) is
					when '0' => data_in_12_tb(i) <= '0';
					when '1' => data_in_12_tb(i) <= '1';
					when others => report "Invalid character" severity ERROR;
				end case;
			end loop;  	
			wait; 
		end if;											
		
		if(twelve_or_eight(1) = '8') then
			write(output, string'("Enter a 8-bit data word in the input box"));
			readline(input, input_line);
			
			for i in data_in_8_tb'range loop
				case input_line(data_in_8_tb'high - i + 1) is
					when '0' => data_in_8_tb(i) <= '0';
					when '1' => data_in_8_tb(i) <= '1';
					when others => report "Invalid character" severity ERROR;
				end case;
			end loop;
			wait; 
		end if;
	end process;
	
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_hamming_code of hamming_code_tb is
	for TB_ARCHITECTURE
		for UUT : hamming_code
			use entity work.hamming_code(behavioral);
		end for;
	end for;
end TESTBENCH_FOR_hamming_code;

