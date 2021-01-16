-------------------------------------------------------------------------------
---- Project  : Image Processing RGB median filter
-------------------------------------------------------------------------------
-- File       : func_tb.vhd
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

entity func_tb is
end entity func_tb;

architecture func_tb of func_tb is

signal rom_in, ram_out : mem_vec (2 downto 0) := (others => (others => '0'));
signal system_row      : PIXEL (picture_w-1 downto 0);

--control
signal correct : boolean;
signal log_out : integer := 0;
begin
	
	-- pic H and W is 8pix for this test needs to be TRUE 20-30ns and 50ns<
	correct <= (rom_in = ram_out) and (log_out = 3);
	p1: process is
	begin
		-- TESTING LOG2
		log_out    <= log2(picture_h);
		
		-- TESTING CONVERSION FUNCTIONS
		--R
		rom_in(2) <= conv_std_logic_vector(100000000, picture_w*color_d);
		--G
		rom_in(1) <= conv_std_logic_vector(200000000, picture_w*color_d);
		--B
		rom_in(0) <= conv_std_logic_vector(300000000, picture_w*color_d);
		wait for 10 ns;
		system_row <= mem_vec2PIXEL(rom_in);
		wait for 10 ns;
		ram_out    <= PIXEL2mem_vec(system_row);
		wait for 10 ns;
		--R
		rom_in(2) <= (others => '1');
		--G
		rom_in(1) <= x"EE" & rom_in(1)(picture_w*color_d-9 downto 0);
		--B
		rom_in(0) <= x"DD" & rom_in(0)(picture_w*color_d-9 downto 0);
		wait for 10 ns;
		system_row <= mem_vec2PIXEL(rom_in);
		wait for 10 ns;
		ram_out    <= PIXEL2mem_vec(system_row);
		
		
		wait;
	end process p1;
end architecture func_tb;