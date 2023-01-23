----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.12.2022 01:30:07
-- Design Name: 
-- Module Name: Ring_Counter_8bit - Behavioral
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

entity Ring_Counter_8bit is
  Port (
    dis_clk : in std_logic;
    rst : in std_logic;
    Common_A : out std_logic_vector (7 downto 0)
   );
end Ring_Counter_8bit;

architecture Behavioral of Ring_Counter_8bit is
-- declare shift register signal
signal shift_register: std_logic_vector (7 downto 0) := "11111110";

begin

-- Ring Counter
    process (dis_clk, rst)
        
        begin

        -- reset condition
        if(rst = '1') then shift_register <= "01111111";
        -- shift operation
        elsif(rst = '0' and rising_edge(dis_clk)) then
            shift_register(1) <= shift_register(0);
            shift_register(2) <= shift_register(1);
            shift_register(3) <= shift_register(2);
            shift_register(4) <= shift_register(3);
            shift_register(5) <= shift_register(4);
            shift_register(6) <= shift_register(5);
            shift_register(7) <= shift_register(6);
            shift_register(0) <= shift_register(7);
        end if;

    end process;
    -- forward signal values to I/O ports
    Common_A <= shift_register;
    
end Behavioral;
