library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_out_top is
    Port ( 
        clk_in                      : in  STD_LOGIC;
        reference_clk_out          : out STD_LOGIC;
        corrupted_clk_out          : out STD_LOGIC;
        glitch_signal_out          : out STD_LOGIC;
        ref_locked_led             : out STD_LOGIC;
        clean_locked_led           : out STD_LOGIC;
        clean_clk_out              : out STD_LOGIC;
        gpio_io_o                  : out std_logic_vector(15 downto 0)

    );
end clock_out_top;

architecture Behavioral of clock_out_top is
    -- Clock signals
    signal clk_ibuf           : STD_LOGIC;
    signal clk_global         : STD_LOGIC;
    signal clk_generated      : STD_LOGIC;
    signal fast_clk           : STD_LOGIC;
    signal clk_600mhz         : std_logic; 
    signal clean_clock        : STD_LOGIC;

    -- Glitch control
    signal glitch_gate        : STD_LOGIC := '0';
    signal glitch_active      : STD_LOGIC;
    signal glitch_mode        : STD_LOGIC := '0';
    signal glitch_mode_val    : STD_LOGIC;
    signal glitch_pwm_out     : STD_LOGIC;
    signal glitched_clk       : STD_LOGIC;
    

    -- Button debounce
    signal glitch_state_signal : STD_LOGIC := '0';
    signal captured            : STD_LOGIC := '0';
    

    signal test_counter       : unsigned(27 downto 0) := (others => '0');
    
    --Signal for Glitch Detection/Counter
    signal xor_result     : std_logic := '0';
    signal xor_prev       : std_logic := '0';
    signal glitching_done : std_logic := '1'; --Trigger For ILA
    signal glitch_pulse_seen : std_logic := '0';

    -- Dynamic glitch duration
    signal glitch_period      : unsigned(23 downto 0) := to_unsigned(10, 24);
    signal glitch_duty        : unsigned(23 downto 0) := to_unsigned(3, 24);
    constant STEP             : unsigned(23 downto 0) := to_unsigned(1, 24);
    constant MIN              : unsigned(23 downto 0) := to_unsigned(1, 24);
    constant MAX              : unsigned(23 downto 0) := to_unsigned(10, 24);
    signal lfsr_output        : unsigned(15 downto 0);
    signal request_new_val    : STD_LOGIC;



    
    --Signal Enable
    signal glitching_enabled : std_logic := '1';
    
    signal long_counter : unsigned(33 downto 0) := (others => '0');
    signal gpio_latched : std_logic_vector(15 downto 0) := (others => '0');

    
    
    --Random signal
    signal target_counter    : unsigned(27 downto 0) := to_unsigned(95000000, 28); -- initial target
    signal glitch_ready      : std_logic := '0';
    signal pseudo_rand       : unsigned(27 downto 0) := to_unsigned(71000000, 28); -- seed or init value
    signal glitch_mode_toggle : std_logic := '0';

    
    -- PLL status
    signal reset              : STD_LOGIC := '0';
    signal pll_locked         : STD_LOGIC;
    signal clean_pll_locked   : STD_LOGIC;

    -- Glitch pulse handling
    signal pwm_prev           : STD_LOGIC := '1';
    signal glitch_pending     : STD_LOGIC := '0';
    signal int_glitch_req   : std_logic := '0';
    
    -- Glitch packet queue (8 entries, 16-bit: [1 type_hazard | 8 tdc | 7 counter])
    type glitch_packet_array is array (0 to 7) of std_logic_vector(15 downto 0);
    signal glitch_fifo    : glitch_packet_array := (others => (others => '0'));
    
    -- FIFO control
    signal write_ptr         : integer range 0 to 7 := 0;
    signal display_ptr       : integer range 0 to 7 := 0;
    signal fifo_count        : integer range 0 to 8 := 0;
    
    
    -- Timer for auto-rotating the display_ptr every 10 ms)
    signal display_timer_600      : unsigned(22 downto 0) := (others => '0');  -- 0..~8.3M
    constant DISPLAY_INTERVAL_600 : unsigned(22 downto 0) := to_unsigned(5700000 - 1, 23);

    
    -- Output buffer to drive gpio_io_o
    signal gpio_out_data     : std_logic_vector(15 downto 0) := (others => '0');

    -- Debug Signals 
    signal fifo_count_slv : std_logic_vector(3 downto 0);  -- 4 bits enough to cover 0..8
    signal display_ptr_slv : std_logic_vector(2 downto 0);
    signal write_ptr_slv : std_logic_vector(2 downto 0);  -- 3 bits for values 0-7
    signal glitch_counter_latched : unsigned(6 downto 0) := (others => '0');
    signal glitch_latched_once : std_logic := '0';





    
    attribute MARK_DEBUG : string;
    attribute KEEP : string;
    
    attribute MARK_DEBUG of gpio_latched : signal is "true";
    attribute MARK_DEBUG of glitching_done : signal is "true";
    attribute MARK_DEBUG of fifo_count_slv : signal is "true";
    attribute KEEP of gpio_latched : signal is "true";
    attribute DONT_TOUCH : string;
    attribute DONT_TOUCH of ila_inst : label is "true";
    attribute KEEP of fifo_count_slv : signal is "true";
    signal glitch_fifo_debug_0 : std_logic_vector(15 downto 0);
    signal glitch_fifo_debug_1 : std_logic_vector(15 downto 0);
    
   
    attribute MARK_DEBUG of display_ptr_slv    : signal is "true";
    attribute MARK_DEBUG of glitch_fifo_debug_0  : signal is "true";
    attribute MARK_DEBUG of glitch_fifo_debug_1  : signal is "true";


    
        
    signal tdc_code_latched : std_logic_vector(7 downto 0) := (others => '0');

    


    
    --Signal for UART
    signal type_hazard          : STD_LOGIC := '0';
    signal glitch_counter : unsigned(6 downto 0) := (others => '0');

    component ila_0
        port (
            clk    : in STD_LOGIC;
            probe0 : in STD_LOGIC_VECTOR(3 downto 0);
            probe1 : in STD_LOGIC; 
            probe2 : in STD_LOGIC_VECTOR(15 downto 0);
            probe3:  in STD_LOGIC_VECTOR(2 downto 0);
            probe4:  in STD_LOGIC_VECTOR(15 downto 0);
            probe5:  in STD_LOGIC_VECTOR(15 downto 0);
            probe6:  in STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

    
    -- Component declarations
    component IBUF
        port ( I : in STD_LOGIC; O : out STD_LOGIC );
    end component;

    component BUFG
        port ( I : in STD_LOGIC; O : out STD_LOGIC );
    end component;

    component clk_wiz_0
        port ( clk_in1 : in STD_LOGIC; reset : in STD_LOGIC; clk_out1 : out STD_LOGIC; locked : out STD_LOGIC );
    end component;

    component clk_wiz_1
        port ( clk_in1 : in STD_LOGIC; reset : in STD_LOGIC; clk_out1 : out STD_LOGIC;  clk_out2 : out STD_LOGIC; locked : out STD_LOGIC );
    end component;
    


    component pwm_generator
        generic ( COUNTER_WIDTH : integer := 20 );
        port ( clk : in STD_LOGIC; duty_cycle : in unsigned(23 downto 0); period : in unsigned(23 downto 0); pwm_out : out STD_LOGIC );
    end component;


    component glitch_control_module
        Port (
            clk            : in STD_LOGIC;
            random_val     : in unsigned(15 downto 0);
            glitch_active  : in STD_LOGIC;
            glitch_req     : out STD_LOGIC;
            request_new    : out STD_LOGIC;
            glitch_mode_val: out STD_LOGIC
        );
    end component;


begin

    -- Clock Buffering
    ibuf_inst : IBUF
        port map ( I => clk_in, O => clk_ibuf );

    bufg_inst : BUFG
        port map ( I => clk_ibuf, O => clk_global );
    

    -- PLL Modules
    u_pll_slow : clk_wiz_0
        port map ( clk_in1 => clk_ibuf, reset => reset, clk_out1 => clk_generated, locked => pll_locked );

    u_pll_fast : clk_wiz_1
        port map ( clk_in1 => clk_ibuf, reset => reset, clk_out1 => fast_clk, clk_out2 => clk_600mhz, locked => open );

   ila_inst : ila_0
        port map (
            clk    => fast_clk,
            probe0 => std_logic_vector(fifo_count_slv), 
            probe1 => glitching_done,
            probe2 => std_logic_vector(gpio_latched),
            probe3 => std_logic_vector(write_ptr_slv),
            probe4 => std_logic_vector(glitch_fifo_debug_0),
            probe5 => std_logic_vector(glitch_fifo_debug_1),
            probe6 => std_logic_vector(glitch_counter)
        );  
        
    fifo_count_slv      <= std_logic_vector(to_unsigned(fifo_count, fifo_count_slv'length));
    display_ptr_slv     <= std_logic_vector(to_unsigned(display_ptr, display_ptr_slv'length));
    write_ptr_slv     <= std_logic_vector(to_unsigned(write_ptr, write_ptr_slv'length));

    -- PWM Generator for Glitch Pulse
    glitch_gen : pwm_generator
        generic map ( COUNTER_WIDTH => 24 )
        port map (
            clk => fast_clk,
            period => glitch_period,
            duty_cycle => glitch_duty,
            pwm_out => glitch_pwm_out
        );
       
    -- Glitch Control Module
    glitch_ctrl : glitch_control_module
        port map (
            clk            => clk_generated,
            random_val     => lfsr_output,
            glitch_active  => glitch_gate,
            glitch_req     => open,
            request_new    => request_new_val,
            glitch_mode_val=> glitch_mode_val
        );
    
 

   process(clk_generated)
    begin
        if rising_edge(clk_generated) then
    
            -- Increment test counter
            test_counter <= test_counter + 1;
    
            -- Trigger glitch if counter hits target
            if test_counter = target_counter then
                int_glitch_req <= '1';
                glitch_ready   <= '1';
                glitching_done  <= '0';
            else
                int_glitch_req <= '0';
            end if;
    
            -- Once glitch is triggered, assign new pseudo-random target
            if glitch_ready = '1' then
                -- Simple pseudo-random generator: rotate + add
                pseudo_rand <= pseudo_rand(25 downto 0) & pseudo_rand(27 downto 26);
                target_counter <= (pseudo_rand mod to_unsigned(90_000_000, 28)) + to_unsigned(50_000_000, 28);  -- [50M to 140M]
                glitch_ready   <= '0';
                glitch_mode_toggle <= not glitch_mode_toggle;  -- Alternate mode every glitch
            end if;
    
            -- Stop glitching after 7.5s (optional)
            if test_counter > to_unsigned(95_000_000, 28) then
                glitching_enabled <= '0';
              
            end if;
        end if;
    end process;


    -- Glitch Gate Logic
    process(fast_clk)
        begin
            if rising_edge(fast_clk) then
                if int_glitch_req = '1' and glitch_latched_once = '0' then
                    glitch_pending <= '1';
                    glitch_latched_once <= '1';  -- latch it so only one glitch occurs
                end if;
        
                if pwm_prev = '1' and glitch_pwm_out = '0' and glitch_pending = '1' then
                    glitch_gate <= '1';
                    glitch_mode <= glitch_mode_toggle;
                    glitch_pending <= '0';
                end if;
        
                if glitch_gate = '1' and glitch_pwm_out = '1' then
                    glitch_gate <= '0';
                end if;
        
                if int_glitch_req = '0' then
                    glitch_latched_once <= '0'; -- reset latch once request is deasserted
                end if;
        
                pwm_prev <= glitch_pwm_out;
            end if;
        end process;

       
    -- Glitch Generation Logic
    process(glitch_state_signal, clk_generated, glitch_pwm_out, glitch_gate)
    begin
        if glitch_gate = '1' then
            if glitch_mode = '1' then
                glitched_clk <= clk_generated AND glitch_pwm_out;
            else
                glitched_clk <= clk_generated OR (NOT clk_generated AND NOT glitch_pwm_out);
            end if;
        else
            glitched_clk <= clk_generated;
        end if;
    end process;

    -- LED Assignments
    ref_locked_led <= pll_locked;
    clean_locked_led <= clean_pll_locked;

    -- Output Logic
    reference_clk_out <=  clk_generated;
    corrupted_clk_out <= glitched_clk when glitching_enabled = '1' else '0';
    glitch_signal_out <= glitch_pwm_out;
    
    
    
-- Debug Buffer
glitch_fifo_debug_0 <= glitch_fifo(0);
glitch_fifo_debug_1 <= glitch_fifo(1);


process(clk_600mhz)
    begin
        if rising_edge(clk_600mhz) then
            -- Latch TDC code only when it's non-zero
            -- XOR glitch detection
            xor_result <= glitched_clk xor clk_generated;
    
            if xor_result = '1' and glitch_pulse_seen = '0' then
                glitch_counter <= glitch_counter + 1;
                glitch_pulse_seen <= '1';
    
                -- Determine hazard type based on clk_generated level
                if clk_generated = '1' then
                    type_hazard <= '1';
                else
                    type_hazard <= '0';
                end if;
    
            elsif xor_result = '0' then
                glitch_pulse_seen <= '0';
            end if;
        end if;
    end process;


    
    -- First bit: glitch state, next 8 bits: tdc time code: last 7 bits glitch counter.
    gpio_io_o <= type_hazard & tdc_code_latched & std_logic_vector(glitch_counter);





    
end Behavioral;