--------------------------------------------------------------------------------
-- File: Linear_Piecewise_Fit_Array_Coefficient_Manager.vhd
-- Initial Author: John Sochacki
-- Additional Authors: NA
-- Company: Comtech EF Data
--			2114 West 7th Street
--			Tempe, AZ 85281
--			480-333-2200
--------------------------------------------------------------------------------
-- Title:
--		Linear Piecewise Fit Array Coefficient Manager
--
-- Description:
--		Linear_Piecewise_Fit_Array_Coefficient_Manager is the entity that stores
--		the current coefficients in ram and makes sure that the new ones are
--		properly loaded and ready to go before updating the Linear_Piecewise_Fit
--		entity.  It has variable number of control modules that it can deal with
--		(CNTRL_MODULES) and variable coefficient width (COEFFICIENT_WIDTH) for use in
--		the linearizer control system
--
-- WARNING:
--		There is no built in overflow/truncation protection.  
--		In addition, the sign bit is thrown away in the end before the output is
--		registered so if this is desired, make a wrapper for this function and
--		implement it there.
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
	use ieee.math_real.all;

entity Linear_Piecewise_Fit_Array_Coefficient_Manager is
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
end Linear_Piecewise_Fit_Array_Coefficient_Manager;

architecture ram of Linear_Piecewise_Fit_Array_Coefficient_Manager is

--attribute allow_any_ram_size_for_recognition on

component Linear_Piecewise_Fit_Array_Coefficient_RAM
generic(
	DATA_WIDTH : natural;
	ADDR_BIT_WIDTH : natural
);
port(
	clk  : in std_logic;
	addr : in natural range 0 to 2**ADDR_BIT_WIDTH - 1;
	data : in std_logic_vector((DATA_WIDTH - 1) downto 0);
	we   : in std_logic;
	q    : out std_logic_vector((DATA_WIDTH - 1) downto 0)
);
end component;

signal coefficients_vector_current_internal : std_logic_vector((2*CNTRL_MODULES*COEFFICIENT_WIDTH)-1 downto 0);
signal ready_internal : std_logic :='0';
signal initialized_internal : std_logic :='0';

signal data_out_signal : std_logic_vector((2*COEFFICIENT_WIDTH)-1 downto 0);
signal addr_signal : natural range 0 to CNTRL_MODULES-1;
signal data_in_signal : std_logic_vector((2*COEFFICIENT_WIDTH)-1 downto 0);
signal write_enable_signal : std_logic;

CRAM: Linear_Piecewise_Fit_Array_Coefficient_RAM
	generic map(
		DATA_WIDTH => natural(2*COEFFICIENT_WIDTH),
		ADDR_BIT_WIDTH => natural(ceil(log2(real(CNTRL_MODULES))))
	)
	port map(
		clk => clock,
		addr => addr_signal,
		data => data_in_signal,
		we => write_enable_signal,
		q => data_out_signal
	);

update_ram_coefficients_and_vector : process(clock,update,initialized_internal,ready_internal)
begin
	if rising_edge(clock) then
		if update = '1' and initialized_internal = '1' then
			ready_internal <= '0';
			write_enabled_signal <= '1';
			for i in 0 to (CNTRL_MODULES - 1) loop
				addr_signal <= natural(i);
				data_in_signal <= coefficients_vector_new(((2*(i+1)*COEFFICIENT_WIDTH)-1) downto (2*(i)*COEFFICIENT_WIDTH));
			end loop;
			write_enabled_signal <= '0';
		elsif update = '1' and initialized_internal = '0' then
			write_enabled_signal <= '1';
			for i in 0 to (CNTRL_MODULES - 1) loop
				addr_signal <= natural(i);
				data_in_signal <= coefficients_vector_new(((2*(i+1)*COEFFICIENT_WIDTH)-1) downto (2*(i)*COEFFICIENT_WIDTH));
			end loop;
			write_enabled_signal <= '0';
			initialized_internal <= '1';
			initialized <= initialized_internal;
		elsif initialized_internal = '1' and update = '0' and ready_internal ='0' then
			write_enabled_signal <= '0';
			for i in 0 to (CNTRL_MODULES - 1) loop
				addr_signal <= natural(i);
				coefficients_vector_current_internal(((2*(i+1)*COEFFICIENT_WIDTH)-1) downto (2*(i)*COEFFICIENT_WIDTH)) <= data_out_signal;
			end loop;
			ready_internal <= '1';
		end if;
	end if;
end process;

update_output_coefficients : process(clock,update,initialized_internal,ready_internal)
begin
	if initialized_internal = '1' and update = '0' and ready_internal = '1' then
		if rising_edge(clock) then
			coefficients_vector_current <= coefficients_vector_current_internal;
		end if;
	end if;
end process;
	
end ram;