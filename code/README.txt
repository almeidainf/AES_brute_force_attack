UFRGS - INF

INF01045 - Segurança em Sistemas de Computação

Tiago de Almeida | Bruna Seewald

{talmeida | bruna.seewald}@inf.ufrgs.br

Desafio 5

--------

Compilador:

- Sabe-se que, para suporte às instruções Intel AES-NI, é necessário utilizar a
versão 4.4 ou mais recente do GCC.
Durante o desenvolvimento e teste desse código, utilizamos a versão 4.8.1 do
GCC e, portanto, aconselhamos que esta seja a versão utilizada para
compilação.

Compilando e executando:

- Execute o script "do":
	
	./do

- Execute o binário "ecb" e passe o arquivo de texto cifrado pela entrada
  padrão. Opcionalmente, execute com "time" para medir o tempo de execução:
	
	time ./ecb < input.txt

- Opcionalmente, para mudar o número de threads de execução, defina o
  parâmetro em tempo de compilação, editando o script "do". Se não definido, o
  valor padrão é 8:

  	-DNTHREADS=X

- Opcionalmente, para mudar o tamanho do texto cifrado de entrada (em bytes), defina o
  parâmetro em tempo de compilação, editando o script "do". Se não editado, o
  valor padrão é 32:

  	-DTOTAL_LENGTH=X

- Opcionalmente, para mudar o número de bytes lidos da entrada padrão para o
  processamento parcial do texto de entrada, defina o parâmetro em tempo de
  compilação, editando o script "do". Se não editado, o valor padrão é 32:

  	-DLENGTH=X
