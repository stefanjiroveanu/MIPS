----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/16/2022 09:03:25 PM
-- Design Name: 
-- Module Name: test_new - Behavioral
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

entity test_env is
    Port (clk : in STD_LOGIC;
    btn : in STD_LOGIC_VECTOR(4 downto 0);
    sw : in STD_LOGIC_VECTOR(15 downto 0);
    led : out STD_LOGIC_VECTOR(15 downto 0);
    an : out STD_LOGIC_VECTOR(3 downto 0);
    cat : out STD_LOGIC_VECTOR(6 downto 0));
end test_env;

architecture Structural of test_env is
type ROM is array(0 to 255) of std_logic_vector(15 downto 0);
signal rom_memory : ROM := ( x"0001", x"0010", x"0011", x"0100", x"0101", x"0110", x"0111", x"1000", others=>x"0000"); 
signal enable : std_logic;
signal counter: std_logic_vector(15 downto 0) := x"0000";

signal semnal : std_logic_vector(15 downto 0);

signal RD1 : std_logic_vector(15 downto 0) := x"0001";
signal RD2 : std_logic_vector(15 downto 0) := x"0000";
signal reset : std_logic;
signal instruction : std_logic_vector(15 downto 0);
signal pc4 : std_logic_vector(15 downto 0);
signal jmp_address : std_logic_vector(15 downto 0);
signal jmp : std_logic;
signal pcsrc : std_logic;

signal wd : std_logic_vector(15 downto 0);
signal regdst : std_logic;
signal regwrite : std_logic;
signal ext_imm : STD_LOGIC_VECTOR (15 downto 0);
signal ext_op : STD_LOGIC;
signal func : STD_LOGIC_VECTOR (2 downto 0);
signal sa : STD_LOGIC;

signal zero : STD_LOGIC;
signal alures : std_logic_vector(15 downto 0);
signal alu_src : std_logic;
signal alu_op : std_logic_vector(0 to 2);

signal mem_to_reg: std_logic;
signal mem_write: std_logic;

signal alu_res_in: std_logic_vector(15 downto 0);
signal mem_data: std_logic_vector(15 downto 0);
signal branch_address : std_logic_vector(15 downto 0);
signal branch : std_logic;
signal rw : std_logic;


component MPG is
    Port (clk : in STD_LOGIC;
          btn : in STD_LOGIC;
          enable : out STD_LOGIC);
end component;

component SSDComponent is
     Port (Digit : in std_logic_vector(15 downto 0);
           clk : in std_logic;
           cat : out std_logic_vector(6 downto 0);
           an : out std_logic_vector(3 downto 0));
end component;

component if_env is
    Port( jmp_address : in std_logic_vector(15 downto 0);
          b_address : in std_logic_vector(15 downto 0);
          jmp : in std_logic;
          pcsrc : in std_logic;
          pc4 : out std_logic_vector(15 downto 0);
          instruction : out std_logic_vector(15 downto 0);
          en : in std_logic;
          res : in std_logic;
          clk : in std_logic);
end component;

component ID is
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
end component;

component ex_unity is
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
           
end component;

component Control_Unit is
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
end component;

component MEM is
    Port ( clk : in std_logic;
           mem_write : in STD_LOGIC;
           alu_res : in STD_LOGIC_VECTOR (15 downto 0);
           write_data : in STD_LOGIC_VECTOR (15 downto 0);
           alu_res_out : out STD_LOGIC_VECTOR (15 downto 0);
           mem_data : out STD_LOGIC_VECTOR (15 downto 0));
end component;

begin
process(sw(7 downto 5))
begin
    case sw(7 downto 5) is
        when "000" => semnal <= instruction;
        when "001" => semnal <= pc4;
        when "010" => semnal <= RD1;
        when "011" => semnal <= RD2;
        when "100" => semnal <= ext_imm;
        when "101" => semnal <= alu_res_in;
        when "110" => semnal <= mem_data;
        when "111" => semnal <= wd;
    end case;
end process;
    c1: MPG port map(clk=>clk, btn=>btn(0), enable=>enable);
    c4: MPG port map(clk=>clk, btn=>btn(1), enable=>reset);
    c2: SSDComponent port map(Digit=>semnal, clk=>clk, cat=>cat, an=>an); 
    c3: if_env port map(
        jmp_address => jmp_address,
        b_address => branch_address,
        jmp => jmp,
        pcsrc => pcsrc,
        pc4 => pc4,
        instruction =>instruction,
        en => enable,
        res=>reset,
        clk=>clk);
    c5: id port map( 
        clk => clk,
        instr => instruction,
        wd => wd,
        regdst => regdst,
        regwrite => rw,
        RD1 => rd1,
        RD2 => rd2,
        ext_imm => ext_imm,
        ext_op => ext_op,
        func => func,
        sa => sa        
    );
    
    c6: ex_unity port map(
        RD1 => rd1,
        RD2 => rd2,
        sa => sa,
        ext_imm => ext_imm,
        func => func,
        zero => zero,
        alures => alures,
        pc => pc4,
        alu_src => alu_src,
        alu_op => alu_op,
        ba => branch_address
    );

    c7: Control_Unit port map(
        instr=>instruction(15 downto 13),
        reg_dst=>regdst,
        ext_op=>ext_op,
        alu_src=>alu_src,
        branch=>branch,
        jump=>jmp,
        alu_op=>alu_op,
        mem_write=>mem_write,
        mem_to_reg=>mem_to_reg,
        reg_write=>regwrite
    );

    c8 : MEM port map(
        clk => clk,
        mem_write => mem_write,
        alu_res => alu_res_in,
        write_data => rd2,
        mem_data => mem_data,
        alu_res_out => alures
    );
    rw <= regwrite and btn(1);
    wd <= alures when mem_to_reg = '0' else mem_data;
    pcsrc <= branch and zero;
    jmp_address <= "000" & instruction(12 downto 0);
 
    reset <= btn(2);
    enable <= btn(3);

led(15) <= regdst;
led(14) <= ext_op;
led(13) <= alu_src;
led(12) <= branch;
led(11) <= jmp;
led(10 downto 8) <= alu_op;
led(7) <= mem_write;
led(6) <= mem_to_reg;
led(5) <= regwrite;


end;

