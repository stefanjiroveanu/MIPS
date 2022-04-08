----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/15/2022 06:25:15 PM
-- Design Name: 
-- Module Name: env - Behavioral
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

entity if_env is
    Port( jmp_address : in std_logic_vector(15 downto 0);
          b_address : in std_logic_vector(15 downto 0);
          jmp : in std_logic;
          pcsrc : in std_logic;
          pc4 : out std_logic_vector(15 downto 0);
          instruction : out std_logic_vector(15 downto 0);
          en : in std_logic;
          res : in std_logic;
          clk : in std_logic);
end if_env;

architecture Behavioral of if_env is
---------ROM-MEMORY----------
type rom is array(0 to 255) of std_logic_vector(15 downto 0);
signal rom_memory : rom := (
                             --b"000_000_001_001_0_000",
                             b"000_000_000_001_0_000", -- 0 --seteaza contorul la 0  --0010
                             b"001_000_100_0000100", -- 1 -- se salveaza in registrul numarul 4, valoarea 10 --300A
                             --b"000_100_001_001_0_000",
                             --b"001_000_001_0000000",
                             --b"000_000_000_010_0_000", -- 2 -- se initialeaza indexul de memorie 0020 
                             b"000_000_000_101_0_000", -- 3 -- registrul ce contine suma este 0 0050
                             b"100_001_100_0000100", -- 4 -- comparam registrul 1 cu registrul 4,iesi din loop 8605
                             b"010_001_011_0000000", -- 5 -- lw la adresa 3 a registrului 1 4980
                             b"000_101_011_101_0_000", -- 6 -- se aduna la suma elementul din registrul 3  15D0
                             --b"001_010_010_0000100", -- 7 -- ne ducem la urmatorul element din sir  2904
                             b"001_001_001_0000001", -- 8 -- adunam 1 la index  2481
                             b"111_0000000000011", -- 0 -- jmp E004 
                             b"000_000_101_101_1_010", -- 2 -- inmultesc cu 2 suma 145A
                             b"011_000_101_0010100", -- 10 -- salvam in memorie la adresa 20 rezultatul  6294
                             
--                             b"000_010_011_001_0_001", -- 1 --sub
--                             b"000_000_100_001_1_010", -- 2 --sll
--                             b"000_000_100_001_1_011", -- 3 --srl
--                             b"000_010_011_001_0_100", -- 4 --and
--                             b"000_010_011_001_0_101", -- 5 --or
--                             b"000_011_010_001_0_110", -- 6 --xor
--                             b"000_011_010_001_0_111", -- 7 --sllv
                              
--                             b"001_011_010_0000001", -- 8 -- addi
--                             b"010_011_010_0000001", -- 9 -- lw
--                             b"011_011_010_0000001", -- 10 -- sw
--                             b"100_011_010_0000001", -- 11 -- beq
--                             b"101_011_010_0000001", -- 12 -- andi
--                             b"110_011_010_0000001", -- 13 -- ori
                             
                            --b"111_0000000000011", -- 14 -- jmp
                             others => "000000000000");
signal PCounter: std_logic_vector(15 downto 0):= x"0000";
signal BranchMUXOut: std_logic_vector(15 downto 0 ) := x"0000"; -- can be pc+1 or branch address
signal JumpMUXOut: std_logic_vector(15 downto 0) := x"0000"; -- can be branchMuxOut or jump address
signal PCPlus1: std_logic_vector(15 downto 0) := x"0000";
begin

pc_counter : process(clk, res, PCounter)
begin
    if res = '1' then
        PCounter <= x"0000";
    end if;
        if rising_edge(clk) then
            if en = '1' then 
                PCounter <= JumpMUXOut;
            end if;
        end if;
end process;

mux1 : process(pcsrc, b_address, PCPlus1)
begin
    case pcsrc is
    when '0' => BranchMUXOut <= PCPlus1;
    when '1' => BranchMUXOut <= b_address;
    end case;
end process;

mux2 : process(BranchMUXOut, jmp_address, jmp)
begin
    case jmp is
    when '0' => JumpMUXOut <= BranchMUXOut;
    when '1' => JumpMUXOut <= jmp_address;
    end case;
end process;

instruction <= rom_memory(conv_integer(PCounter));

PCPlus1 <= PCounter + '1';
pc4 <= PCPlus1;

end Behavioral;
