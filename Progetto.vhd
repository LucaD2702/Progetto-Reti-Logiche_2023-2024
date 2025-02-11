--Luca De Nicola
--Cod. Persona: 10808901
--Prova Finale - Progetto di Reti Logiche 2023-2024


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity project_reti_logiche is
    port(
        i_clk   : in std_logic;
        i_rst   : in std_logic;
        i_start : in std_logic;
        i_add   : in std_logic_vector(15 downto 0);
        i_k     : in std_logic_vector(9 downto 0);
        
        o_done  : out std_logic;
        
        o_mem_addr : out std_logic_vector(15 downto 0);
        i_mem_data : in std_logic_vector(7 downto 0);
        o_mem_data : out std_logic_vector(7 downto 0);
        o_mem_we   : out std_logic;
        o_mem_en   : out std_logic
    );
end project_reti_logiche;

architecture project_reti_logiche_arch of project_reti_logiche is

    -- Define the states
    type state_type is (S0, S1, S2, S3, S4, S5, S6, S6_1, S7, S8, S9, S10, S11, DONE);
    signal curr_state : state_type;

    --Add register signal
    signal address      :   std_logic_vector(15 downto 0);
    signal add_limit    :   std_logic;
    signal add_en       :   std_logic;
    signal add_plus     :   std_logic;
    --K register signal
    signal stored_k     :   std_logic_vector(9 downto 0);
    signal k_temp       :   std_logic_vector(9 downto 0);
    signal k_end        :   std_logic;
    signal k_plus       :   std_logic;
    signal k_en         :   std_logic;
    --W register signal
    signal w_stored     :   std_logic_vector(7 downto 0);
    signal w_reg_en     :   std_logic;
    signal w_data       :   std_logic_vector(7 downto 0);
    signal is_zero      :   std_logic;
    --last W valid register signal
    signal last_w_stored    :   std_logic_vector(7 downto 0);
    signal w_last_en    :   std_logic;
    signal end_rst      :   std_logic;
    signal w_last       :   std_logic_vector(7 downto 0);
    --C register signal
    signal c_stored     :   std_logic_vector(7 downto 0);
    signal c_reg_en     :   std_logic;
    signal c_data       :   std_logic_vector(7 downto 0);
    --MUX signal
    signal SEL          :   std_logic;
    signal mux_en       :   std_logic;
    
begin

    StateProcess : process(i_clk, i_rst) is
    --Sequential Process
    begin
        if i_rst = '1' then
            curr_state <= S0;
        elsif rising_edge(i_clk) then
            case curr_state is
                when S0 =>
                    curr_state <= S1;
                when S1 =>
                    if i_start = '1' then
                        curr_state <= S2;
                    end if;
                when S2 =>
                    curr_state <= S3;
                when S3 =>
                    if add_limit = '1' or k_end = '1' then
                        curr_state <= DONE;
                    else
                        curr_state <= S4;
                    end if;
                when S4 =>
                    curr_state <= S5;
                when S5 =>
                    curr_state <= S6;
                when S6 =>
                    if is_zero = '1' then
                        curr_state <= S6_1;
                    else
                        curr_state <= S7;
                    end if;
                when S6_1 =>
                    curr_state <= S8;
                when S7   =>
                    curr_state <= S8;
                when S8    =>
                    curr_state <= S9;
                when S9   =>
                    if add_limit = '1' then
                        curr_state <= DONE;
                    else
                        curr_state <= S10;
                    end if;
                when S10    =>
                    curr_state <= S11;
                when S11   =>
                    curr_state <= S3;
                 when DONE =>
                    if i_start = '1' then
                        curr_state <= DONE;
                    else
                        curr_state <= S1;
                    end if;
            end case;
        end if;
    end process StateProcess;

    
    ControlProcess : process(curr_state) is
    --Combinational Process
    begin
        -- Default outputs
        o_done      <= '0';
        o_mem_we    <= '0';
        o_mem_en    <= '0';
        add_en      <= '0';
        add_plus    <= '0';
        k_en        <= '0';
        k_plus      <= '0';
        w_reg_en    <= '0';
        w_last_en   <= '0';
        c_reg_en    <= '0';
        end_rst     <= '0';
        mux_en      <= '0';
        SEL         <= '0';
    
        case curr_state is
    
            when S0 =>
                --nothing
            when S1 =>
                end_rst     <= '1';
            when S2 =>
                add_en      <= '1';
                k_en        <= '1';
            when S3 =>
                --wait check
            when S4 =>
                o_mem_we    <= '0';
                o_mem_en    <= '1';
            when S5 =>
                w_reg_en    <= '1';
            when S6 =>
                c_reg_en    <= '1';
            when S6_1 =>
                mux_en      <= '1';
                SEL         <= '0';
                o_mem_we    <= '1';
                o_mem_en    <= '1';
            when S7 =>
                w_last_en   <= '1';
            when S8 =>
                add_plus    <= '1';
            when S9 =>
                --check
            when S10 =>
                mux_en      <= '1';
                SEL         <= '1';
                o_mem_we    <= '1';
                o_mem_en    <= '1';
            when S11 =>
                add_plus    <= '1';
                k_plus      <= '1';
            when DONE =>
                o_done      <= '1';
        end case;
    end process ControlProcess;
    


