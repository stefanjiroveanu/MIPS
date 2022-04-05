----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/29/2022 06:35:06 PM
-- Design Name: 
-- Module Name: ex_unity - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ex_unity is
    Port ( rd1 : in STD_LOGIC_VECTOR (0 to 15);
           rd2 : in STD_LOGIC_VECTOR (0 to 15);
           sa : in STD_LOGIC;
           ext_imm : in STD_LOGIC_VECTOR (0 to 15);
           func : in STD_LOGIC_VECTOR (0 to 2);
           zero : out STD_LOGIC;
           alures : out STD_LOGIC_VECTOR (0 to 15);
           pc : in STD_LOGIC_VECTOR (0 to 15);
           alu_src : in std_logic;
           alu_op : in std_logic_vector(0 to 2);
           ba: out std_logic_vector(0 to 15));
           
end ex_unity;

architecture Behavioral of ex_unity is
signal alu_ctr : std_logic_vector (2 downto 0);
signal alu_in : std_logic_vector (15 downto 0);
signal temp : std_logic_vector (15 downto 0);
begin
    ba <= pc + ext_imm;
    process(alu_src)
    begin
        case alu_src is
             when '0' => alu_in <= rd2;
             when others => alu_in <= ext_imm;
    end case;
    end process;
    
    process(alu_op, func)
    begin
        case(alu_op) is
            when "000" => alu_ctr <= func;  -- R-Type
            when "001" => alu_ctr <= "000"; -- ADDI does addition
            when "100" => alu_ctr <= "001"; -- BEQ does subtraction
            when "101" => alu_ctr <= "100"; -- ANDI
            when "110" => alu_ctr <= "101"; -- ORI
            when others => alu_ctr <= "XXX";
        end case;
    end process;
    
    process(alu_ctr, rd1, alu_in)
    begin
        case(alu_ctr) is
            when "000" => temp <= rd1 + alu_in;
            when "001" => temp <= rd1 - alu_in;
            when "010" => temp <= alu_in(14 downto 0) & "0";
            when "011" => temp <= "0" & alu_in(15 downto 1);
            when "100" => temp <= rd1 and alu_in;
            when "101" => temp <= rd1 or alu_in;
            when "110" => temp <= rd1 xor alu_in;
            when "111" => temp <= shl(rd1, alu_in) ;
        end case;
    end process;
    alures <= temp;
    zero <=  '1' when temp = x"0000" else '0';
end Behavioral;
