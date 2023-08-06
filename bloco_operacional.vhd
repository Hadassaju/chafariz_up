library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

entity bloco_operacional is
    port (
        a : in std_logic_vector(1 downto 0);
        clk, clr, tot_ld, tot_clr: in std_logic;
        tot_p: out std_logic_vector (2 downto 0)
    );
end bloco_operacional;

architecture arch of bloco_operacional is
	 signal p1 : std_logic_vector (3 downto 0) :="0001";
	 signal p2 : std_logic_vector (3 downto 0) :="0010";
	 signal p3 : std_logic_vector (3 downto 0) :="0011";
	 signal p4 : std_logic_vector (3 downto 0) :="0100";
	 signal a_4bits , tot : std_logic_vector (3 downto 0);
begin
		-- Definir valores possíveis das moedas (apenas 0,25; 0,50 e 1,00):
		a_4bits <= "0001" when a = "01" else -- moeda de 0,25 real
						"0010" when a = "10" else -- moeda de 0,50 real
						"0100" when a = "11" else -- moeda de 1,00 real
						"0000";
			process (a_4bits, clk, clr, tot_ld, tot_clr)
			begin
				 if clr = '1' then
					  tot <= "0000"; -- Reinicia o registrador_tot com valor 0
				 elsif rising_edge(clk) then
					  if tot_clr = '1' then 
							tot <= "0000";
					  elsif tot_ld = '1' then
							-- Atualiza tot com o resultado da soma
							tot <= std_logic_vector(unsigned(a_4bits) + unsigned(tot));
					  end if;
				 end if;	
			end process;

		 -- Define a saída com base na comparação: 
			process ( tot)
			begin
				--tot_p <= "000" when tot = "0000" else
							--"001" when tot = std_logic_vector(unsigned(p1)) else
							--"010" when tot = std_logic_vector(unsigned(p2)) else
							--"011" when tot = std_logic_vector(unsigned(p3)) else
							--"100";
					if tot = "0000" then
						tot_p <= "000";
				  elsif tot = p1 then
						tot_p <= "001"; -- Fornecer 5 L
				  elsif tot = p2 then
						tot_p <= "010"; -- Fornecer 10 L
				  elsif tot = p3 then
						tot_p <= "011"; -- Fornecer 15 L
				  elsif tot <= p4 then
						tot_p <= "100"; -- Fornecer 20 L (para tot = p4)
				  else
						tot_p <= "100"; -- Fornecer 20 L (para tot >= p4)
				  end if;
			end process;
end arch;
