--------------------------------------------------------------------------------
-- File: Linear_Piecewise_Fit.vhd
-- Initial Author: John Sochacki
-- Additional Authors: NA
-- Company: Comtech EF Data
--			2114 West 7th Street
--			Tempe, AZ 85281
--			480-333-2200
--------------------------------------------------------------------------------
-- Title:
--		Linear Piecewise Fit
--
-- Description:
--		Linear_Piecewise_Fit is a first order polynomial with variable bus width
--		(BUS_WIDTH) and variable coefficient width (COEFFICIENT_WIDTH) for use in
--		the linearizer control system
--
-- 		This is a simple first order polynomial.  It implements the following:
--		y = a * x + b where x is the input_power_voltage and
--		a and b are the polynomial coefficients.
--
--		The polynomial coefficients are stuffed end to end into the
--		coefficients_vector signal in the following manner:
--		MSB(msb(a)lsb msb(b)lsb)LSB.
--		Each coefficient is of size COEFFICIENT_WIDTH.
--
--		All the math is signed as the coefficients can be positive or negative
--		although the input and output will always only ever be of the same sign
--		so before the output is registered the sign bit is thrown away.
--
--		As the code is in a register sandwitch it sould take two clock cycles
--		for the output to achieve the result for the respective input.
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

entity Linear_Piecewise_Fit is
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
end Linear_Piecewise_Fit;

architecture mixed of Linear_Piecewise_Fit is

--Declare My Internal Signed Signals
signal input_power_voltage_signed : signed(COEFFICIENT_WIDTH-1 downto 0);
signal coefficients_a_signed : signed(COEFFICIENT_WIDTH-1 downto 0);
signal coefficients_b_signed : signed((2*COEFFICIENT_WIDTH)-1 downto 0);
signal output_voltage_signed : signed(BUS_WIDTH -1 downto 0);

begin

--Clock The Data In
	register_input : process(clock)
		begin
			if rising_edge(clock) then
				input_power_voltage_signed <= resize(signed(input_power_voltage),input_power_voltage_signed'length);
				coefficients_a_signed <= signed(coefficients_vector((2*COEFFICIENT_WIDTH)-1 downto COEFFICIENT_WIDTH));
				coefficients_b_signed <= resize(signed(coefficients_vector(COEFFICIENT_WIDTH-1 downto 0),2*COEFFICIENT_WIDTH);
			end if;
	end process register_input;

--Implement The Polynomial
	output_voltage_signed <= resize(shift_right((input_power_voltage_signed
					* coefficients_a_signed)
					+ coefficients_b_signed
					,COEFFICIENT_WIDTH-1-BUS_WIDTH),BUS_WIDTH+1);

--Clock The Data Out
	register_output : process(clock)
		begin
			if rising_edge(clock) then
				--I Throw Away The Sign As My ADCs Are Unipolar And Will Never Need It
				output_voltage <= std_logic_vector(output_voltage_signed(BUS_WIDTH-1 downto 0));
			end if;
	end process register_output;

end mixed;
