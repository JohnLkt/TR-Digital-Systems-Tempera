----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.12.2022 01:30:32
-- Design Name: 
-- Module Name: Display_Logic - Behavioral
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
use IEEE.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Display_Logic is
  Port (
    RAW_DATA : in std_logic_vector (12 downto 0);
    Common_A : in std_logic_vector (7 downto 0);
    rst : in std_logic;
    TBD_bin : out std_logic_vector (3 downto 0)
   );
end Display_Logic;

architecture Behavioral of Display_Logic is

begin

    process (RAW_DATA, Common_A, rst)
        -- bcd data storage registers
        variable sign, hundred, ten, unit, float, float1, float2, float3 : std_logic_vector (3 downto 0);
        -- celcius
        variable celcius : std_logic_vector (3 downto 0) := "1100";
        -- processed data
        variable P_DATA : std_logic_vector (7 downto 0);
        -- double dabble algorithm buffers
        variable temp: std_logic_vector (7 downto 0);
        variable BCD: std_logic_vector (11 downto 0);
        variable y: integer := 0;
        begin
        
        -- process 13 bit signed data to 8 bit unsigned, 4 bit float, and seperate the sign
            if(RAW_DATA(12) = '1') then
                -- if the data is signed
                sign := "1010"; -- make sign segment display (-)
--                for i in 0 to 7 loop
--                    P_DATA(i) := not RAW_DATA(i + 4); -- perform two's complement: inversion
                    P_DATA(0) := not RAW_DATA(4);
                    P_DATA(1) := not RAW_DATA(5);
                    P_DATA(2) := not RAW_DATA(6);
                    P_DATA(3) := not RAW_DATA(7);
                    P_DATA(4) := not RAW_DATA(8);
                    P_DATA(5) := not RAW_DATA(9);
                    P_DATA(6) := not RAW_DATA(10);
                    P_DATA(7) := not RAW_DATA(11);
                    
--                end loop;
                for i in 0 to 3 loop
                    float(i) := not RAW_DATA(i); -- perform two's complement: inversion
                end loop;
                P_DATA := P_DATA + 1; -- perform two's complement: add by 1
                float := float +1; -- perform two's complement: add by 1
            elsif (RAW_DATA(12) = '0') then
                -- if the data is unsigned
                sign := "1011"; -- make sign segment display blank
--                for i in 0 to 7 loop
--                    P_DATA(i) := RAW_DATA(i + 4); -- pass data to variable
--                end loop;

                    P_DATA(0) :=  RAW_DATA(4);
                    P_DATA(1) :=  RAW_DATA(5);
                    P_DATA(2) :=  RAW_DATA(6);
                    P_DATA(3) :=  RAW_DATA(7);
                    P_DATA(4) :=  RAW_DATA(8);
                    P_DATA(5) :=  RAW_DATA(9);
                    P_DATA(6) :=  RAW_DATA(10);
                    P_DATA(7) :=  RAW_DATA(11);
                    
                for i in 0 to 3 loop
                    float(i) := RAW_DATA(i); -- pass data to variable
                end loop;
             end if;
        -- double dabble to convert 8 bit binary to 3 bcd digits
            BCD (11 downto 0) := "000000000000";
            temp (7 downto 0) := P_DATA (7 downto 0);
            
            for i in 0 to 7 loop -- do operation to each source bit
                if BCD (3 downto 0) > 4 then --  unit digit
                BCD (3 downto 0) := BCD (3 downto 0) + 3;
                end if;
                    
                if BCD (7 downto 4) > 4 then -- ten digit
                BCD (7 downto 4) := BCD (7 downto 4) + 3;
                end if;
                
                -- hundred digit not needed since 8 bits only have 3 states (0/1/2)
                
                BCD := BCD (10 downto 0) & temp(temp'left); -- shift bcd and add next data entry
                temp := temp(temp'left - 1 downto temp'right) & '0'; -- shift src and add 0
            end loop;
            
            unit := BCD (3 downto 0); -- assign unit value to variable for storage
            ten := BCD (7 downto 4); -- assign ten value to variable for storage
            hundred := BCD (11 downto 8); -- assign hundred value to variable for storage
            
            -- floating point decoder
            case float is
                when "0000" => float1 := "0000"; float2 := "0000"; float3 := "0000"; -- .000
                
                when "0001" => float1 := "0000"; float2 := "0110"; float3 := "0010"; -- .062
                
                when "0010" => float1 := "0001"; float2 := "0010"; float3 := "0101"; -- .125
                
                when "0011" => float1 := "0001"; float2 := "1000"; float3 := "0111"; -- .187
                
                when "0100" => float1 := "0010"; float2 := "0101"; float3 := "0000"; -- .250
               
                when "0101" => float1 := "0011"; float2 := "0001"; float3 := "0010"; -- .312
                
                when "0110" => float1 := "0011"; float2 := "0111"; float3 := "0101"; -- .375
                
                when "0111" => float1 := "0100"; float2 := "0011"; float3 := "0111"; -- .437
                
                when "1000" => float1 := "0101"; float2 := "0000"; float3 := "0000"; -- .500
                
                when "1001" => float1 := "0101"; float2 := "0110"; float3 := "0010"; -- .562
                
                when "1010" => float1 := "0110"; float2 := "0010"; float3 := "0101"; -- .625
                
                when "1011" => float1 := "0110"; float2 := "1000"; float3 := "0111"; -- .687
                
                when "1100" => float1 := "0111"; float2 := "0101"; float3 := "0000"; -- .750
                
                when "1101" => float1 := "1000"; float2 := "0001"; float3 := "0010"; -- .812
                
                when "1110" => float1 := "1000"; float2 := "0111"; float3 := "0101"; -- .875
                
                when "1111" => float1 := "1001"; float2 := "0011"; float3 := "0111"; -- .937
            end case;
        -- Output Selection (Forwarding from stored digits)
            case Common_A is
                when "01111111" => TBD_bin <= sign;
                when "10111111" => TBD_bin <= hundred;
                when "11011111" => TBD_bin <= ten;
                when "11101111" => TBD_bin <= unit;
                when "11110111" => TBD_bin <= float1;
                when "11111011" => TBD_bin <= float2;
                when "11111101" => TBD_bin <= float3;
                when "11111110" => TBD_bin <= celcius;
                when others => TBD_bin <= "1011";
            end case;
    end process;
end Behavioral;
