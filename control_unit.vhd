-------------------------------------------------------------------------------
---- Project  : Image Processing RGB median filter
-------------------------------------------------------------------------------
-- File       : control_unit.vhd
-- Author     : Ziv
-- Created    : 04-01-2021
-- Last update: 05-01-2021
-- Platform   : 
-- Standard   : VHDL'93
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.project_package.all;

entity CONTROL_UNIT is
	port (
		  start			: in  std_logic;
		  clk			: in  std_logic;
		  rst			: in  std_logic;
		  read_address  : out std_logic_vector(log2(picture_h)-1 downto 0);
		  write_address : out std_logic_vector(log2(picture_h)-1 downto 0);
		  write_ena     : out std_logic;
		  push   		: out std_logic;
		  done   		: out std_logic
	    );
end entity CONTROL_UNIT;

architecture CONTROL_UNIT of CONTROL_UNIT is
	signal read_address_sig, write_address_sig : std_logic_vector(read_address'range);
	signal write_ena_d1, write_ena_d2, write_ena_d3 : std_logic;
	
	signal read_ena, write_ena_sig : std_logic;
	signal push_d1, push_sig: std_logic;
begin
	
	w_addr_counter: entity work.counter_ena
	port map (
			  clk   => clk,
			  rst   => rst,
			  ena   => write_ena_d3,
			  count => write_address_sig
			);
	
	r_addr_counter: entity work.counter_ena
	port map (
			  clk   => clk,
			  rst   => rst,
			  ena   => read_ena,
			  count => read_address_sig
			);
	
	fsm_unit: entity work.FSM
	port map (
			  start         => start,
			  clk           => clk,
			  rst           => rst,
			  read_address  => read_address_sig,
			  write_address => write_address_sig,
			  read_ena      => read_ena,
			  write_ena     => write_ena_sig,
			  push          => push_d1,
			  done          => done
			);
					
	write_address <= write_address_sig;
	read_address  <= read_address_sig;
	write_ena     <= write_ena_d1;
	push <= push_sig;
	sync: process(clk, rst)
	begin
		if (rst = '1') then
			write_ena_d1  <= '0';
			write_ena_d2  <= '0';
			write_ena_d3  <= '0';
			push_sig      <= '0';
		elsif  rising_edge(clk) then
			push_sig    <= push_d1;
			write_ena_d1 <= write_ena_sig;
			write_ena_d2 <= write_ena_d1;
			write_ena_d3 <= write_ena_d2;
		end if;
	end process sync;
end architecture CONTROL_UNIT;