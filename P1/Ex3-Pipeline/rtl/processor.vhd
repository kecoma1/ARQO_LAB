--------------------------------------------------------------------------------
-- Procesador MIPS con pipeline curso Arquitectura 2020-2021
--
-- Kevin de la Coba Malam   (kevin.coba@estudiante.uam.es)
-- Miguel Herrera Martínez  (miguel.herreramartinez@estudiante.uam.es)
-- Group 1391, pair 2
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity processor is
   port(
      Clk         : in  std_logic; -- Reloj activo en flanco subida
      Reset       : in  std_logic; -- Reset asincrono activo nivel alto
      -- Instruction memory
      IAddr      : out std_logic_vector(31 downto 0); -- Direccion Instr
      IDataIn    : in  std_logic_vector(31 downto 0); -- Instruccion leida
      -- Data memory
      DAddr      : out std_logic_vector(31 downto 0); -- Direccion
      DRdEn      : out std_logic;                     -- Habilitacion lectura
      DWrEn      : out std_logic;                     -- Habilitacion escritura
      DDataOut   : out std_logic_vector(31 downto 0); -- Dato escrito
      DDataIn    : in  std_logic_vector(31 downto 0)  -- Dato leido
   );
end processor;

architecture rtl of processor is

  component alu
    port(
      OpA : in std_logic_vector (31 downto 0);
      OpB : in std_logic_vector (31 downto 0);
      Control : in std_logic_vector (3 downto 0);
      Result : out std_logic_vector (31 downto 0);
      Zflag : out std_logic
    );
  end component;

  component reg_bank
     port (
        Clk   : in std_logic; -- Reloj activo en flanco de subida
        Reset : in std_logic; -- Reset as�ncrono a nivel alto
        A1    : in std_logic_vector(4 downto 0);   -- Direcci�n para el puerto Rd1
        Rd1   : out std_logic_vector(31 downto 0); -- Dato del puerto Rd1
        A2    : in std_logic_vector(4 downto 0);   -- Direcci�n para el puerto Rd2
        Rd2   : out std_logic_vector(31 downto 0); -- Dato del puerto Rd2
        A3    : in std_logic_vector(4 downto 0);   -- Direcci�n para el puerto Wd3
        Wd3   : in std_logic_vector(31 downto 0);  -- Dato de entrada Wd3
        We3   : in std_logic -- Habilitaci�n de la escritura de Wd3
     );
  end component reg_bank;

  component control_unit
     port (
        -- Entrada = codigo de operacion en la instruccion:
        OpCode   : in  std_logic_vector (5 downto 0);
        -- Seniales para el PC
        Jump : out std_logic;
        Branch   : out  std_logic; -- 1 = Ejecutandose instruccion branch
        -- Seniales relativas a la memoria
        MemToReg : out  std_logic; -- 1 = Escribir en registro la salida de la mem.
        MemWrite : out  std_logic; -- Escribir la memoria
        MemRead  : out  std_logic; -- Leer la memoria
        -- Seniales para la ALU
        ALUSrc   : out  std_logic;                     -- 0 = oper.B es registro, 1 = es valor inm.
        ALUOp    : out  std_logic_vector (2 downto 0); -- Tipo operacion para control de la ALU
        -- Seniales para el GPR
        RegWrite : out  std_logic; -- 1=Escribir registro
        RegDst   : out  std_logic  -- 0=Reg. destino es rt, 1=rd
     );
  end component;

  component alu_control is
   port (
      -- Entradas:
      ALUOp  : in std_logic_vector (2 downto 0); -- Codigo de control desde la unidad de control
      Funct  : in std_logic_vector (5 downto 0); -- Campo "funct" de la instruccion
      -- Salida de control para la ALU:
      ALUControl : out std_logic_vector (3 downto 0) -- Define operacion a ejecutar por la ALU
   );
 end component alu_control;

  signal Alu_Op2      : std_logic_vector(31 downto 0);
  signal ALU_Igual    : std_logic;
  signal AluControl   : std_logic_vector(3 downto 0);
  signal reg_RD_data  : std_logic_vector(31 downto 0);
  signal reg_RD       : std_logic_vector(4 downto 0);

  signal Regs_eq_branch : std_logic;
  signal PC_next        : std_logic_vector(31 downto 0);
  signal PC_reg         : std_logic_vector(31 downto 0);
  signal PC_plus4       : std_logic_vector(31 downto 0);

  signal Instruction    : std_logic_vector(31 downto 0); -- La instrucción desde lamem de instr
  signal Inm_ext        : std_logic_vector(31 downto 0); --Lparte baja de la instrucción extendida de signo
  signal reg_RS, reg_RT : std_logic_vector(31 downto 0);

  signal dataIn_Mem     : std_logic_vector(31 downto 0); --From Data Memory
  signal Addr_Branch    : std_logic_vector(31 downto 0);

  signal Ctrl_Jump, Ctrl_Branch, Ctrl_MemWrite, Ctrl_MemRead,  Ctrl_ALUSrc, Ctrl_RegDest, Ctrl_MemToReg, Ctrl_RegWrite : std_logic;
  signal Ctrl_ALUOP     : std_logic_vector(2 downto 0);

  signal Addr_Jump      : std_logic_vector(31 downto 0);
  signal desition_Branch : std_logic_vector(31 downto 0);
  signal Alu_Res        : std_logic_vector(31 downto 0);

  -- These are the signals for the pipeline processor registers

  -- Instruction fetch and decode register
  signal PC_plus4_ID : std_logic_vector(31 downto 0);
  signal InstructionID : std_logic_vector(31 downto 0);
  signal enable_IF_ID : std_logic;
  
  -- Instruction decode and execution register
  signal Ctrl_Jump_EX : std_logic;
  signal Ctrl_Branch_EX : std_logic;
  signal Ctrl_MemToReg_EX : std_logic;
  signal Ctrl_MemWrite_EX : std_logic;
  signal Ctrl_MemRead_EX : std_logic;
  signal Ctrl_ALUSrc_EX : std_logic;
  signal Ctrl_ALUOP_EX : std_logic_vector(2 downto 0);
  signal Ctrl_RegWrite_EX : std_logic;
  signal Ctrl_RegDest_EX : std_logic;
  signal PC_plus4_EX  : std_logic_vector(31 downto 0);
  signal reg_RS_EX : std_logic_vector(31 downto 0);
  signal reg_RT_EX : std_logic_vector(31 downto 0);
  signal R15_0EX : std_logic_vector(31 downto 0);
  signal R20_16 : std_logic_vector(4 downto 0);
  signal R15_11 : std_logic_vector(4 downto 0);
  signal R15_0Extended : std_logic_vector(31 downto 0);
  signal enable_ID_EX : std_logic;
  signal InstructionEX : std_logic_vector(31 downto 0);

  -- Execution and memory register
  signal Ctrl_Jump_MEM : std_logic;
  signal Ctrl_Branch_MEM  : std_logic;
  signal Ctrl_MemToReg_MEM : std_logic;
  signal Ctrl_MemWrite_MEM : std_logic;
  signal Ctrl_RegWrite_MEM : std_logic;
  signal Ctrl_RegDest_MEM : std_logic;
  signal Ctrl_MemRead_MEM : std_logic;
  signal Addr_Branch_MEM : std_logic_vector(31 downto 0);
  signal ALU_Igual_MEM : std_logic;
  signal Alu_res_MEM : std_logic_vector(31 downto 0);
  signal reg_RD_MEM : std_logic_vector(4 downto 0);
  signal reg_RT_MEM : std_logic_vector(31 downto 0);
  signal enable_EX_MEM : std_logic;
  signal PC_plus4_MEM :  std_logic_vector(31 downto 0);
  signal InstructionMEM : std_logic_vector(31 downto 0);

  -- Memory and write back register
  signal Ctrl_RegWrite_WB : std_logic;
  signal Ctrl_MemToReg_WB : std_logic;
  signal dataIn_Mem_WB : std_logic_vector(31 downto 0);
  signal Alu_res_WB : std_logic_vector(31 downto 0);
  signal reg_RD_WB : std_logic_vector(4 downto 0);
  signal enable_MEM_WB : std_logic;

