----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2022 07:41:29 PM
-- Design Name: 
-- Module Name: ID - Behavioral
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

entity ID is
    Port ( clk : in STD_LOGIC;
           instr : in STD_LOGIC_VECTOR (15 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           regdst : in STD_LOGIC;
           regwrite : in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0);
           ext_imm : out STD_LOGIC_VECTOR (15 downto 0);
           ext_op : in STD_LOGIC;
           func : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC);
end ID;

architecture Behavioral of ID is
        component reg_file is
        port (
            clk : in std_logic;
            ra1 : in std_logic_vector (2 downto 0);
            ra2 : in std_logic_vector (2 downto 0);
            wa : in std_logic_vector (2 downto 0);
            wd : in std_logic_vector (15 downto 0);
            RegWr : in std_logic;
            rd1 : out std_logic_vector (15 downto 0);
            rd2 : out std_logic_vector (15 downto 0)
        );
        end component;
signal read_address1 :std_logic_vector(2 downto 0);
signal read_address2 :std_logic_vector(2 downto 0);
signal write_address :std_logic_vector(2 downto 0);
signal ext_imm_out :std_logic_vector(15 downto 0);
begin
RF: reg_file port map ( clk => clk,
                        ra1 => read_address1,
                        ra2 => read_address2,
                        wa => write_address,
                        wd => WD,
                        RegWr => RegWrite,
                        rd1 => rd1,
                        rd2 => rd2
                        );
                        
 mux : process(regdst)
 begin
 case regdst is 
     when '0' => write_address <= instr(9 downto 7);
     when '1' => write_address <= instr(6 downto 4);
 end case;
 end process;
 

 
 ext_process : process(instr, ext_op)
 begin
 case ext_op is
 when '0' => ext_imm_out <= "000000000" & Instr(6 downto 0);
 when others => 
    case (instr(6)) is
             when '0' => ext_imm_out <= "000000000" & instr(6 downto 0);
             when '1' => ext_imm_out <= "111111111" & instr(6 downto 0);
             when others => ext_imm_out <= ext_imm_out;
         end case;
 end case;
 end process;


 read_address1 <= instr(12 downto 10);
 read_address2 <= instr(9 downto 7);
 func <= instr(2 downto 0);
 sa <= instr(3);
 ext_imm <= ext_imm_out;
end Behavioral;
