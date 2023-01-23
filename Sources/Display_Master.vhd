----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.12.2022 00:49:40
-- Design Name: 
-- Module Name: Display_Master - Behavioral
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

entity Display_Master is
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
end Display_Master;

architecture Behavioral of Display_Master is
-- component list:
    -- clock reducer for running display functions
    component Display_Clock
        Port (
        sys_clk : in std_logic;
        dis_clk : out std_logic
        );
    end component;
    
    -- 4 bit ring counter for Common Annode selection and scanning function
    component Ring_Counter_8bit
        Port (
        dis_clk : in std_logic;
        rst : in std_logic;
        Common_A : out std_logic_vector (7 downto 0)
        );
    end component;
    
    -- Display Logic Processing
    component Display_Logic
        Port (
            RAW_DATA : in std_logic_vector (12 downto 0);
            Common_A : in std_logic_vector (7 downto 0);
            rst : in std_logic;
            -- binary to be displayed (to decoder)
            TBD_bin : out std_logic_vector (3 downto 0)
        );
    end component;
    
    -- 7 segment decoder with special characters
    component Seven_Segment_Decoder
        Port (
        TBD_bin : in std_logic_vector (3 downto 0);
        Seven_Seg_Out : out std_logic_vector (7 downto 0)
        );
    end component;
    
-- all component output signals:
    signal dis_clk : std_logic;
    signal Common_A : std_logic_vector (7 downto 0);
    signal TBD_bin : std_logic_vector (3 downto 0);
    signal Seven_Seg_Out : std_logic_vector (7 downto 0);

begin
-- port mapping components
    Display_Clock_Component: Display_Clock port map(
        sys_clk => sys_clk,
        dis_clk => dis_clk
    );
    Ring_Counter_8bit_Component: Ring_Counter_8bit port map (
        dis_clk => dis_clk,
        rst => rst,
        Common_A => Common_A
    );
    Display_Logic_Component: Display_Logic port map (
        RAW_DATA => RAW_DATA,
        Common_A => Common_A,
        rst => rst,
        TBD_bin => TBD_bin
    );
    Seven_Segment_Decoder_Component: Seven_Segment_Decoder port map (
        TBD_bin => TBD_bin,
        Seven_Seg_Out => Seven_Seg_Out
    );

-- forward relevant component outputs to top level I/O
    Common_A_Selected <= Common_A (7 downto 0);
    Seven_Seg_Decoded <= Seven_Seg_Out (7 downto 0);
    -- debug
    
end Behavioral;
