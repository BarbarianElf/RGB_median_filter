-------------------------------------------------------------------------------
---- Project  : Image Processing RGB median filter
-------------------------------------------------------------------------------
-- File       : median_filter_tb.vhd
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

entity median_filter_tb is
end entity median_filter_tb;

architecture median_filter_tb of median_filter_tb is

-- inputs
signal prev_row  : PIXEL(picture_w+1 downto 0);
signal curr_row  : PIXEL(picture_w+1 downto 0);
signal next_row  : PIXEL(picture_w+1 downto 0);
-- outputs
signal filtered_row   : PIXEL(picture_w-1 downto 0);
-- test
signal correct : boolean;
begin
	--tested with picture W and H of 5pix
	correct <= (filtered_row = curr_row(picture_w downto 1));
	
	t1: entity work.median_filter
		port map (
				  prev_row     => prev_row,
				  curr_row     => curr_row,
				  next_row     => next_row,
				  filtered_row => filtered_row
				);
	p1: process is
		begin
			l4: for j in 1 to 2 loop
				l1: for i in prev_row'range loop
					prev_row(i).r <= to_bitvector(conv_std_logic_vector(j*i*2, color_d));
					prev_row(i).g <= to_bitvector(conv_std_logic_vector(j*i*2, color_d));
					prev_row(i).b <= to_bitvector(conv_std_logic_vector(j*i*2, color_d));
				end loop l1;
				l2: for i in curr_row'range loop
					curr_row(i).r <= to_bitvector(conv_std_logic_vector(j*i*2, color_d));
					curr_row(i).g <= to_bitvector(conv_std_logic_vector(j*i*2, color_d));
					curr_row(i).b <= to_bitvector(conv_std_logic_vector(j*i*2, color_d));
				end loop l2;
				l3: for i in next_row'range loop
					next_row(i).r <= to_bitvector(conv_std_logic_vector(j*i*2, color_d));
					next_row(i).g <= to_bitvector(conv_std_logic_vector(j*i*2, color_d));
					next_row(i).b <= to_bitvector(conv_std_logic_vector(j*i*2, color_d));
				end loop l3;
				wait for 10 ns;
			end loop l4;
			wait;
		end process p1;
end architecture median_filter_tb;	