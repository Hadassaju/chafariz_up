library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity chafariz_tb is
end chafariz_tb;


architecture tb of chafariz_tb is

	component chafariz_up is
		    port (
		  clk, clr : in std_logic;
        a: in std_logic_vector(1 downto 0);
        c : in std_logic;
        d : out std_logic;
		  LED : out std_logic_vector(1 downto 0)
    );
	 end component chafariz_up;
	 
	 signal clk, clr, c, d: std_logic;
	 signal a : std_logic_vector (1 downto 0);
	 signal LED : std_logic_vector (1 downto 0);
	 
	 begin
		chaf_digital: chafariz_up port map (
			clr => clr,
			clk => clk,
			a => a,
			c => c,
			d => d,
			LED => LED
		);
	process
		begin
		-- Valores iniciais:
		clk <= '0';
		clr <= '1';
		a <= "00";--0,00 cents
		c <= '1';
		
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';	
		
		clr <= '0';
		
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		
		--Esperar
		
		a <= "01";-- add 0,25 cents
		
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';	
		
		--Somar
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
	
		--Esperar
		
		-- add + 0,25 cents
		
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';	
		
		--Somar
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		
		--Esperar
		a <= "10";-- add 0,50 cents
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		
		--Somar
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		
		--Esperar
		c <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';	
		
		--Fornecer
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		
		-- Inicio
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		
		wait;
		
	end process;

end tb;
