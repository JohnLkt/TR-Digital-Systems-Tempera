----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.12.2022 01:19:08
-- Design Name: 
-- Module Name: Display_Clock - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Display_Clock is
  Port (
    sys_clk : in std_logic;
    dis_clk : out std_logic
   );
end Display_Clock;

architecture Behavioral of Display_Clock is

begin
-- Display Clock Generation
    process (sys_clk)
        variable count : integer := 0;
        variable output : std_logic := '0';
        
        begin
        
        if(rising_edge(sys_clk)) then count := count + 1;
        end if;
        
        if(count = 4999) then
            output := not output;
            count := 0;
        end if;
        
        -- forward variable values to I/O ports
        dis_clk <= output;
        
    end process;

end Behavioral;
