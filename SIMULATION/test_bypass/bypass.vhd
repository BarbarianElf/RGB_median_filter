-------------------------------------------------------------------------------
---- Project  : Image Processing RGB median filter
-------------------------------------------------------------------------------
-- File       : bypass.vhd
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

entity bypass is
	port (
		  start			: in  std_logic;
		  clk			: in  std_logic;
		  rst			: in  std_logic;
		  done   		: out std_logic
	    );
end entity bypass;

architecture bypass of bypass is
	signal read_address_rom, write_address_ram : std_logic_vector(log2(picture_h)-1 downto 0);
	signal rom_out, ram_in : mem_vec(2 downto 0);
	
	signal new_row, bypass_row : PIXEL(picture_w-1 downto 0);
	signal prev_row, curr_row, next_row : PIXEL(picture_w+1 downto 0);
	signal write_ena : std_logic;
	signal push      : std_logic;
	
begin
	fsm_unit: entity work.CONTROL_UNIT
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
	
	buffer_row :entity work.buffer_reg
	port map (
			  new_row  => new_row,
			  ena      => push,
			  clk      => clk,
			  rst      => rst,
			  prev_row => prev_row,
			  curr_row => curr_row,
			  next_row => next_row
			);
	
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
	
	p1: process (rom_out) is
	begin
		new_row <= mem_vec2PIXEL(rom_out);
	end process p1;
	
	bypass_row <= curr_row(picture_w downto 1);
	
	p2: process (bypass_row) is
	begin
		ram_in <= PIXEL2mem_vec(bypass_row);
	end process p2;

end architecture bypass;