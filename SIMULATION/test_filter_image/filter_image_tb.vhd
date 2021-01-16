-------------------------------------------------------------------------------
---- Project  : Image Processing RGB median filter
-------------------------------------------------------------------------------
-- File       : filter_image_tb.vhd
-- Author     : Ziv
-- Created    : 05-01-2021
-- Last update: 06-01-2021
-- Platform   : 
-- Standard   : VHDL'93
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.project_package.all;

entity filter_image_tb is
generic(clock_period : time := 20 ns);
end entity filter_image_tb;

architecture filter_image_tb of filter_image_tb is

--input signals
signal start: std_logic;
--output signals
signal done : std_logic;
--sync signals
signal clk: std_logic := '0';
signal rst: std_logic := '1';
		  
begin
	t1: entity work.filter_image
	port map (
			  start         => start,
			  clk           => clk,
			  rst           => rst,
			  done          => done
			);
	
	clk <= not clk after clock_period / 2;
	rst <= '0' after 10 ns;
	
	p1: process is
	begin
		wait until falling_edge(rst);
		wait until rising_edge(clk);
		start <= '1';
		wait until rising_edge(clk);
		start <= '0';
		wait for 3000 ns;
		wait;
	end process p1;
end architecture filter_image_tb;