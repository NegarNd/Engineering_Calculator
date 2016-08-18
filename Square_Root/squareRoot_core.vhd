--------------------------------------------------------------------------------
--    This file is owned and controlled by Xilinx and must be used solely     --
--    for design, simulation, implementation and creation of design files     --
--    limited to Xilinx devices or technologies. Use with non-Xilinx          --
--    devices or technologies is expressly prohibited and immediately         --
--    terminates your license.                                                --
--                                                                            --
--    XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" SOLELY    --
--    FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY    --
--    PROVIDING THIS DESIGN, CODE, OR INFORMATION AS ONE POSSIBLE             --
--    IMPLEMENTATION OF THIS FEATURE, APPLICATION OR STANDARD, XILINX IS      --
--    MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION IS FREE FROM ANY      --
--    CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE FOR OBTAINING ANY       --
--    RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY       --
--    DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE   --
--    IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR          --
--    REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF         --
--    INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A   --
--    PARTICULAR PURPOSE.                                                     --
--                                                                            --
--    Xilinx products are not intended for use in life support appliances,    --
--    devices, or systems.  Use in such applications are expressly            --
--    prohibited.                                                             --
--                                                                            --
--    (c) Copyright 1995-2016 Xilinx, Inc.                                    --
--    All rights reserved.                                                    --
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- You must compile the wrapper file squareRoot_core.vhd when simulating
-- the core, squareRoot_core. When compiling the wrapper file, be sure to
-- reference the XilinxCoreLib VHDL simulation library. For detailed
-- instructions, please refer to the "CORE Generator Help".

-- The synthesis directives "translate_off/translate_on" specified
-- below are supported by Xilinx, Mentor Graphics and Synplicity
-- synthesis tools. Ensure they are correct for your synthesis tool(s).

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- synthesis translate_off
LIBRARY XilinxCoreLib;
-- synthesis translate_on
ENTITY squareRoot_core IS
  PORT (
    a : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    clk : IN STD_LOGIC;
    sclr : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    invalid_op : OUT STD_LOGIC
  );
END squareRoot_core;

ARCHITECTURE squareRoot_core_a OF squareRoot_core IS
-- synthesis translate_off
COMPONENT wrapped_squareRoot_core
  PORT (
    a : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    clk : IN STD_LOGIC;
    sclr : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    invalid_op : OUT STD_LOGIC
  );
END COMPONENT;

-- Configuration specification
  FOR ALL : wrapped_squareRoot_core USE ENTITY XilinxCoreLib.floating_point_v5_0(behavioral)
    GENERIC MAP (
      c_a_fraction_width => 4,
      c_a_width => 8,
      c_b_fraction_width => 4,
      c_b_width => 8,
      c_compare_operation => 8,
      c_has_a_nd => 0,
      c_has_a_negate => 0,
      c_has_a_rfd => 0,
      c_has_aclr => 0,
      c_has_add => 0,
      c_has_b_nd => 0,
      c_has_b_negate => 0,
      c_has_b_rfd => 0,
      c_has_ce => 0,
      c_has_compare => 0,
      c_has_cts => 0,
      c_has_divide => 0,
      c_has_divide_by_zero => 0,
      c_has_exception => 0,
      c_has_fix_to_flt => 0,
      c_has_flt_to_fix => 0,
      c_has_flt_to_flt => 0,
      c_has_inexact => 0,
      c_has_invalid_op => 1,
      c_has_multiply => 0,
      c_has_operation_nd => 0,
      c_has_operation_rfd => 0,
      c_has_overflow => 0,
      c_has_rdy => 0,
      c_has_sclr => 1,
      c_has_sqrt => 1,
      c_has_status => 0,
      c_has_subtract => 0,
      c_has_underflow => 0,
      c_latency => 8,
      c_mult_usage => 0,
      c_optimization => 1,
      c_rate => 1,
      c_result_fraction_width => 4,
      c_result_width => 8,
      c_speed => 2,
      c_status_early => 0,
      c_xdevicefamily => "virtex4"
    );
-- synthesis translate_on
BEGIN
-- synthesis translate_off
U0 : wrapped_squareRoot_core
  PORT MAP (
    a => a,
    clk => clk,
    sclr => sclr,
    result => result,
    invalid_op => invalid_op
  );
-- synthesis translate_on

END squareRoot_core_a;
