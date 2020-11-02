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
  signal Forward_RT_Result_MEM : std_logic_vector(31 downto 0);
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

  -- Forwarding unit signals
  signal Forward_RS : std_logic_vector(1 downto 0);
  signal Forward_RT : std_logic_vector(1 downto 0);

  -- Result of the RS and RT Multiplexers (Forwarding)
  signal Forward_RS_Result : std_logic_vector(31 downto 0);
  signal Forward_RT_Result : std_logic_vector(31 downto 0);

  -- Hazard unit signal
  signal Hazard : std_logic;

  -- Enable Pc
  signal enable_PC : std_logic; 

  -- Auxiliar signals for control unit
  signal Ctrl_Jump_aux : std_logic;
  signal Ctrl_Branch_aux : std_logic;
  signal Ctrl_MemtoReg_aux : std_logic;
  signal Ctrl_MemWrite_aux : std_logic;
  signal Ctrl_MemRead_aux : std_logic;
  signal Ctrl_ALUSrc_aux : std_logic;
  signal Ctrl_ALUOp_aux : std_logic_vector(2 downto 0);
  signal Ctrl_RegWrite_aux : std_logic;
  signal Ctrl_RegDest_aux : std_logic;    

begin

  Addr_Jump <= PC_plus4_MEM(31 downto 28) & InstructionMEM(25 downto 0) & "00";

  desition_Branch <= Addr_Branch_MEM when Regs_eq_branch = '1' else
                    PC_plus4;

  PC_next <= desition_Branch when Ctrl_Jump_MEM = '0' else
             Addr_Jump;     

  PC_reg_proc: process(Clk, Reset, enable_PC, PC_next)
  begin
    if Reset = '1' then
      PC_reg <= (others => '0');
    elsif rising_edge(Clk) and enable_PC = '1' then
      PC_reg <= PC_next;
    end if;
  end process;

  PC_plus4    <= PC_reg + 4;
  IAddr       <= PC_reg;

  Instruction <= x"04000000" when IDataIn = x"00000000" else
                IDataIn; -- nop

  -- If it is branch, stall the pc
  --enable_PC <= '0' when Instruction(31 downto 26) = "000100" else '1'

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

  -- Hazard unit
  Hazard <= '1' when (Ctrl_MemRead_EX = '1' and ((reg_RT_EX = reg_RS) or (reg_RT_EX = reg_RT)))
                                    -- and (InstructionID(31 downto 26) = "100011") -- Only for lw
                else '0';

  -- Changing enable signals
  enable_IF_ID <= '0' when Hazard = '1' else '1';
  enable_PC <= '0' when Hazard = '1' else '1';

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

  -- 'Multiplexer' after control unit and hazard detection unit
  Ctrl_Jump_aux <= '0' when Hazard = '1' else Ctrl_Jump;
  Ctrl_Branch_aux <= '0' when Hazard = '1' else Ctrl_Branch;
  Ctrl_MemtoReg_aux <= '0' when Hazard = '1' else Ctrl_MemtoReg;
  Ctrl_MemWrite_aux <= '0' when Hazard = '1' else Ctrl_MemWrite;
  Ctrl_MemRead_aux <= '0' when Hazard = '1' else Ctrl_MemRead;
  Ctrl_ALUSrc_aux <= '0' when Hazard = '1' else Ctrl_ALUSrc;
  Ctrl_ALUOp_aux <= "000" when Hazard = '1' else Ctrl_ALUOp;
  Ctrl_RegWrite_aux <= '0' when Hazard = '1' else Ctrl_RegWrite;
  Ctrl_RegDest_aux <= '0' when Hazard = '1' else Ctrl_RegDest;

  R15_0Extended <= x"FFFF" & InstructionID(15 downto 0) when InstructionID(15)='1' else
                  x"0000" & InstructionID(15 downto 0);

  -- If it is branch, stall the IF_ID register
  enable_PC <= '1';
  enable_IF_ID <= '1';
 -- enable_PC <= '0' when Instruction(31 downto 26) = "000100" else '1';
 -- enable_IF_ID <= '0' when Instruction(31 downto 26) = "000100" else '1';

  Decode_Execute: process(Clk, Reset, enable_ID_EX, Ctrl_Jump_aux, Ctrl_Branch_aux, Ctrl_MemToReg_aux,
                          Ctrl_MemWrite_aux, Ctrl_MemRead_aux, Ctrl_ALUSrc_aux, Ctrl_ALUOP_aux, Ctrl_RegWrite_aux,
                          Ctrl_RegDest_aux, PC_plus4_ID, reg_RS, reg_RT, R15_0Extended, InstructionID)
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
      Ctrl_Jump_EX <= Ctrl_Jump_aux;
      Ctrl_Branch_EX <= Ctrl_Branch_aux;
      Ctrl_MemToReg_EX <= Ctrl_MemToReg_aux;
      Ctrl_MemWrite_EX <= Ctrl_MemWrite_aux;
      Ctrl_MemRead_EX <= Ctrl_MemRead_aux;
      Ctrl_ALUSrc_EX <= Ctrl_ALUSrc_aux;
      Ctrl_ALUOP_EX <= Ctrl_ALUOP_aux;
      Ctrl_RegWrite_EX <= Ctrl_RegWrite_aux;
      Ctrl_RegDest_EX <= Ctrl_RegDest_aux;
      PC_plus4_EX <= PC_plus4_ID;
      reg_RS_EX <= reg_RS;
      reg_RT_EX <= reg_RT;
      R15_0EX <= R15_0Extended;
      R20_16 <= InstructionID(20 downto 16);
      R15_11 <= InstructionID(15 downto 11);
      InstructionEX <= InstructionID;
    end if;
  end process;

  -- Forwarding unit

  Forward_RS <= "10" when (Ctrl_RegWrite_MEM = '1' and reg_RD_MEM /= "00000" and reg_RD_MEM = InstructionEX(25 downto 21)) else -- Forwarding in the stage MEM (RS)
                "01" when (Ctrl_RegWrite_WB = '1' and reg_RD_WB /= "00000" and reg_RD_WB = InstructionEX(25 downto 21)) else -- Forwarding in the stage WB (RS)
                "00";

  Forward_RT <= "10" when (Ctrl_RegWrite_MEM = '1' and reg_RD_MEM /= "00000" and reg_RD_MEM = InstructionEX(20 downto 16)) else -- Forwarding in the stage MEM (RT)
                "01" when (Ctrl_RegWrite_WB = '1' and reg_RD_WB /= "00000" and reg_RD_WB = InstructionEX(20 downto 16)) else -- Forwarding in the stage WB (RT)
                "00";  

  -- Multiplexer for RS (forwarding unit)
  Forward_RS_Result <= reg_RS_EX when Forward_RS = "00" else 
                       reg_RD_Data when Forward_RS = "01" else
                       Alu_res_MEM;

  -- Multiplexer for RT (forwarding unit)
  Forward_RT_Result <= reg_RT_EX when Forward_RT = "00" else 
                       reg_RD_Data when Forward_RT = "01" else
                       Alu_res_MEM;
                         
  Addr_Branch    <= PC_plus4_EX + ( R15_0EX(29 downto 0) & "00");
  Alu_Op2        <= Forward_RT_Result when Ctrl_ALUSrc_EX = '0' else R15_0EX;

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
    OpA     => Forward_RS_Result,
    OpB     => Alu_Op2,
    Control => AluControl,
    Result  => Alu_Res,
    Zflag   => ALU_Igual
  );
  
  reg_RD     <= R20_16 when Ctrl_RegDest_EX = '0' else R15_11;

    -- If it is branch, stall the registers
    --enable_PC <= '0' when Instruction(31 downto 26) = "000100" else '1';
    --enable_IF_ID <= '0' when Instruction(31 downto 26) = "000100" else '1';
    --enable_ID_EX <= '0' when Instruction(31 downto 26) = "000100" else '1';

  Execute_Mem: process(Clk, Reset, enable_EX_MEM, Ctrl_Jump_EX, Ctrl_Branch_EX, Ctrl_MemToReg_EX, 
                       Ctrl_MemWrite_EX, Ctrl_RegWrite_EX, Ctrl_RegDest_EX, Ctrl_MemRead_EX, 
                       Addr_Branch, ALU_Igual, Alu_Res, Forward_RT_Result, reg_RD, PC_plus4_EX, InstructionEX)
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
      Forward_RT_Result_MEM <= (others => '0');
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
      Forward_RT_Result_MEM <= Forward_RT_Result;
      reg_RD_MEM <= reg_RD;
      PC_plus4_MEM <= PC_plus4_EX;
      InstructionMEM <= InstructionEX;
    end if;
  end process;
  enable_EX_MEM <= '1';

  Regs_eq_branch <= '1' when (ALU_Igual_MEM = '1' and Ctrl_Branch_MEM = '1') else
                    '0';
                    
  DAddr      <= Alu_res_MEM;
  DDataOut   <= Forward_RT_Result_MEM;
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
