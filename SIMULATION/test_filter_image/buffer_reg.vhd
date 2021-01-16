-------------------------------------------------------------------------------
---- Project  : Image Processing RGB median filter
-------------------------------------------------------------------------------
-- File       : buffer_reg.vhd
-- Author     : Ziv
-- Created    : 30-12-2020
-- Last update: 31-12-2020
-- Platform   : 
-- Standard   : VHDL'93
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.project_package.all;

entity buffer_reg is

 port (
		-- inputs
		new_row : in  PIXEL(picture_w-1 downto 0);
		ena     : in  std_logic;
		clk     : in  std_logic;
		rst     : in  std_logic;
		-- outputs
		prev_row  : out PIXEL(picture_w+1 downto 0);
		curr_row  : out PIXEL(picture_w+1 downto 0);
		next_row  : out PIXEL(picture_w+1 downto 0)
	   );
end entity buffer_reg;

architecture buffer_reg of buffer_reg is
	signal prev_row_s, curr_row_s, next_row_s : PIXEL(curr_row'range);
begin
	prev_row <= prev_row_s;
	curr_row <= curr_row_s;
	next_row <= next_row_s;
	
	sync: process (clk, rst) is
	begin
		if (rst = '1') then
			prev_row_s <= (others =>(r => (others => '0'),
									 g => (others => '0'),
									 b => (others => '0')));
			curr_row_s <= (others =>(r => (others => '0'),
									 g => (others => '0'),
									 b => (others => '0')));
			next_row_s <= (others =>(r => (others => '0'),
									 g => (others => '0'),
									 b => (others => '0')));
		elsif rising_edge(clk) then
			if (ena = '1') then
				prev_row_s <= curr_row_s;
				curr_row_s <= next_row_s;
				next_row_s <= new_row(picture_w-1) & new_row & new_row(0);
			end if;
		end if;
	end process sync;
end architecture buffer_reg;	