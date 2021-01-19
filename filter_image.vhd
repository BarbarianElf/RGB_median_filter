-------------------------------------------------------------------------------
---- Project  : Image Processing RGB median filter
-------------------------------------------------------------------------------
-- File       : filter_image.vhd
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

entity filter_image is
	port (
		  start			: in  std_logic;
		  clk			: in  std_logic;
		  rst			: in  std_logic;
		  done   		: out std_logic
	    );
	attribute altera_chip_pin_lc : string;
    attribute altera_chip_pin_lc of clk  : signal is "Y2";
    attribute altera_chip_pin_lc of rst  : signal is "AB28";
	attribute altera_chip_pin_lc of start: signal is "M23";
    attribute altera_chip_pin_lc of done : signal is "E21";
end entity filter_image;

architecture filter_image of filter_image is
	signal read_address_rom, write_address_ram : std_logic_vector(log2(picture_h)-1 downto 0);
	signal rom_out, ram_in : mem_vec(2 downto 0);
	signal write_ena : std_logic;
	signal push      : std_logic;
	
begin
	control_unit: entity work.CONTROL_UNIT
	port map (
			  start         => start,
			  clk           => clk,
			  rst           => rst,
			  read_address  => read_address_rom,
			  write_address => write_address_ram,
			  write_ena     => write_ena,
			  push          => push,
			  done          => done
			);
	
	logic_unit: entity work.logic_UNIT
	port map (
			  rom_out       => rom_out,
			  push          => push,
			  clk           => clk,
			  rst           => rst,
			  ram_in        => ram_in
			);
			
	rom_loop: for i in rom_out'range generate
		rom: entity work.generic_rom
		generic map(
					address_size => log2(picture_h),
					data_size    => picture_h * color_d,
					device_name  => device_name,
					mif_f_name   => project_path & rom_name_arr(i)
					)
		port map(
				 aclr    => rst,
				 clock   => clk,
				 address => read_address_rom,
				 q       => rom_out(i)
				);
	end generate rom_loop;

	ram_loop: for i in ram_in'range generate
		ram: entity work.generic_ram
		generic map(
					address_size => log2(picture_h),
					data_size    => picture_h * color_d,
					device_name  => device_name,
					ram_name     => project_path & ram_name_arr(i)
					)
		port map(
				 address => write_address_ram,
				 aclr    => rst,
				 clock   => clk,
				 wren    => write_ena,
				 data    => ram_in(i),
				 q       => OPEN
				);
	end generate ram_loop;

end architecture filter_image;