----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2022 10:09:23 PM
-- Design Name: 
-- Module Name: Control_Unit - Behavioral
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

entity Control_Unit is
    Port ( instr : in STD_LOGIC_VECTOR (2 downto 0);
           reg_dst : out STD_LOGIC;
           ext_op : out STD_LOGIC;
           alu_src : out STD_LOGIC;
           branch : out STD_LOGIC;
           jump : out STD_LOGIC;
           alu_op : out STD_LOGIC_vector(2 downto 0);
           mem_write : out STD_LOGIC;
           mem_to_reg : out STD_LOGIC;
           reg_write : out STD_LOGIC);
end Control_Unit;

architecture Behavioral of Control_Unit is

begin
process(instr)
    begin
        reg_dst <= '0';
        ext_op <= '0';
        alu_src <= '0';
        branch <= '0';
        jump <= '0';
        alu_op <= "000";
        mem_write <= '0';
        mem_to_reg <= '0';
        reg_write <= '0';
    case instr is
        when "000" => reg_dst <= '1';
                      ext_op <= '0';
                      alu_src <= '0';
                      branch <= '0';
                      jump <= '0';
                      alu_op <= "000";
                      mem_write <= '0';
                      mem_to_reg <= '0';
                      reg_write <= '1';
       when "001" => --addi
                      reg_dst <= '0';
                      ext_op <= '1';
                      alu_src <= '1';
                      branch <= '0';
                      jump <= '0';
                      alu_op <= "001";
                      mem_write <= '0';
                      mem_to_reg <= '0';
                      reg_write <= '1';
       when "010" => --lw
                      reg_dst <= '0';
                      ext_op <= '1';
                      alu_src <= '1';
                      branch <= '0';
                      jump <= '0';
                      alu_op <= "001";
                      mem_write <= '0';
                      mem_to_reg <= '1';
                      reg_write <= '1';
        when "011" => --sw
                       reg_dst <= '0';
                       ext_op <= '1';
                       alu_src <= '1';
                       branch <= '0';
                       jump <= '0';
                       alu_op <= "001";
                       mem_write <= '1';
                       mem_to_reg <= '0';
                       reg_write <= '0';        
       when "100" => --BEQ
                       reg_dst <= '0';
                       ext_op <= '1';
                       alu_src <= '0';
                       branch <= '1';
                       jump <= '0';
                       alu_op <= "100";
                       mem_write <= '0';
                       mem_to_reg <= '0';
                       reg_write <= '0';
       when "101" => --ANDI
                       reg_dst <= '0';
                       ext_op <= '0';
                       alu_src <= '1';
                       branch <= '0';
                       jump <= '0';
                       alu_op <= "101";
                       mem_write <= '0';
                       mem_to_reg <= '0';
                       reg_write <= '1';          
       when "110" => --ORI
                       reg_dst <= '0';
                       ext_op <= '1';
                       alu_src <= '1';
                       branch <= '0';
                       jump <= '0';
                       alu_op <= "110";
                       mem_write <= '0';
                       mem_to_reg <= '0';
                       reg_write <= '1';             
       when "111" => --JUMP
                       reg_dst <= '0';
                       ext_op <= '0'; 
                       alu_src <= '0';
                       branch <= '0';
                       jump <= '1';
                       alu_op <= "111";
                       mem_write <= '0';
                       mem_to_reg <= '0';
                       reg_write <= '0';     
        end case;        
    end process;
end Behavioral;
