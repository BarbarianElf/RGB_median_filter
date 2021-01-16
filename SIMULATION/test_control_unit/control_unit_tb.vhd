-------------------------------------------------------------------------------
---- Project  : Image Processing RGB median filter
-------------------------------------------------------------------------------
-- File       : control_unit_tb.vhd
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

entity CONTROL_UNIT_tb is
generic(clock_period : time := 40 ns);
end entity CONTROL_UNIT_tb;

architecture CONTROL_UNIT_tb of CONTROL_UNIT_tb is

--input signals
signal start: std_logic;
--output signals
signal write_address, read_address : std_logic_vector(log2(picture_h)-1 downto 0);
signal write_ena, push, done       : std_logic;
--sync signals
signal clk: std_logic := '0';
signal rst: std_logic := '1';
--test
signal correct_addr : boolean := false;
signal b            : integer := 0;

begin
	t1: entity work.CONTROL_UNIT
	port map (
			  start         => start,
			  clk           => clk,
			  rst           => rst,
			  read_address  => read_address,
			  write_address => write_address,
			  write_ena     => write_ena,
			  push          => push,
			  done          => done
			);
	
	clk          <= not clk after clock_period / 2;
	rst          <= '0' after 10 ns;
	--currect address for main process state
	correct_addr <= (read_address = (b + write_address));
	p1: process is
	begin
		wait until falling_edge(rst);
		wait until rising_edge(clk);
		start <= '1';
		wait until rising_edge(clk);
		start <= '0';
		wait until rising_edge(clk);
		while (read_address < 4) loop
			b <= b + 1;
			wait until rising_edge(clk);
		end loop;
		wait for 10040 ns;
		while (b > -3) loop
			b <= b - 1;
			wait until rising_edge(clk);
		end loop;
		wait until rising_edge(clk);
		wait;
	end process p1;
end architecture CONTROL_UNIT_tb;