--ADD_REGISTER:

    add_register_1 : process(i_clk, i_rst)
    -- Sequential process ADD_REGISTER
    begin
        if i_rst = '1' then
            address <= (others => '0');
        elsif rising_edge(i_clk) then
            if add_en = '1' then
                address <= i_add;
            elsif add_plus = '1' then
                address <= std_logic_vector(unsigned(address) + 1);
            end if;
        end if;
    end process add_register_1;
    

    add_register_2 : process(address, add_plus)
    -- Combinational process ADD_REGISTER
    begin
        add_limit <= '0';               --Default value
        if address = "1111111111111111" then
            add_limit <= '1';
        end if;
    end process add_register_2;
    
    -- Output ADD_REGISTER
    o_mem_addr <= address;



--K_REGISTER:

    k_register_1 : process(i_clk, i_rst)
    -- Sequential process K_REGISTER
    begin
        if i_rst = '1' then
            stored_k <= (others => '0');
        elsif rising_edge(i_clk) then
            if k_en = '1' then
                stored_k <= i_k;
            k_temp <= "0000000001"; --parte da 1
            end if;
        end if;
    end process k_register_1;
    
    
    k_register_2 : process(stored_k, k_plus)
    -- Combinational process K_REGISTER
    begin
        k_end <= '0';       --Default
        k_temp <= k_temp;   --Default

        if stored_k = "0000000000" then
            k_end <= '1';
        elsif k_temp = "1111111111" then
            k_end <= '1';
        elsif k_plus = '1' then
            if k_temp = stored_k then
                k_end <= '1';
            else
                k_end <= '0';
                k_temp <= std_logic_vector(unsigned(k_temp) + 1);
            end if;
        end if;
    end process k_register_2;
    
    
    
--W_REGISTER:

    w_register_1 : process(i_clk, i_rst)
    -- Sequential process W_REGISTER
    begin
        if i_rst = '1' then
            w_stored <= (others => '0');
        elsif rising_edge(i_clk) then
            if w_reg_en = '1' then
                w_stored <= i_mem_data;
            end if;
        end if;
    end process w_register_1;
    
    
    w_register_2 : process(w_stored)
    -- Combinational process W_REGISTER
    begin
        if w_stored = "00000000" then
            is_zero <= '1';
        else
            is_zero <= '0';
        end if;
    end process w_register_2;
    
    --Output W_REGITER
    w_data <= w_stored;



--LAST_W_VALID_REGISTER:

    last_reg : process(i_clk, i_rst)
        -- Sequential process LAST_W
    begin
        if i_rst = '1' then
            last_w_stored <= (others => '0');
        elsif rising_edge(i_clk) then
            if end_rst = '1' then
                last_w_stored <= (others => '0');
            else
                if w_last_en = '1' then
                    last_w_stored <= w_data;
                else
                    last_w_stored <= last_w_stored;
                end if;
            end if; 
        end if;
    end process last_reg;
    
    --Output LAST_W
    w_last <= last_w_stored;
    
    
    
--C_REGISTER:
    
    c_reg : process(i_clk, i_rst)
    -- Sequential process C_REGISTER
    begin
        if i_rst = '1' then
            c_stored <= (others => '0');
        elsif rising_edge(i_clk) then
            if end_rst = '1' then
                c_stored <= (others => '0');
            else
                if c_reg_en = '1' then
                    if is_zero = '0' then
                        c_stored <= "00011111";  -- Set to 31
                    elsif c_stored /= "00000000" then
                        c_stored <= std_logic_vector(unsigned(c_stored) - 1);
                    end if;
                 end if;
            end if;
        end if;
    end process c_reg;
    
    --Output
    c_data <= c_stored;
    
    
    
--MUX:
    
    process(mux_en, SEL, c_data, w_last)
    -- Combinational process MUX
    begin
        o_mem_data <= (others => '0');  --Default value
        
        if mux_en = '1' then
            case SEL is
                when '0' => o_mem_data <= w_last;
                when '1' => o_mem_data <= c_data;
                when others => o_mem_data <= (others => 'X');
            end case;
         end if;
    end process;
    

end project_reti_logiche_arch;