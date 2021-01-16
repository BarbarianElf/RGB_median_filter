-------------------------------------------------------------------------------
---- Project  : Image Processing RGB median filter
-------------------------------------------------------------------------------
-- File       : fsm.vhd
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

entity FSM is
	port (
		  start			: in  std_logic;
		  clk			: in  std_logic;
		  rst			: in  std_logic;
		  read_address  : in  std_logic_vector(log2(picture_h)-1 downto 0);
		  write_address : in  std_logic_vector(log2(picture_h)-1 downto 0);
		  read_ena      : out std_logic;
		  write_ena		: out std_logic;
		  push   		: out std_logic;
		  done   		: out std_logic
	    );
end entity FSM;

architecture FSM of FSM is
	type state is (S0, S1, S2, S3, S4);
	signal current_state : state;
	
begin

	
	unsync: process(current_state)
	begin
		case current_state is
			-- FIRST PUSH STATE
			when S1 =>
				read_ena      <= '1';
				write_ena     <= '0';
				push   		  <= '1';
				done          <= '0';
			-- PUSH STATE
			when S2 =>
				read_ena      <= '1';
				write_ena     <= '1';
				push   		  <= '1';
				done          <= '0';
			-- LAST PUSH STATE
			when S3 =>
				read_ena      <= '0';
				write_ena     <= '1';
				push   		  <= '1';
				done          <= '0';
			-- DONE STATE
			when S4 =>
				read_ena      <= '0';
				write_ena     <= '0';
				push   		  <= '0';
				done          <= '1';
			-- BEFORE START STATE
			when others =>
				read_ena      <= '0';
				write_ena     <= '0';
				push   		  <= '0';
				done          <= '0';
		end case;
	end process unsync;
	
	sync: process(clk, rst)
	begin
		if (rst = '1') then
			current_state <= S0;
		elsif  rising_edge(clk) then
			case current_state is
				when S1 =>
					current_state <= S2;
				when S2 =>
					if (read_address = picture_h-2) then
						current_state <= S3;
					end if;
				when S3 =>
					if (write_address = picture_h-2) then
						current_state <= S4;
					end if;
				when S4 =>
					current_state <= S4;
				when others =>
					if (start = '1') then
						current_state <= S1;
					end if;
			end case;
		end if;
	end process sync;
end architecture FSM;