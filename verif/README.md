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

# 🧪 Como Testar seu Programa com o TestBench

1. Abra um terminal na pasta raiz do projeto.

2. Execute o seguinte comando:
    ```shell
    python3 verif\modelsim_testbench_run.py
    ```

O processo de compilação e simulação será iniciado, e os resultados serão exibidos no terminal.
