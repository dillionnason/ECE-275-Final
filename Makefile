CC = quartus_sh
PGM = quartus_pgm

MAP = quartus_map
FIT = quartus_fit
ASM = quartus_asm
STA = quartus_sta

SETTINGS_ON = --read_settings_files=on --write_settings_files=off 
SETTINGS_OFF = --read_settings_files=off --write_settings_files=off 

MAP_FLAGS = --effort=fast --incremental_compilation=full_incremental_compilation
FIT_FLAGS = --effort=fast --incremental_signaltap --optimize_io_register_for_timing=off

SRC = $(wildcard *.sv)
BIN = $(wildcard *.sof)

all: fast program

full: $(SRC)
	$(CC) --flow compile $^ 

fast:
	$(MAP) $(SETTINGS_ON) $(MAP_FLAGS) pongtop -c pongtop
	$(FIT) $(SETTINGS_OFF) $(FIT_FLAGS) pongtop -c pongtop
	$(ASM) $(SETTINGS_OFF) pongtop -c pongtop

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

