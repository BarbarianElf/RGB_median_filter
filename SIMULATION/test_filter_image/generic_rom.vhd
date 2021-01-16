-------------------------------------------------------------------------------
---- Project  : Image Processing RGB median filter
-------------------------------------------------------------------------------
-- File       : generic_rom.vhd    **GENERATED VIA QUARTUS-19.1
-- Author     : Ziv
-- Created    : 23-12-2020
-- Last update: 30-12-2020
-- Platform   : 
-- Standard   : VHDL'93
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY generic_rom IS
	GENERIC
	(
		address_size  : NATURAL;
		data_size     : NATURAL;
		device_name   : STRING;
		mif_f_name    : STRING
	);
	PORT
	(
		aclr	: IN  STD_LOGIC;
		clock	: IN  STD_LOGIC;
		address	: IN  STD_LOGIC_VECTOR (address_size-1 DOWNTO 0);
		q		: OUT STD_LOGIC_VECTOR (data_size-1 DOWNTO 0)
	);
END generic_rom;

ARCHITECTURE SYN OF generic_rom IS
BEGIN
	altsyncram_component : altsyncram
	GENERIC MAP (
		address_aclr_a         => "CLEAR0",
		clock_enable_input_a   => "BYPASS",
		clock_enable_output_a  => "BYPASS",
		init_file              => mif_f_name,
		intended_device_family => device_name,
		lpm_type               => "altsyncram",
		numwords_a             => 2**address_size,
		operation_mode         => "ROM",
		outdata_aclr_a         => "CLEAR0",
		outdata_reg_a          => "CLOCK0",
		widthad_a              => address_size,
		width_a                => data_size,
		width_byteena_a        => 1
	)
	PORT MAP (
		aclr0     => aclr,
		address_a => address,
		clock0    => clock,
		q_a       => q
	);
END SYN;