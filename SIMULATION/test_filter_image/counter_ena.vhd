-------------------------------------------------------------------------------
---- Project  : Image Processing RGB median filter
-------------------------------------------------------------------------------
-- File       : counter_ena.vhd
-- Author     : Ziv
-- Created    : 04-01-2021
-- Last update: 04-01-2021
-- Platform   : 
-- Standard   : VHDL'93
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.project_package.all;

entity counter_ena is
	port (
		  clk			: in  std_logic;
		  rst			: in  std_logic;
		  ena           : in  std_logic;
		  count         : out std_logic_vector(log2(picture_h)-1 downto 0)
	    );
end entity counter_ena;

architecture counter_ena of counter_ena is

	signal count_sig : std_logic_vector(count'range);
	
begin
	
	count <= count_sig;
	
	sync: process(clk, rst)
	begin
		if (rst = '1') then
			count_sig <= (others => '0');
		elsif  rising_edge(clk) then
			if (ena = '1') then
				count_sig <= count_sig + 1;
			end if;
		end if;
	end process sync;
end architecture counter_ena;