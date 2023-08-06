library IEEE;
use IEEE.std_logic_1164.all;

entity chafariz_up is
    port (
		  clk, clr : in std_logic;
        a : in std_logic_vector(1 downto 0);
        c : in std_logic;
        d : out std_logic;
		  LED : out std_logic_vector(1 downto 0)
    );
end chafariz_up;

architecture rtl of chafariz_up is
	 signal tot_p_operacional : std_logic_vector (2 downto 0);
    signal tot_clr_controle, tot_ld_controle : std_logic;

    -- Declarar os blocos de controle e operacional
    component bloco_controle
        port (
            clk,clr , c : in std_logic;
				tot_p: in std_logic_vector (2 downto 0);
				d, tot_clr, tot_ld: out std_logic;
				LED : out std_logic_vector (1 downto 0)
					  );
    end component;

    component bloco_operacional
        port (
           a : in std_logic_vector(1 downto 0);
			  clk, clr, tot_ld, tot_clr: in std_logic;
			  tot_p: out std_logic_vector (2 downto 0)
			);
    end component;
	 
begin

    -- Port Map os blocos de controle e operacional
    controle_inst : bloco_controle
        port map (
            c => c,
				clr => clr,
				clk => clk,
            tot_p => tot_p_operacional,
            d => d,
            tot_clr => tot_clr_controle,
            tot_ld => tot_ld_controle,
            LED => LED
        );

    operacional_inst : bloco_operacional
        port map (
				clr => clr,
				clk => clk,
            a => a,
            tot_ld => tot_ld_controle,
            tot_clr => tot_clr_controle,
            tot_p => tot_p_operacional
        );
			
end rtl;
