-------------------------------------------------------------------------------
---- Project  : Image Processing RGB median filter
-------------------------------------------------------------------------------
-- File       : generic_ram.vhd    **GENERATED VIA QUARTUS-19.1
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

ENTITY generic_ram IS
	GENERIC
	(
		address_size  : NATURAL;
		data_size     : NATURAL;
		device_name   : STRING;
		ram_name      : STRING
	);
	PORT
	(
		address	: IN  STD_LOGIC_VECTOR (address_size-1 DOWNTO 0);
		aclr	: IN  STD_LOGIC;
		clock	: IN  STD_LOGIC;
		wren	: IN  STD_LOGIC;
		data	: IN  STD_LOGIC_VECTOR (data_size-1 DOWNTO 0);
		q		: OUT STD_LOGIC_VECTOR (data_size-1 DOWNTO 0)
	);
END generic_ram;


ARCHITECTURE SYN OF generic_ram IS

	SIGNAL sub_wire0	: STD_LOGIC_VECTOR (q'range);

BEGIN
	q    <= sub_wire0(q'range);

	altsyncram_component : altsyncram
	GENERIC MAP (
		clock_enable_input_a          => "BYPASS",
		clock_enable_output_a         => "BYPASS",
		intended_device_family        => device_name,
		lpm_hint                      => "ENABLE_RUNTIME_MOD=YES,INSTANCE_NAME=" & ram_name,
		lpm_type                      => "altsyncram",
		numwords_a                    => 2**address_size,
		operation_mode                => "SINGLE_PORT",
		outdata_aclr_a                => "CLEAR0",
		outdata_reg_a                 => "CLOCK0",
		power_up_uninitialized        => "FALSE",
		read_during_write_mode_port_a => "NEW_DATA_NO_NBE_READ",
		widthad_a                     => address_size,
		width_a                       => data_size,
		width_byteena_a               => 1
	)
	PORT MAP (
		aclr0     => aclr,
		address_a => address,
		clock0    => clock,
		data_a    => data,
		wren_a    => wren,
		q_a       => sub_wire0
	);



END SYN;
