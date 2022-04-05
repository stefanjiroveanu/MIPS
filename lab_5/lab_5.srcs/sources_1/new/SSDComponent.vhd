----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/22/2022 06:28:51 PM
-- Design Name: 
-- Module Name: SSDComponent - Behavioral
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

entity SSDComponent is
     Port (Digit : in std_logic_vector(15 downto 0);
           clk : in std_logic;
           cat : out std_logic_vector(6 downto 0);
           an : out std_logic_vector(3 downto 0));
end SSDComponent;

architecture Behavioral of SSDComponent is
signal count : std_logic_vector(15 downto 0) := x"0000";
signal digit_out_mux1 : std_logic_vector(3 downto 0) := "0000";
begin
    process(clk)
    begin
        if rising_edge(clk) then
        count <= count + 1;
        end if;
    end process;
    Mux1: process(Digit, count(15 downto 14))
    begin
        case count(15 downto 14) is
        when "00" => digit_out_mux1 <= Digit(3 downto 0);
        when "01" => digit_out_mux1 <= Digit(7 downto 4);
        when "10" => digit_out_mux1 <= Digit(11 downto 8);
        when "11" => digit_out_mux1 <= Digit(15 downto 12);
        end case;
    end process;
    Mux2:process(count(15 downto 14))
        begin
            case count(15 downto 14) is
            when "00" => an <= "1110";
            when "01" => an <= "1101";
            when "10" => an <= "1011";
            when "11" => an <= "0111";
            end case;
        end process;
        
        with digit_out_mux1 select
         cat<= "1111001" when "0001",   --1
         "0100100" when "0010",   --2
         "0110000" when "0011",   --3
         "0011001" when "0100",   --4
         "0010010" when "0101",   --5
         "0000010" when "0110",   --6
         "1111000" when "0111",   --7
         "0000000" when "1000",   --8
         "0010000" when "1001",   --9
         "0001000" when "1010",   --A
         "0000011" when "1011",   --b
         "1000110" when "1100",   --C
         "0100001" when "1101",   --d
         "0000110" when "1110",   --E
         "0001110" when "1111",   --F
         "1000000" when others;   --0
end Behavioral;
