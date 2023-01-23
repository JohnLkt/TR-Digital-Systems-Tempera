----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.01.2023 12:35:30
-- Design Name: 
-- Module Name: Tempera - Behavioral
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

entity Tempera is
  Port (
  -- Common Annode selection for 7-segment display (8 segment)
  Common_A_Selected : out std_logic_vector (7 downto 0);
  -- Decoded 7-segment display vector
  Seven_Seg_Decoded : out std_logic_vector (7 downto 0);
  -- Input Clock from FPGA Board
  sys_clk : in std_logic;
  -- reset switch
  rst : in std_logic;
  
  TMP_SCL : inout STD_LOGIC;
  TMP_SDA : inout STD_LOGIC
  
   );
end Tempera;

architecture Behavioral of Tempera is
-- component list:
    -- Display Master
    component Display_Master
        Port (
          -- 13-Bit Input Register (From ADT7420)
          RAW_DATA : in std_logic_vector (12 downto 0);
          -- Common Annode selection for 7-segment display (8 segment)
          Common_A_Selected : out std_logic_vector (7 downto 0);
          -- Decoded 7-segment display vector
          Seven_Seg_Decoded : out std_logic_vector (7 downto 0);
          -- Input Clock from FPGA Board
          sys_clk : in std_logic;
          -- reset switch
          rst : in std_logic
        );
    end component;
    -- TempSensorCtl
    component TempSensorCtl
        Port (
            TMP_SCL : inout STD_LOGIC;
            TMP_SDA : inout STD_LOGIC;
            
            TEMP_O : out STD_LOGIC_VECTOR(12 downto 0); --12-bit two's complement temperature with sign bit
            RDY_O : out STD_LOGIC;	--'1' when there is a valid temperature reading on TEMP_O
            ERR_O : out STD_LOGIC; --'1' if communication error
            
            CLK_I : in STD_LOGIC;
            SRST_I : in STD_LOGIC
        );
    end component;
    
-- all component output signals:
    signal RAW_DATA : std_logic_vector (12 downto 0);
    signal TEMP_O : std_logic_vector (12 downto 0);

begin
-- port mapping components
    Display_Master_component: Display_Master port map(
        RAW_DATA => RAW_DATA,
        Common_A_Selected => Common_A_Selected,
        Seven_Seg_Decoded => Seven_Seg_Decoded,
        sys_clk => sys_clk,
        rst => rst
    );
    
    TempSensorCtl_component: TempSensorCtl port map(
            TEMP_O => TEMP_O,
            CLK_I => sys_clk,
            SRST_I => rst,
            TMP_SDA => TMP_SDA,
            TMP_SCL => TMP_SCL
    );
    
    -- map correct bits
    RAW_DATA <= TEMP_O (12 downto 0);

end Behavioral;
