# 📝 Como Inicializar a Memória de Instruções

## Com Python 3

1. Crie um arquivo chamado `instructions.txt` no mesmo diretório do script [`assembler.py`](assembler.py).

2. Escreva as instruções que deseja incluir na memória de instruções no arquivo, com cada instrução em uma linha separada.
    - As instruções devem ser escritas em assembly RISC-V. Consulte o arquivo [`assembler.py`](assembler.py) para verificar os formatos suportados.

3. Abra o terminal e execute o seguinte comando:
    ```shell
    python3 assembler.py
    ```

Se tudo estiver correto, um arquivo chamado `instruction.mif` será gerado no mesmo diretório do script.

## No Repl.it

1. Crie um repl do tipo Python no [Repl.it](https://repl.it/).

2. Copie o conteúdo do arquivo [`assembler.py`](assembler.py) para o arquivo `main.py` do seu repl.

3. Crie um arquivo chamado `instructions.txt` no mesmo diretório do script `main.py`.

4. Escreva as instruções que deseja incluir na memória de instruções no arquivo, com cada instrução em uma linha separada.
    - As instruções devem ser escritas em assembly RISC-V. Consulte o arquivo [`assembler.py`](assembler.py) para verificar os formatos suportados.

5. Execute o programa.

Se tudo estiver correto, um arquivo chamado `instruction.mif` será gerado e poderá ser baixado no menu lateral do repl.

# 🧪 Como Testar seu Programa com o Testbench

1. Abra o arquivo [`IF674-RISCV.mpf`](..\IF674-RISCV.mpf) como um projeto no ModelSim.

2. No terminal do ModelSim, execute o seguinte comando:
    ```shell
    do verif/RunTestBench
    ```

O processo de compilação e simulação será iniciado, e os resultados serão exibidos no terminal (transcript) do ModelSim. Além disso, uma janela de waveform será aberta, mostrando os sinais indicados em [`TestBench.sv`](TestBench.sv). Você pode usar essa janela para verificar mais detalhadamente o funcionamento do processador.
