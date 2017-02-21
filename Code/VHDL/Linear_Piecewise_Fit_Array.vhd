--------------------------------------------------------------------------------
-- File: Linear_Piecewise_Fit_Array.vhd
-- Initial Author: John Sochacki
-- Additional Authors: NA
-- Company: Comtech EF Data
--			2114 West 7th Street
--			Tempe, AZ 85281
--			480-333-2200
--------------------------------------------------------------------------------
-- Title:
--		Linear Piecewise Fit Array
--
-- Description:
--		Linear_Piecewise_Fit_Array instantiates and connects CNTRL_MODULES # of
--		the Linear_Piecewise_Fit components with variable bus width
--		(BUS_WIDTH) and variable coefficient width (COEFFICIENT_WIDTH) for use in
--		the linearizer control system
--
-- Verification:
--		All realistic input values have been simulated and validated
--------------------------------------------------------------------------------
-- Revision History
--
-- 26-Jan-2015 JS
-- initial draft
--
-- Design unit header --

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

entity Linear_Piecewise_Fit_Array is
generic(
	BUS_WIDTH : integer := 12;
	COEFFICIENT_WIDTH : integer := 24;
	CNTRL_MODULES : integer := 8
);
port(
	clock, update : in std_logic;
	input_power_voltage : in std_logic_vector(BUS_WIDTH-1 downto 0);
	coefficients_vector : in std_logic_vector((2*CNTRL_MODULES*COEFFICIENT_WIDTH)-1 downto 0);
	output_voltage : out std_logic_vector((BUS_WIDTH*CNTRL_MODULES)-1 downto 0);
	initialized : out std_logic
);
end Linear_Piecewise_Fit_Array;

architecture top of Linear_Piecewise_Fit_Array is

--LPWF Module Component Declaration
component Linear_Piecewise_Fit
generic(
	BUS_WIDTH : integer;
	COEFFICIENT_WIDTH : integer
);
port(
	clock : in std_logic;
	input_power_voltage : in std_logic_vector(BUS_WIDTH-1 downto 0);
	coefficients_vector : in std_logic_vector((2*COEFFICIENT_WIDTH)-1 downto 0);
	output_voltage : out std_logic_vector(BUS_WIDTH-1 downto 0)
);
end component;

--LPWF Module Array Coefficient Manager Module
component Linear_Piecewise_Fit_Array_Coefficient_Manager
generic(
	COEFFICIENT_WIDTH : integer;
	CNTRL_MODULES : integer
);
port(
	clock, update : in std_logic;
	coefficients_vector_new : in std_logic_vector((2*CNTRL_MODULES*COEFFICIENT_WIDTH)-1 downto 0);
	coefficients_vector_current : out std_logic_vector((2*CNTRL_MODULES*COEFFICIENT_WIDTH)-1 downto 0);
	initialized : out std_logic
);
end component;

signal coefficients_vector_current_connection : std_logic_vector((2*CNTRL_MODULES*COEFFICIENT_WIDTH)-1 downto 0);

begin

LPWFCM : Linear_Piecewise_Fit_Array_Coefficient_Manager
	generic map(
	COEFFICIENT_WIDTH => COEFFICIENT_WIDTH,
	CNTRL_MODULES => CNTRL_MODULES
	)
	port map(
	clock => clock,
	update => update,
	coefficients_vector_new => coefficients_vector,
	coefficients_vector_current => coefficients_vector_current_connection,
	initialized => initialized
	);

GEN_LPF_A : for i in 1 to CNTRL_MODULES generate
	LPFC_X : Linear_Piecewise_Fit
		generic map(
		BUS_WIDTH => BUS_WIDTH,
		COEFFICIENT_WIDTH => COEFFICIENT_WIDTH
		)
		port map(
		clock => clock,
		input_power_voltage => input_power_voltage,
		coefficients_vector => coefficients_vector_current_connection((2*i*COEFFICIENT_WIDTH)-1 downto (2*(i-1)*COEFFICIENT_WIDTH)),
		output_voltage => output_voltage((i*BUS_WIDTH)-1 downto ((i-1)*BUS_WIDTH))
		);
end generate GEN_LPF_A;

end top;