----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.12.2022 01:30:47
-- Design Name: 
-- Module Name: Seven_Segment_Decoder - Behavioral
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

entity Seven_Segment_Decoder is
  Port (
    TBD_bin : in std_logic_vector (3 downto 0);
    Seven_Seg_Out : out std_logic_vector (7 downto 0)
   );
end Seven_Segment_Decoder;

architecture Behavioral of Seven_Segment_Decoder is

begin

    process (TBD_bin)
        variable temp : std_logic_vector (7 downto 0);
        
        begin
        
        -- switch case BCD decoder with special characters
        case TBD_bin is  
            -- numbers 0-9
            when "0000" => temp := "11000000"; -- 0
            when "0001" => temp := "11111001"; -- 1
            when "0010" => temp := "10100100"; -- 2
            when "0011" => temp := "10110000"; -- 3
            when "0100" => temp := "10011001"; -- 4
            when "0101" => temp := "10010010"; -- 5
            when "0110" => temp := "10000010"; -- 6
            when "0111" => temp := "11111000"; -- 7
            when "1000" => temp := "10000000"; -- 8
            when "1001" => temp := "10010000"; -- 9
            -- special characters
            when "1010" => temp := "10111111"; -- Negative sign (-)
            when "1011" => temp := "11111111"; -- blank
            when "1100" => temp := "11000110"; -- celcius sign
            when others => temp := "11111111"; -- blank
        end case;

        -- forward variable values to I/O ports
        Seven_Seg_Out <= temp;
        
    end process;


end Behavioral;
