-------------------------------------------------------------------------------
---- Project  : Image Processing RGB median filter
-------------------------------------------------------------------------------
-- File       : logic_unit.vhd
-- Author     : Ziv
-- Created    : 30-12-2020
-- Last update: 06-01-2021
-- Platform   : 
-- Standard   : VHDL'93
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.project_package.all;

entity logic_unit is
	port (
		  rom_out       : in  mem_vec(2 downto 0);
		  push			: in  std_logic;
		  clk			: in  std_logic;
		  rst			: in  std_logic;
		  ram_in        : out mem_vec(2 downto 0)
	    );
end entity logic_unit;

architecture logic_unit of logic_unit is
	signal new_row, filtered_row        : PIXEL(picture_w-1 downto 0);
	signal prev_row, curr_row, next_row : PIXEL(picture_w+1 downto 0);
	
begin
	buffer_row :entity work.buffer_reg
	port map (
			  new_row  => new_row,
			  ena      => push,
			  clk      => clk,
			  rst      => rst,
			  prev_row => prev_row,
			  curr_row => curr_row,
			  next_row => next_row
			);
	
	median: entity work.median_filter
	port map (
			  prev_row     => prev_row,
			  curr_row     => curr_row,
			  next_row     => next_row,
			  filtered_row => filtered_row
			);
	
	p1: process (rom_out) is
	begin
		new_row <= mem_vec2PIXEL(rom_out);
	end process p1;
	
	p2: process (filtered_row) is
	begin
		ram_in <= PIXEL2mem_vec(filtered_row);
	end process p2;
end architecture logic_unit;