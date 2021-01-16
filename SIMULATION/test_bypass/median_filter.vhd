-------------------------------------------------------------------------------
---- Project  : Image Processing RGB median filter
-------------------------------------------------------------------------------
-- File       : median_filter.vhd
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

entity median_filter is

 port (
		-- inputs
		prev_row     : in  PIXEL(picture_w+1 downto 0);
		curr_row     : in  PIXEL(picture_w+1 downto 0);
		next_row     : in  PIXEL(picture_w+1 downto 0);
		-- output
		filtered_row : out PIXEL(picture_w-1 downto 0)
	   );
end entity median_filter;

architecture median_filter of median_filter is
	function c_median (i0, i1, i2 : bit_vector(color_d-1 downto 0)) return bit_vector is
		variable c_median : bit_vector(color_d-1 downto 0);
	begin
		if    (i2 >= i1 and i2 <= i0) then
            c_median:= i2;
        elsif (i2 >= i0 and i2 <= i1) then
            c_median:= i2;
        elsif (i1 >= i0 and i1 <= i2) then
            c_median:= i1;
        elsif (i1 >= i2 and i1 <= i0) then
            c_median:= i1;
        elsif (i0 >= i1 and i0 <= i2) then
            c_median:= i0;
        elsif (i0 >= i2 and i0 <= i1) then
            c_median:= i0;
        else
			c_median:= i0;
        end if;
		return c_median;
	end function c_median;
	
	function median3x1 (row : PIXEL(2 downto 0)) return PIXELi is
		variable median : PIXELi;
	begin
		median.r := c_median(row(2).r, row(1).r, row(0).r);
		median.g := c_median(row(2).g, row(1).g, row(0).g);
		median.b := c_median(row(2).b, row(1).b, row(0).b);
		return median;
	end function median3x1;
	
	function median3x3 (row1, row2, row3 : PIXEL(2 downto 0)) return PIXELi is
		variable median_row: PIXEL(2 downto 0);
	begin
		median_row(0) := median3x1(row1);
		median_row(1) := median3x1(row2);
		median_row(2) := median3x1(row3);
		return median3x1(median_row);
	end function median3x3;

begin
	pixel_loop: for index in picture_w downto 1 generate
		filtered_row(index-1) <= median3x3(prev_row(index+1 downto index-1), curr_row(index+1 downto index-1), next_row(index+1 downto index-1));
	end generate pixel_loop;

end architecture median_filter;	