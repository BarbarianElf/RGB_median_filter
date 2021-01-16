-------------------------------------------------------------------------------
---- Project  : Image Processing RGB median filter
-------------------------------------------------------------------------------
-- File       : buffer_reg_tb.vhd
-- Author     : Ziv
-- Created    : 31-12-2020
-- Last update: 31-12-2020
-- Platform   : 
-- Standard   : VHDL'93
-------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.project_package.all;

entity buffer_reg_tb is
generic(clock_period : time := 40 ns);
end entity buffer_reg_tb;

architecture buffer_reg_tb of buffer_reg_tb is

-- sync
signal clk  : std_logic := '0';
signal rst  : std_logic := '1';
signal ena  : std_logic := '0';
-- inputs
signal new_row     : PIXEL(picture_w-1 downto 0);
-- test
signal old_new_row  : PIXEL(picture_w+1 downto 0);
signal old_next_row : PIXEL(picture_w+1 downto 0);
signal old_curr_row : PIXEL(picture_w+1 downto 0);
signal correct      : boolean := false;
-- outputs
signal prev_row  : PIXEL(picture_w+1 downto 0);
signal curr_row  : PIXEL(picture_w+1 downto 0);
signal next_row  : PIXEL(picture_w+1 downto 0);


begin
	t1: entity work.buffer_reg
		port map (
				  new_row  => new_row,
				  ena      => ena,
				  clk      => clk,
				  rst      => rst,
				  prev_row => prev_row,
				  curr_row => curr_row,
				  next_row => next_row
				);
	clk     <= not clk after clock_period / 2;
	rst     <= '0' after 10 ns;
	correct <= (old_new_row = next_row) and (old_next_row = curr_row) and (old_curr_row = prev_row) and (ena = '1');
	
	p1: process is
		begin
			-- waiting in input to ena
			l1: for i in new_row'range loop
				new_row(i).r <= to_bitvector(conv_std_logic_vector(1, color_d));
				new_row(i).g <= to_bitvector(conv_std_logic_vector(1, color_d));
				new_row(i).b <= to_bitvector(conv_std_logic_vector(1, color_d));
			end loop l1;
			wait until falling_edge(rst);
			wait until rising_edge(clk);
			ena <= '1';
			old_new_row  <= new_row(picture_w-1) & new_row & new_row(0);
			old_next_row <= next_row;
			old_curr_row <= curr_row;
			wait until rising_edge(clk);
			-- loop to insert all combination
			ltotal: for n in 2 to 2**5-1 loop
				l2:for i in new_row'range loop
					new_row(i).r <= to_bitvector(conv_std_logic_vector(n, color_d));
					new_row(i).g <= to_bitvector(conv_std_logic_vector(n, color_d));
					new_row(i).b <= to_bitvector(conv_std_logic_vector(n, color_d));
				end loop l2;
				old_new_row  <= new_row(picture_w-1) & new_row & new_row(0);
				old_next_row <= next_row;
				old_curr_row <= curr_row;
				wait until rising_edge(clk);
			end loop ltotal;
			-- last insertion for test
			for i in 0 to 3 loop
				old_new_row  <= new_row(picture_w-1) & new_row & new_row(0);
				old_next_row <= next_row;
				old_curr_row <= curr_row;
				wait until rising_edge(clk);
			end loop;
			wait;
		-- run for 1360ns
	end process p1;
end architecture buffer_reg_tb;	