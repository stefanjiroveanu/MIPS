----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2022 09:59:52 PM
-- Design Name: 
-- Module Name: MEM - Behavioral
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

entity MEM is
    Port ( clk : in std_logic;
           mem_write : in STD_LOGIC;
           alu_res : in STD_LOGIC_VECTOR (15 downto 0);
           write_data : in STD_LOGIC_VECTOR (15 downto 0);
           alu_res_out : out STD_LOGIC_VECTOR (15 downto 0);
           mem_data : out STD_LOGIC_VECTOR (15 downto 0));
end MEM;

architecture Behavioral of MEM is
type ram_type is array (0 to 255) of std_logic_vector(15 downto 0);

signal ram : ram_type :=(
                            X"0001",
                            X"0002",
                            X"0003",
                            X"0004",
                            X"0005",
                            X"0006",
                            X"0007",
                            X"0008",
                            
                            others =>X"0000"
                            );
begin
alu_res_out <= alu_res;
    process(clk)
    begin
    if rising_edge(clk) then
        if(mem_write = '1') then
            ram(conv_integer(alu_res(6 downto 0))) <= write_data;
        end if;
    end if;
    mem_data <= ram(conv_integer(alu_res(6 downto 0)));
    end process;

end Behavioral;
