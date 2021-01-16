-------------------------------------------------------------------------------
---- Project  : Image Processing RGB median filter
-------------------------------------------------------------------------------
-- File       : project_package.vhd
-- Author     : Ziv
-- Created    : 30-12-2020
-- Last update: 06-01-2021
-- Platform   : 
-- Standard   : VHDL'93
-------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

package project_package is
	constant picture_w : natural := 8; -- WIDTH
	constant picture_h : natural := 8; -- HIEGHT
	constant picture_d : natural := 3;   -- RGB
	constant color_d   : natural := 5;
	
	constant mif_str_format: string := "x.mif";
	type     mif_str_arr is array (2 downto 0) of string(mif_str_format'range);
	constant mem_arr : mif_str_arr := ("r.mif", "g.mif", "b.mif");
   
	constant ram_str_format: string := "XRAM";
	type     ram_str_arr is array (2 downto 0) of string(ram_str_format'range);
	constant inst_arr : ram_str_arr := ("RRAM", "GRAM", "BRAM");
   
	type PIXELi is record
		R : bit_vector(color_d-1 downto 0);
		G : bit_vector(color_d-1 downto 0);
		B : bit_vector(color_d-1 downto 0);
	end record PIXELi;
	
	type PIXEL   is array (natural range <>) of PIXELi;
	type mem_vec is array (natural range <>) of std_logic_vector((picture_w*color_d)-1 downto 0);
	
	function log2(pow: integer)             return integer;
	function mem_vec2PIXEL(vector: mem_vec) return PIXEL;
	function PIXEL2mem_vec(pix: PIXEL)      return mem_vec;
	
end package project_package;

package body project_package is
	
	function mem_vec2PIXEL(vector: mem_vec) return PIXEL is
		variable temp : PIXEL(picture_w-1 downto 0);
		alias red_vector   is vector(2);
		alias green_vector is vector(1);
		alias blue_vector  is vector(0);
	begin
		for index in temp'reverse_range loop
			temp(index).r := to_bitvector(red_vector((index * color_d) + color_d-1 downto index * color_d));
			temp(index).g := to_bitvector(green_vector((index * color_d) + color_d-1 downto index * color_d));
			temp(index).b := to_bitvector(blue_vector((index * color_d) + color_d-1 downto index * color_d));
		end loop;
		return temp;
	end function mem_vec2PIXEL;
	
	function PIXEL2mem_vec(pix: PIXEL) return mem_vec is
		variable vector : mem_vec (picture_d-1 downto 0);
		alias red_vector   is vector(2);
		alias green_vector is vector(1);
		alias blue_vector  is vector(0);
	begin
		for index in pix'reverse_range loop
			red_vector((index * color_d) + color_d-1 downto index * color_d)   := to_stdlogicvector(pix(index).r);
			green_vector((index * color_d) + color_d-1 downto index * color_d) := to_stdlogicvector(pix(index).g);
			blue_vector((index * color_d) + color_d-1 downto index * color_d)  := to_stdlogicvector(pix(index).b);
		end loop;
		return vector;
	end function PIXEL2mem_vec;
	
	function log2(pow: integer) return integer is
		variable p: integer;
	begin
		for i in 0 to pow loop
			p:=i;
			exit when (2**i>=pow);	
		end loop;
	return p;
	end function log2;
   
end package body project_package;