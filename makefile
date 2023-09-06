BOCHS:=bochs
BUILD:=build
TEST:=test
SRC:=src

$(BUILD)/master.img: $(BUILD)/boot.bin
	$(shell mkdir -p $(dir $@))
	yes | bximage -q -hd=16 -func=create -sectsize=512 -imgmode=flat $(BUILD)/master.img
	dd if=$(BUILD)/boot.bin of=$(BUILD)/master.img bs=512 count=1 conv=notrunc
	dd if=$(BUILD)/boot.bin of=$(BUILD)/master.img bs=512 count=1 seek=1 conv=notrunc

$(BUILD)/boot.bin: $(SRC)/boot.asm
	nasm -f bin $(SRC)/boot.asm -o $(BUILD)/boot.bin


.PHONY: bochs
bochs: $(BUILD)/master.img
	bochs -q -f $(BOCHS)/bochsrc


.PHONY: clean
clean:
	rm -rf $(BUILD)
