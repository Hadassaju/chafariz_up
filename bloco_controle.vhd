library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all; -- Para operações com std_logic_vector

entity bloco_controle is
    port (
        clk, clr, c: in std_logic;
        tot_p: in std_logic_vector (2 downto 0);
        d, tot_clr, tot_ld: out std_logic;
        LED: out std_logic_vector (1 downto 0)
    );
end bloco_controle;

architecture arch_ctrl of bloco_controle is
    -- Definir estados:
    type tipo_estado is (
        inicial,
        esperar,
        somar,
        fornecer
    );

    signal estado: tipo_estado;

    -- Contador para controlar o tempo de fornecimento
    signal contador: integer range 0 to 240 := 0; -- 240 representa 4 minutos (4 * 60 segundos)

    -- Constantes para definir os tempos de fornecimento em ciclos de clock
    constant tempo_fornecer_025: integer := 60;    -- 1 minuto (60 ciclos de clock)
    constant tempo_fornecer_050: integer := 120;   -- 2 minutos (120 ciclos de clock)
    constant tempo_fornecer_075: integer := 180;   -- 3 minutos (180 ciclos de clock)
    constant tempo_fornecer_100: integer := 240;   -- 4 minutos (240 ciclos de clock)

begin

    -- Processo para a máquina de estados finitos (FSM)
    process (clr, clk)
    begin
        -- Definir as regras de transição de estados
        if (clr = '1') then
            estado <= inicial;
            contador <= 0;
            LED <= "00"; -- Valor dos LEDs para o estado_inicial
        elsif (rising_edge(clk)) then
            case estado is
                when inicial =>
                    estado <= esperar;
                    LED <= "01"; -- Valor dos LEDs para o estado_esperar
                when esperar =>
                    if c = '0' then
                        case tot_p is
                            when "000" =>
                                estado <= esperar;
                                LED <= "01"; -- Valor dos LEDs para o estado_esperar
                            when "001" =>
                                estado <= fornecer; -- Fornecer p 0,25
                                LED <= "11"; -- Valor dos LEDs para o estado_fornecer
                            when "010" =>
                                estado <= fornecer; -- Fornecer p 0,50
                                LED <= "11"; -- Valor dos LEDs para o estado_fornecer
                            when "011" =>
                                estado <= fornecer; -- Fornecer p/ 0,75
                                LED <= "11"; -- Valor dos LEDs para o estado_fornecer
                            when others =>
                                estado <= fornecer; -- Fornecer p 1,00
                                LED <= "11"; -- Valor dos LEDs para o estado_fornecer
                        end case;
                    else
                        estado <= somar;
                        LED <= "10"; -- Valor dos LEDs para o estado_somar
                    end if;
                when somar =>
                    estado <= esperar;
                    LED <= "01"; -- Valor dos LEDs para o estado_esperar
                when fornecer =>
                    -- Verifica o tempo de fornecimento correto com base em tot_p
                    case tot_p is
                        when "001" =>
                            -- Tempo de fornecimento para 0,25 (1 minuto)
                            if contador < tempo_fornecer_025 then
                                contador <= contador + 1;
                                estado <= fornecer;
                            else
                                contador <= 0;
                                estado <= inicial;
                            end if;
                        when "010" =>
                            -- Tempo de fornecimento para 0,50 (2 minutos)
                            if contador < tempo_fornecer_050 then
                                contador <= contador + 1;
                                estado <= fornecer;
                            else
                                contador <= 0;
                                estado <= inicial;
                            end if;
                        when "011" =>
                            -- Tempo de fornecimento para 0,75 (3 minutos)
                            if contador < tempo_fornecer_075 then
                                contador <= contador + 1;
                                estado <= fornecer;
                            else
                                contador <= 0;
                                estado <= inicial;
                            end if;
                        when others =>
                            -- Tempo de fornecimento para 1,00 (4 minutos)
                            if contador < tempo_fornecer_100 then
                                contador <= contador + 1;
                                estado <= fornecer;
                            else
                                contador <= 0;
                                estado <= inicial;
                            end if;
                    end case;

                    LED <= "11"; -- Valor dos LEDs para o estado_fornecer
            end case;
        end if;
    end process;

    tot_clr <= '1' when estado = inicial else '0';
    tot_ld <= '1' when estado = somar else '0';
    d <= '1' when estado = fornecer else '0';

end arch_ctrl;