begin

  Addr_Jump <= PC_plus4_MEM(31 downto 28) & InstructionMEM(25 downto 0) & "00";

  desition_Branch <= Addr_Branch_MEM when Regs_eq_branch = '1' else
                    PC_plus4;

  PC_next <= desition_Branch when Ctrl_Jump_MEM = '0' else
             Addr_Jump;     

  PC_reg_proc: process(Clk, Reset)
  begin
    if Reset = '1' then
      PC_reg <= (others => '0');
    elsif rising_edge(Clk) then
      PC_reg <= PC_next;
    end if;
  end process;

  PC_plus4    <= PC_reg + 4;
  IAddr       <= PC_reg;

  Instruction <= x"04000000" when IDataIn = x"00000000" else
                IDataIn; -- nop

  Fetch_Decode: process(Clk, Reset, enable_IF_ID, PC_plus4, Instruction)
  begin
    if reset = '1' then
      PC_plus4_ID <= (others => '0');
      InstructionID <= (others => '0');
    elsif rising_edge(Clk) and enable_IF_ID = '1' then
      PC_plus4_ID <= PC_plus4;
      InstructionID <= Instruction;
    end if;
  end process;
  enable_IF_ID <= '1'; 

  RegsMIPS : reg_bank
  port map (
    Clk   => Clk,
    Reset => Reset,
    A1    => InstructionID(25 downto 21),
    Rd1   => reg_RS,
    A2    => InstructionID(20 downto 16),
    Rd2   => reg_RT,
    A3    => reg_RD_WB,
    Wd3   => reg_RD_data,
    We3   => Ctrl_RegWrite_WB
  );

  UnidadControl : control_unit
  port map(
    OpCode   => InstructionID(31 downto 26),
    -- Señales para el PC
    Jump   => Ctrl_Jump,
    Branch   => Ctrl_Branch,
    -- Señales para la memoria
    MemToReg => Ctrl_MemToReg,
    MemWrite => Ctrl_MemWrite,
    MemRead  => Ctrl_MemRead,
    -- Señales para la ALU
    ALUSrc   => Ctrl_ALUSrc,
    ALUOP    => Ctrl_ALUOP,
    -- Señales para el GPR
    RegWrite => Ctrl_RegWrite,
    RegDst   => Ctrl_RegDest
  ); 

  R15_0Extended <= x"FFFF" & InstructionID(15 downto 0) when InstructionID(15)='1' else
                  x"0000" & InstructionID(15 downto 0);

  Decode_Execute: process(Clk, Reset, enable_ID_EX, Ctrl_Jump, Ctrl_Branch, Ctrl_MemToReg,
                          Ctrl_MemWrite, Ctrl_MemRead, Ctrl_ALUSrc, Ctrl_ALUOP, Ctrl_RegWrite,
                          Ctrl_RegDest, PC_plus4_ID, Reg_RS, reg_RT, R15_0Extended, InstructionID)
  begin
    if reset = '1' then
      Ctrl_Jump_EX <= '0';
      Ctrl_Branch_EX <= '0';
      Ctrl_MemToReg_EX <= '0';
      Ctrl_MemWrite_EX <= '0';
      Ctrl_MemRead_EX <= '0';
      Ctrl_ALUSrc_EX <= '0';
      Ctrl_ALUOP_EX <= (others => '0');
      Ctrl_RegWrite_EX <= '0';
      Ctrl_RegDest_EX <= '0';
      PC_plus4_EX <= (others => '0');
      reg_RS_EX <= (others => '0');
      reg_RT_EX <= (others => '0');
      R15_0EX <= (others => '0');
      R20_16 <= (others => '0');
      R15_11 <= (others => '0');
      InstructionEX <= (others => '0');
    elsif rising_edge(Clk) and enable_ID_EX = '1' then
      Ctrl_Jump_EX <= Ctrl_Jump;
      Ctrl_Branch_EX <= Ctrl_Branch;
      Ctrl_MemToReg_EX <= Ctrl_MemToReg;
      Ctrl_MemWrite_EX <= Ctrl_MemWrite;
      Ctrl_MemRead_EX <= Ctrl_MemRead;
      Ctrl_ALUSrc_EX <= Ctrl_ALUSrc;
      Ctrl_ALUOP_EX <= Ctrl_ALUOP;
      Ctrl_RegWrite_EX <= Ctrl_RegWrite;
      Ctrl_RegDest_EX <= Ctrl_RegDest;
      PC_plus4_EX <= PC_plus4_ID;
      reg_RS_EX <= Reg_RS;
      reg_RT_EX <= reg_RT;
      R15_0EX <= R15_0Extended;
      R20_16 <= InstructionID(20 downto 16);
      R15_11 <= InstructionID(15 downto 11);
      InstructionEX <= InstructionID;
    end if;
  end process;
  enable_ID_EX <= '1';
  
  Addr_Branch    <= PC_plus4_EX + ( R15_0EX(29 downto 0) & "00");
  Alu_Op2        <= reg_RT_EX when Ctrl_ALUSrc_EX = '0' else R15_0EX;

  Alu_control_i: alu_control
  port map(
    -- Entradas:
    ALUOp  => Ctrl_ALUOP_EX, -- Codigo de control desde la unidad de control
    Funct  => R15_0EX(5 downto 0), -- Campo "funct" de la instruccion
    -- Salida de control para la ALU:
    ALUControl => AluControl -- Define operacion a ejecutar por la ALU
  );
    
  Alu_MIPS : alu
    port map (
    OpA     => reg_RS_EX,
    OpB     => Alu_Op2,
    Control => AluControl,
    Result  => Alu_Res,
    Zflag   => ALU_Igual
  );
  
  reg_RD     <= R20_16 when Ctrl_RegDest_EX = '0' else R15_11;

  Execute_Mem: process(Clk, Reset, enable_EX_MEM, Ctrl_Jump_EX, Ctrl_Branch_EX, Ctrl_MemToReg_EX, 
                       Ctrl_MemWrite_EX, Ctrl_RegWrite_EX, Ctrl_RegDest_EX, Ctrl_MemRead_EX, 
                       Addr_Branch, ALU_Igual, Alu_Res, reg_RT_EX, reg_RD, PC_plus4_EX, InstructionEX)
  begin
    if reset = '1' then
      PC_plus4_MEM <= (others => '0');
      Ctrl_Jump_MEM <= '0';
      Ctrl_Branch_MEM <= '0';
      Ctrl_MemToReg_MEM <= '0';
      Ctrl_MemWrite_MEM <= '0';
      Ctrl_RegWrite_MEM <= '0';
      Ctrl_RegDest_MEM <= '0';
      Ctrl_MemRead_MEM <= '0';
      Addr_Branch_MEM <= (others => '0');
      ALU_Igual_MEM <= '0';
      Alu_res_MEM <= (others => '0');
      reg_RD_MEM <= (others => '0');
      reg_RT_MEM <= (others => '0');
      InstructionMEM <= (others => '0');
    elsif rising_edge(Clk) and enable_EX_MEM = '1' then
      Ctrl_Jump_MEM <= Ctrl_Jump_EX;
      Ctrl_Branch_MEM <= Ctrl_Branch_EX;
      Ctrl_MemToReg_MEM <= Ctrl_MemToReg_EX;
      Ctrl_MemWrite_MEM <= Ctrl_MemWrite_EX;
      Ctrl_RegWrite_MEM <= Ctrl_RegWrite_EX;
      Ctrl_RegDest_MEM <= Ctrl_RegDest_EX;
      Ctrl_MemRead_MEM <= Ctrl_MemRead_EX;
      Addr_Branch_MEM <= Addr_Branch;
      ALU_Igual_MEM <= ALU_Igual;
      Alu_res_MEM <= Alu_Res;
      reg_RT_MEM <= reg_RT_EX;
      reg_RD_MEM <= reg_RD;
      PC_plus4_MEM <= PC_plus4_EX;
      InstructionMEM <= InstructionEX;
    end if;
  end process;
  enable_EX_MEM <= '1';

  Regs_eq_branch <= '1' when (ALU_Igual_MEM = '1' and Ctrl_Branch_MEM = '1') else
                    '0';
                    
  DAddr      <= Alu_res_MEM;
  DDataOut   <= reg_RT_MEM;
  DWrEn      <= Ctrl_MemWrite_MEM;
  dRdEn      <= Ctrl_MemRead_MEM;
  dataIn_Mem <= DDataIn;

  Mem_Wb: process(Clk, Reset, enable_MEM_WB, Ctrl_RegWrite_MEM, Ctrl_MemToReg_MEM, dataIn_Mem, Alu_res_MEM, reg_RD_MEM)
  begin
    if reset = '1' then
      Ctrl_RegWrite_WB <= '0';
      Ctrl_MemToReg_WB <= '0';
      dataIn_Mem_WB <= (others => '0');
      Alu_res_WB <= (others => '0');
      reg_RD_WB <= (others => '0');
    elsif rising_edge(Clk) and enable_MEM_WB = '1' then
      Ctrl_RegWrite_WB <= Ctrl_RegWrite_MEM;
      Ctrl_MemToReg_WB <= Ctrl_MemToReg_MEM;
      dataIn_Mem_WB <= dataIn_Mem;
      Alu_res_WB <= Alu_res_MEM;
      reg_RD_WB <= reg_RD_MEM;
    end if;
  end process;
  enable_MEM_WB <= '1';  

  reg_RD_data <= dataIn_Mem_WB when Ctrl_MemToReg_WB = '1' else Alu_res_WB;

end architecture;
