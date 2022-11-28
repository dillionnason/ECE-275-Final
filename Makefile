CC = quartus_sh
PGM = quartus_pgm

SRC = $(wildcard *.sv)
BIN = $(wildcard *.sof)

all: $(SRC)
	$(CC) --flow compile $^ 

devices:
	$(PGM) --auto

program: $(BIN) 
	$(PGM) -m jtag -o "p;$^"

prepare: lsp-config
	@read -p "Enter project name:" project_name; \
	$(CC) --prepare -d EP3C16F484C6 -t $${project_name}top $${project_name}top; \
	touch $${project_name}top.sv; \
	echo "module $${project_name}top ();" >> $${project_name}top.sv; \
	echo "" >> $${project_name}top.sv; \
	echo "endmodule" >> $${project_name}top.sv

lsp-config:
	@touch .svls.toml
	@echo "[verilog]" 						>> .svls.toml
	@echo "defines = [\"DEBUG\"]" >> .svls.toml
	@echo "" 											>> .svls.toml
	@echo "[option]" 							>> .svls.toml
	@echo "linter = true" 				>> .svls.toml

